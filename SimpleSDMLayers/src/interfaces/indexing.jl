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
    @info "lul"
    return X.grid[i] = v
end