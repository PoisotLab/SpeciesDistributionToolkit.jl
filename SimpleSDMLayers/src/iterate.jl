function Base.iterate(layer::SDMLayer)
    iszero(count(layer)) && return nothing
    i0 = findfirst(layer.indices)
    return (layer[i0],i0)
end

function Base.iterate(layer::SDMLayer, state)
    newstate = LinearIndices(layer.grid)[state] + 1
    newstate > prod(size(layer)) && return nothing
    position = findnext(layer.indices, CartesianIndices(layer.grid)[newstate])
    isnothing(position) && return nothing
    return (layer[position], position)
end