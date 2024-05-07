"""
    SDMLayer{T}

Defines a layer of geospatial information.

The type has two data fields:

- **grid**: a `Matrix` of type `T`
- **nodata**: a single value of type `T`, which indicates missing data - the
  default value is the `typemin(T)`, but this value should be set according to
  the content of the file you are reading

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
    nodata::T = typemin(T)
    x::Tuple = (-180.0, 180.0)
    y::Tuple = (-90.0, 90.0)
    crs::String = "EPSG:4326"
end

function SDMLayer(grid::Matrix; kwargs...)
    T = eltype(grid)
    return SDMLayer{T}(; grid=grid, kwargs...)
end

@testitem "We can construct a SDMLayer with all data" begin
    m = rand(0x00:0x02, (10, 20))
    nodata = typemax(eltype(m))
    crs = "EPSG:4326"
    layer = SDMLayer(m, nodata, (10.0, 20.0), (30.0, 40.0), crs)
    @test typeof(layer.grid) == Matrix{eltype(m)}
end

@testitem "We can construct a SDMLayer using only the grid of values" begin
    m = rand(0x00:0x02, (10, 20))
    layer = SDMLayer(m)
    @test typeof(layer.grid) == Matrix{eltype(m)}
    @test layer.crs == "EPSG:4326"
    @test layer.nodata == typemin(eltype(m))
end

@testitem "We can construct a SDMLayer the grid of values and kwargs" begin
    m = rand(0x00:0x02, (10, 20))
    layer = SDMLayer(m; nodata=0x06)
    @test typeof(layer.grid) == Matrix{eltype(m)}
    @test layer.crs == "EPSG:4326"
    @test layer.nodata == 0x06
end

"""
    nodata!(layer::SDMLayer{T}, nodata::T) where {T}

Changes the value of the layer representing no data. This modifies the layer
passed as its first argument.
"""
function nodata!(layer::SDMLayer{T}, nodata::T) where {T}
    layer.nodata = nodata
    return layer
end

@testitem "We can change the nodata value of a layer" begin
    layer = SDMLayers.__demodata(reduced=true)
    nodata!(layer, typemax(eltype(layer)))
    @test layer.nodata == typemax(eltype(layer))
end
