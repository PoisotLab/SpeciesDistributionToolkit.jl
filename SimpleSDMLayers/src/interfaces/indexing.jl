function _point_to_cartesian(layer::T, c::Point) where {T <: SimpleSDMLayer}
    lon = SimpleSDMLayers._match_longitude(layer, c[1])
    lat = SimpleSDMLayers._match_latitude(layer, c[2])
    isnothing(lon) && return nothing
    isnothing(lat) && return nothing
    return CartesianIndex(lat, lon)
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

function Base.getindex(layer::T, longitude::AbstractFloat, latitude::AbstractFloat) where {T <: SimpleSDMLayer}
    return layer[Point(longitude,latitude)]
end

function Base.getindex(layer::T, c::Point) where {T <: SimpleSDMLayer}
    return layer[_point_to_cartesian(layer, c)]
end

function Base.getindex(layer::T, c::Array{<:Point}) where {T <: SimpleSDMLayer}
    return layer[[_point_to_cartesian(layer, i) for i in c]]
end

function Base.getindex(::T, ::Nothing) where {T <: SimpleSDMLayer}
    return nothing
end

function Base.setindex!(layer::T, v, i::CartesianIndex{2}) where {T <: SimpleSDMResponse}
    return setindex!(layer.grid, v, i)
end

function Base.setindex!(layer::T, v, i::Array{CartesianIndex{2}}) where {T <: SimpleSDMLayer}
    return layer.grid[i] = v
end