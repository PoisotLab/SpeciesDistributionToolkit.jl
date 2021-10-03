function Base.iterate(layer::T) where {T <: SimpleSDMLayer}
    position = findfirst(!isnothing, layer.grid)
    isnothing(position) && return nothing
    value = layer.grid[position]
    coordinates = Point(longitudes(layer)[last(position.I)], latitudes(layer)[first(position.I)])
    return (coordinates => value, position)
end

function Base.iterate(layer::T, state) where {T <: SimpleSDMLayer}
    newstate = LinearIndices(layer.grid)[state]+1
    newstate > prod(size(layer.grid)) && return nothing
    position = findnext(!isnothing, layer.grid, CartesianIndices(layer.grid)[newstate])
    isnothing(position) && return nothing
    value = layer.grid[position]
    coordinates = Point(longitudes(layer)[last(position.I)], latitudes(layer)[first(position.I)])
    return (coordinates => value, position)
end

#Base.IteratorSize(::T) where {T <: SimpleSDMLayer} = Base.HasShape{2}()
Base.IteratorEltype(::T) where {T <: SimpleSDMLayer} = Base.EltypeUnknown()
