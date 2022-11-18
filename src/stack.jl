"""
    SimpleSDMStack

Stores multiple _references_ to layers
"""
struct SimpleSDMStack
    names::Vector{String}
    layers::Vector{Base.RefValue}
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
