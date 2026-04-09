import Base: getindex
import Base: setindex!
import SimpleSDMLayers: mask!, mask
import OccurrencesInterface: Occurrences

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

function Base.getindex(layer::Vector{<:SDMLayer}, occ::T) where {T <: AbstractOccurrenceCollection}
    return permutedims(hcat([l[occ] for l in layer]...))
end

function Base.getindex(layer::Vector{<:SDMLayer}, occ::Vector{<:AbstractOccurrence})
    return permutedims(hcat([l[occ] for l in layer]...))
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
    f=presences
) where {T <: AbstractOccurrenceCollection}
    out = zeros(layer, Bool)
    for record in f(occ)
        out[record] = true
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

function OccurrencesInterface.Occurrences(L::SDMLayer{Bool}; entity::String = "")
    E, N = eastings(L), northings(L)
    prj = SpeciesDistributionToolkit._projector(
        SimpleSDMLayers.AG.toPROJ4(projection(L)),
        "EPSG:4326",
    )
    occ = Occurrence[]
    for k in keys(L)
        coord = prj(E[k[2]], N[k[1]])
        push!(occ,
            Occurrence(; what = entity, where = coord, presence = L[k]),
        )
    end
    return Occurrences(occ)
end

function OccurrencesInterface.Occurrences(
    L₊::SDMLayer{Bool},
    L₋::SDMLayer{Bool};
    entity::String = "",
)
    # Check layer compatibility
    @assert SimpleSDMLayers._layers_are_compatible([L₊, L₋])
    
    A₊ = nodata(L₊, false)

    if length(unique(L₋)) == 2
        A₋ = nodata(L₋, false)
    else
        # Correct nodata for the second layer?
        _nd = only(unique(L₋)) == false ? true : false
        A₋ = nodata(L₋, _nd)
    end

    A₊.grid[findall(A₋.indices)] .= false
    A₊.indices[findall(A₋.indices)] .= true

    return Occurrences(A₊; entity=entity)
end