"""
    SimpleSDMStack

Stores multiple _references_ to layers alongside with their names. This is mostly useful because it provides an interface that we can use as a Tables.jl provider.
"""
struct SimpleSDMStack
    names::Vector{String}
    layers::Vector{Base.RefValue}
    function SimpleSDMStack(names::Vector{String}, layers::Vector{Base.RefValue})
        # As many names as layers
        @assert length(names) == length(layers)
        # Layers have the correct type
        @assert all([typeof(layer.x) <: SimpleSDMLayer for layer in layers])
        # Layers are all compatible
        @assert all([
            SimpleSDMLayers._layers_are_compatible(first(layers).x, layer.x) for
            layer in layers
        ])
        # Layers all have the same keys
        @assert all([
            sort(keys(first(layers).x)) == sort(keys(layer.x)) for layer in layers
        ])
        # Return if all pass
        return new(names, layers)
    end
end

Base.length(s::T) where {T <: SimpleSDMStack} = length(first(s.layers).x)
Base.names(s::T) where {T <: SimpleSDMStack} = s.names
SimpleSDMLayers.latitudes(s::T) where {T <: SimpleSDMStack} = latitudes(first(s.layers).x)
SimpleSDMLayers.longitudes(s::T) where {T <: SimpleSDMStack} = longitudes(first(s.layers).x)
SimpleSDMLayers.boundingbox(s::T) where {T <: SimpleSDMStack} =
    boundingbox(first(s.layers).x)

Base.IteratorSize(::T) where {T <: SimpleSDMStack} = Base.HasLength()
function Base.IteratorEltype(s::T) where {T <: SimpleSDMStack}
    varnames = [:longitude, :latitude, Symbol.(names(s))...]
    vartypes = [
        eltype(longitudes(s)),
        eltype(latitudes(s)),
        [SimpleSDMLayers._inner_type(l.x) for l in s.layers]...,
    ]
    return NamedTuple{tuple(varnames...), Tuple{vartypes...}}
end

function Base.iterate(s::SimpleSDMStack)
    position = findfirst(!isnothing, s.layers[1].x.grid)
    lon = longitudes(s)[last(position.I)]
    lat = latitudes(s)[first(position.I)]
    vals = [l.x[lon, lat] for l in s.layers]
    varnames = [:longitude, :latitude, Symbol.(names(s))...]
    return (NamedTuple{tuple(varnames...)}(tuple(lon, lat, vals...)), position)
end

function Base.iterate(s::SimpleSDMStack, state)
    newstate = LinearIndices(s.layers[1].x.grid)[state] + 1
    newstate > prod(size(s.layers[1].x.grid)) && return nothing
    position = findnext(
        !isnothing,
        s.layers[1].x.grid,
        CartesianIndices(s.layers[1].x.grid)[newstate],
    )
    isnothing(position) && return nothing
    lon = longitudes(s)[last(position.I)]
    lat = latitudes(s)[first(position.I)]
    vals = [l.x[lon, lat] for l in s.layers]
    varnames = [:longitude, :latitude, Symbol.(names(s))...]
    return (NamedTuple{tuple(varnames...)}(tuple(lon, lat, vals...)), position)
end

Tables.istable(::Type{SimpleSDMStack}) = true
Tables.rowaccess(::Type{SimpleSDMStack}) = true
function Tables.schema(s::SimpleSDMStack)
    tp = first(s)
    sc = Tables.Schema(keys(tp), typeof.(values(tp)))
    return sc
end
