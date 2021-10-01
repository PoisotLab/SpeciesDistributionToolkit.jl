function _raster_to_cartesian(layer::T, c::RasterCoordinate) where {T <: SimpleSDMLayer}
    lat = SimpleSDMLayers._match_latitude(layer, GeoInterface.ycoord(c))
    lon = SimpleSDMLayers._match_longitude(layer, GeoInterface.xcoord(c))
    return CartesianIndex(lon, lat)
end

function Base.CartesianIndices(layer::T) where {T <: SimpleSDMLayer}
    return CartesianIndices(layer.grid)
end

function Base.getindex(layer::T, i::CartesianIndex{2}) where {T <: SimpleSDMLayer}
    return layer.grid[i]
end

function Base.getindex(layer::T, i::Integer) where {T <: SimpleSDMLayer}
    return layer.grid[CartesianIndices(layer)[i]]
end

function Base.getindex(layer::T, i::Integer, j::Integer) where {T <: SimpleSDMLayer}
    return layer.grid[CartesianIndex(i,j)]
end

function Base.getindex(layer::T, i::Vector{CartesianIndex{2}}) where {T <: SimpleSDMLayer}
    return layer.grid[i]
end

function Base.setindex!(layer::T, v, i::CartesianIndex{2}) where {T <: SimpleSDMResponse}
    return setindex!(layer.grid, v, i)
end

function Base.setindex!(layer::T, v, i::Array{CartesianIndex{2}}) where {T <: SimpleSDMLayer}
    return layer.grid[i] = v
end

function Base.getindex(layer::T, i::AbstractFloat, j::AbstractFloat) where {T <: SimpleSDMLayer}
    return layer[RasterCoordinate(i,j)]
end

function Base.getindex(layer::T, c::RasterCoordinate) where {T <: SimpleSDMLayer}
    return layer[_raster_to_cartesian(layer, c)]
end

function Base.getindex(layer::T, c::Array{<:RasterCoordinate}) where {T <: SimpleSDMLayer}
    return layer[[_raster_to_cartesian(layer, i) for i in c]]
end
