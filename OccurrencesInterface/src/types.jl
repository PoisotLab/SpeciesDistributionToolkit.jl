"""
    AbstractOccurrence

Other types describing a single observation can be sub-types.
"""
abstract type AbstractOccurrence end

"""
    AbstractOccurrenceCollection

Other types describing multiple observations can be sub-types.
"""
abstract type AbstractOccurrenceCollection end

"""
    Occurence
"""
mutable struct Occurrence <: AbstractOccurrence
    what::String
    presence::Bool
    where::Union{Missing,Tuple{<:AbstractFloat,<:AbstractFloat}}
    when::Union{Missing,DateTime}
end

@testitem "We can construct an occurrence" begin
    using Dates
    occ = Occurrence("species_sp", true, (rand(), rand()), Dates.now())
    @test occ.what == "species_sp"
end

"""
    Occurrences
"""
mutable struct Occurrences <: AbstractOccurrenceCollection
    records::Vector{Occurrence}
end
Occurrences(occ::Occurrence...) = Occurrences([occ...])

@testitem "We can construct a series of occurrences" begin
    using Dates
    occ = Occurrence("speciessp", true, (rand(), rand()), Dates.now())
    occs = Occurrences([deepcopy(occ) for _ in 1:10])
    @test occs isa Occurrences
end

"""
    Occurrence(t::T) where {T<:AbstractOccurrence}

Given a type that is a subtype of `AbstractOccurrence`, constructs an `Occurrence` object *using the methods in the interface*. This should not be overloaded in other packages.
"""
function Occurrence(t::T) where {T<:AbstractOccurrence}
    return Occurrence(
        entity(t),
        presence(t),
        place(t),
        date(t)
    )
end

Base.convert(::Type{Occurrence}, o::T) where {T<:AbstractOccurrence} = Occurrence(o)
