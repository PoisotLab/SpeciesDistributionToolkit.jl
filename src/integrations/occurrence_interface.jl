import Base: getindex
import Base: setindex!
import SimpleSDMLayers: mask!, mask

"""
    Base.getindex(p::T, occ::AbstractOccurrence)

Extracts the value of a layer at a given position for a `AbstractOccurrence`. If the
`AbstractOccurrence` has no latitude or longitude, this will return `nothing`.
"""
function Base.getindex(layer::SDMLayer, occ::T) where {T <: AbstractOccurrence}
    ismissing(place(occ)) && return nothing
    return layer[place(occ)...]
end

"""
    Base.setindex!(layer::SDMLayer, v, occ::T) where {T <: AbstractOccurrence}

Changes the values of the cell including the point at the requested latitude and
longitude.
"""
function Base.setindex!(layer::SDMLayer{T}, v, occ::O) where {T, O <: AbstractOccurrence}
    ismissing(place(occ)) && return nothing
    return setindex!(layer, v, place(occ)...)
end

"""
    Base.getindex(layer::SDMLayer, occ::T) where {T <: AbstractOccurrenceCollection}

Returns the values of a layer at all occurrences in a `AbstractOccurrenceCollection`.
"""
function Base.getindex(layer::SDMLayer, occ::T) where {T <: AbstractOccurrenceCollection}
    K = eltype(layer)
    return convert(
        Vector{K},
        filter(!isnothing, [layer[o] for o in elements(occ)]),
    )
end

function SimpleSDMLayers.quantize(
    layer::SDMLayer,
    occ::T,
) where {T <: AbstractOccurrenceCollection}
    ef = StatsBase.ecdf(layer[occ])
    return ef.(layer)
end

function SimpleSDMLayers.mask(
    layer::SDMLayer,
    occ::T,
) where {T <: AbstractOccurrenceCollection}
    out = zeros(layer, Bool)
    for record in elements(occ)
        out[record] = presence(record)
    end
    return out
end

function SimpleSDMLayers.mask(
    layer::SDMLayer,
    occ::O,
    ::Type{T},
) where {T <: Number, O <: AbstractOccurrenceCollection}
    out = zeros(layer, T)
    for record in elements(occ)
        out[record] += one(T)
    end
    return out
end
