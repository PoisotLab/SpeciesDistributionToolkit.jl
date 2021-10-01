function Base.CartesianIndices(layer::T) where {T <: SimpleSDMLayer}
    return CartesianIndices(layer.grid)
end

function Base.getindex(X::T, i::CartesianIndex{2}) where {T <: SimpleSDMLayer}
    return X.grid[i]
end

function Base.getindex(X::T, i::Vector{CartesianIndex{2}}) where {T <: SimpleSDMLayer}
    return X.grid[i]
end

function Base.setindex!(X::T, v, i::CartesianIndex{2}) where {T <: SimpleSDMResponse}
    return setindex!(X.grid, v, i)
end

function Base.setindex!(X::T, v, i::Array{CartesianIndex{2}}) where {T <: SimpleSDMLayer}
    return X.grid[i] = v
end

function _raster_to_cartesian(layer::T, c::RasterCoordinate) where {T <: SimpleSDMLayer}
    lat = SimpleSDMLayers._match_latitude(layer, GeoInterface.ycoord(c))
    lon = SimpleSDMLayers._match_longitude(layer, GeoInterface.xcoord(c))
    return CartesianIndex(lon, lat)
end

function Base.getindex(X::T, c::RasterCoordinate) where {T <: SimpleSDMLayer}
    return X[_raster_to_cartesian(X, c)]
end

function Base.getindex(X::T, c::Array{<:RasterCoordinate}) where {T <: SimpleSDMLayer}
    return X[[_raster_to_cartesian(X, i) for i in c]]
end
