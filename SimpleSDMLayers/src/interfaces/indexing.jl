function _point_to_cartesian(layer::T, c::Point) where {T <: SimpleSDMLayer}
    lon = SimpleSDMLayers._match_longitude(layer, c[1])
    lat = SimpleSDMLayers._match_latitude(layer, c[2])
    isnothing(lon) && return nothing
    isnothing(lat) && return nothing
    return CartesianIndex(lat, lon)
end

"""
    Base.CartesianIndices(layer::T) where {T <: SimpleSDMLayer}

This function is used to access the positions in a layer as cartesian indices.
Internally, although it may be more convenient to access positions by their
coordinates, the value of the raster are extracted using their cartesian
coordinates.
"""
function Base.CartesianIndices(layer::T) where {T <: SimpleSDMLayer}
    return CartesianIndices(layer.grid)
end

"""
    Base.getindex(layer::T, i::CartesianIndex{2}) where {T <: SimpleSDMLayer}

Returns the value stored at a given cartesian index.
"""
function Base.getindex(layer::T, i::CartesianIndex{2}) where {T <: SimpleSDMLayer}
    return layer.grid[i]
end

"""
    Base.getindex(layer::T, i::Integer) where {T <: SimpleSDMLayer}

Returns the value stored at a linear index (a good candidate for deprecation as
we have a better iteration interface now).
"""
function Base.getindex(layer::T, i::Integer) where {T <: SimpleSDMLayer}
    return layer.grid[CartesianIndices(layer)[i]]
end

"""
    Base.getindex(layer::T, i::Integer, j::Integer) where {T <: SimpleSDMLayer}

Standard abstract array accession, where the dimensions follow the dimensions of
the underlying grid.
"""
function Base.getindex(layer::T, i::Integer, j::Integer) where {T <: SimpleSDMLayer}
    return layer.grid[CartesianIndex(i,j)]
end

"""
    Base.getindex(layer::T, i::Array{CartesianIndex{2}}) where {T <: SimpleSDMLayer}

Returns an array of values based on an array of cartesian indices - this can be
a vector or a matrix, and the elements can be in any order. This will *not*
return a raster.
"""
function Base.getindex(layer::T, i::Array{CartesianIndex{2}}) where {T <: SimpleSDMLayer}
    return layer.grid[i]
end

"""
    Base.getindex(layer::T, longitude::AbstractFloat, latitude::AbstractFloat) where {T <: SimpleSDMLayer}

Returns a value by longitude and latitude.
"""
function Base.getindex(layer::T, longitude::AbstractFloat, latitude::AbstractFloat) where {T <: SimpleSDMLayer}
    return layer[Point(longitude,latitude)]
end

"""
    Base.getindex(layer::T, c::Point) where {T <: SimpleSDMLayer}

Access a value through a `Point` (from `GeometryBasics`), which has the
longitude first and the latitude last -- this follows the GeoJSON convention.
"""
function Base.getindex(layer::T, c::Point) where {T <: SimpleSDMLayer}
    return layer[_point_to_cartesian(layer, c)]
end

"""
    Base.getindex(layer::T, c::Array{<:Point}) where {T <: SimpleSDMLayer}

Access a value through an array of `Point` (from `GeometryBasics`), which has
the longitude first and the latitude last. The array can be in any order, so
this method will not return a raster.
"""
function Base.getindex(layer::T, c::Array{<:Point}) where {T <: SimpleSDMLayer}
    return layer[[_point_to_cartesian(layer, i) for i in c]]
end

"""
    Base.getindex(::T, ::Nothing) where {T <: SimpleSDMLayer}

If the user requests a point that is out of bounds, its cartesian coordinate
will be matched to `nothing`, and then we return `nothing`.
"""
function Base.getindex(::T, ::Nothing) where {T <: SimpleSDMLayer}
    return nothing
end

"""
    Base.getindex(layer::T, p1::Point, p2::Point) where {T <: SimpleSDMLayer}

Return a raster by defining a bounding box through two points. The order of the
points (in terms of bottom/top/left/right) is not really important, as the
correct coordinates will be extracted.
"""
function Base.getindex(layer::T, p1::Point, p2::Point) where {T <: SimpleSDMLayer}
    latextr = extrema([p1[2], p2[2]])
    lonextr = extrema([p1[1], p2[1]])
    pmin = _point_to_cartesian(layer, Point(minimum(lonextr), minimum(latextr)))
    pmax = _point_to_cartesian(layer, Point(maximum(lonextr), maximum(latextr)))
    R = T <: SimpleSDMResponse ? SimpleSDMResponse : SimpleSDMPredictor
    return R(
        layer.grid[pmin:pmax], 
        longitudes(layer)[last(pmin.I)]-stride(layer, dims=1),
        longitudes(layer)[last(pmax.I)]+stride(layer, dims=1),
        latitudes(layer)[first(pmin.I)]-stride(layer, dims=2),
        latitudes(layer)[first(pmax.I)]+stride(layer, dims=2)
    )
end

function Base.setindex!(layer::T, v, i::CartesianIndex{2}) where {T <: SimpleSDMResponse}
    return setindex!(layer.grid, v, i)
end

function Base.setindex!(layer::T, v, i::Array{CartesianIndex{2}}) where {T <: SimpleSDMLayer}
    return layer.grid[i] = v
end