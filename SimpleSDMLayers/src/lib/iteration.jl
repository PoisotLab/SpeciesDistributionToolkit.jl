Base.IteratorSize(::Type{T}) where {T <: SimpleSDMLayer} = Base.HasLength()
Base.IteratorEltype(::Type{T}) where {T <: SimpleSDMLayer} = Base.HasEltype()

function Base.getindex(layer::T, i::CartesianIndex{2}) where {T <: SimpleSDMLayer}
    return layer.grid[i]
end

function Base.iterate(layer::T) where {T <: SimpleSDMLayer}
    length(layer) == 0 && return nothing
    idx = findfirst(!isnothing, layer.grid)
    return (layer[idx], LinearIndices(layer.grid)[idx])
end

function Base.iterate(layer::T, state) where {T <: SimpleSDMLayer}
    state == prod(size(layer)) && return nothing
    idx = findnext(!isnothing, layer.grid, CartesianIndices(layer.grid)[state+1])
    isnothing(idx) && return nothing
    return (layer[idx], LinearIndices(layer.grid)[idx])
end

function Base.length(layer::T) where {T <: SimpleSDMLayer}
    return count(!isnothing, layer.grid)
end