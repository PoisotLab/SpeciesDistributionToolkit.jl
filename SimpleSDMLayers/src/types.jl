"""
    SDMLayer{T}

Defines a layer of geospatial information.

The type has two data fields:

- **grid**: a `Matrix` of type `T`
- **indices**: a `BitMatrix` to see which positions are valued

Each *row* in the `grid` field represents a slice of the raster of equal
*northing*, *i.e.* the information is laid out in the matrix as it would be
represented on a map once displayed. Similarly, columns have the same *easting*.

The geospatial information is represented by three positional fields:

- **x** and **y**: two tuples, indicating the coordinates of the *corners*
  alongside the *x* and *y* dimensions (e.g. easting/northing) - the default
  values are `(-180., 180.)` and `(-90., 90.)`, which represents the entire
  surface of the globe in WGS84
- **crs**: any `String` representation of the CRS which can be handled by
  `Proj.jl` - the default is  `"EPSG:4326"`, which represents a
  latitude/longitude coordinate system
"""
Base.@kwdef mutable struct SDMLayer{T}
    grid::Matrix{T}
    indices::BitMatrix
    x::Tuple = (-180.0, 180.0)
    y::Tuple = (-90.0, 90.0)
    crs::String = "EPSG:4326"
end

function SDMLayer(grid::Matrix; kwargs...)
    T = eltype(grid)
    idx = :nodata in keys(kwargs) ? (grid .!= values(kwargs).nodata) : BitArray(ones(size(grid)))
    return SDMLayer{T}(; grid=grid, indices=idx, Base.tail((nodata=nothing, kwargs...))...)
end

@testitem "We can construct a SDMLayer with all data" begin
    m = rand(0x00:0x02, (10, 20))
    idx = BitArray(ones(size(m)))
    crs = "EPSG:4326"
    layer = SDMLayer(m, idx, (10.0, 20.0), (30.0, 40.0), crs)
    @test typeof(layer.grid) == Matrix{eltype(m)}
end

@testitem "We can construct a SDMLayer using only the grid of values" begin
    m = rand(0x00:0x02, (10, 20))
    layer = SDMLayer(m)
    @test typeof(layer.grid) == Matrix{eltype(m)}
    @test layer.crs == "EPSG:4326"
end

@testitem "We can construct a SDMLayer the grid of values and kwargs" begin
    m = rand(0x00:0x02, (10, 20))
    layer = SDMLayer(m; nodata=0x01)
    @test count(layer) < prod(size(m))
    @test typeof(layer.grid) == Matrix{eltype(m)}
    @test layer.crs == "EPSG:4326"
end

"""
    nodata!(layer::SDMLayer{T}, nodata::T) where {T}

Changes the value of the layer representing no data. This modifies the layer
passed as its first argument.
"""
function nodata!(layer::SDMLayer{T}, nodata::T) where {T}
    new_nodata = layer.grid .== nodata
    layer.indices = layer.indices .& (.! new_nodata)
    return layer
end

@testitem "We can change the nodata value of a layer with a value" begin
    m = rand(0x00:0x02, (10, 20))
    layer = SDMLayer(m; nodata=0x01)
    ol = count(layer)
    nodata!(layer, 0x00)
    @test length(layer) < ol
    @test layer.crs == "EPSG:4326"
end

"""
    nodata!(layer::SDMLayer{T}, f)

Removes the data matching a function
"""
function nodata!(layer::SDMLayer, f::T) where {T <: Function}
    new_nodata = f.(layer.grid)
    layer.indices = layer.indices .& (.! new_nodata)
    return layer
end

@testitem "We can change the nodata value of a layer with a function" begin
    m = rand(0x00:0x02, (10, 20))
    layer = SDMLayer(m)
    ol = length(layer)
    nodata!(layer, ==(0x01))
    @test length(layer) < ol
    @test layer.crs == "EPSG:4326"
end

function nodata!(layer::SDMLayer, v)
    return nodata!(layer, convert(eltype(layer), v))
end


"""
    nodata(layer::SDMLayer, args...)

Makes a copy and calls `nodata!` on it
"""
function nodata(layer::SDMLayer, args...)
    c = copy(layer)
    return nodata!(c, args...)
end

@testitem "We can do nodata with a different type" begin
    m = rand(0x00:0x02, (10, 20))
    layer = SDMLayer(m)
    ol = length(layer)
    nodata!(layer, 1)
    @test length(layer) < ol
    @test layer.crs == "EPSG:4326"
end

@testitem "We can do nodata with a copy" begin
    m = rand(0x00:0x02, (10, 20))
    layer = SDMLayer(m)
    ol = length(layer)
    nl = nodata(layer, 1)
    @test length(nl) < length(layer)
    @test layer.crs == "EPSG:4326"
end

function _layers_are_compatible(l1::SDMLayer, l2::SDMLayer)
    l1.crs == l2.crs || return false
    l1.x == l2.x || return false
    l1.y == l2.y || return false
    return true
end

function _layers_are_compatible(layers::Vector{T}) where {T <: SDMLayer}
    return all(l -> _layers_are_compatible(l, layers[1]), layers)
end

function eastings(layer::SDMLayer)
    Δx = (layer.x[2]-layer.x[1])/(2size(layer, 2))
    return LinRange(layer.x[1]+Δx, layer.x[2]-Δx, size(layer, 2))
end

@testitem "We get the correct eastings from a layer" begin
    l = SDMLayer(rand(0x00:0x02, (19, 37)))
    e = eastings(l)
    @test e[19] ≈ 0.0
    @test e[1] ≈ -175.0 atol=0.2
    @test e[37] ≈ 175.0 atol=0.2
end

function northings(layer::SDMLayer)
    Δy = (layer.y[2]-layer.y[1])/(2size(layer, 1))
    return LinRange(layer.y[1]+Δy, layer.y[2]-Δy, size(layer, 1))
end

@testitem "We get the correct northings from a layer" begin
    l = SDMLayer(rand(0x00:0x02, (19, 37)))
    n = northings(l)
    @test n[10] ≈ 0.0
    @test n[1] ≈ -90.0 atol=5.0
    @test n[19] ≈ 90.0 atol=5.0
end