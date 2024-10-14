"""
    AbstractOccurrence

Other types describing a single observation should be sub-types of this. Occurrences are always defined as a single observation of a single species.
"""
abstract type AbstractOccurrence end

"""
    AbstractOccurrenceCollection

Other types describing multiple observations can be sub-types of this. Occurrences collections are a way to collect multiple observations of arbitrarily many species.
"""
abstract type AbstractOccurrenceCollection end

"""
    Occurrence

This is a sub-type of `AbstractOccurrence`, with the following types:

- `what` - species name, defaults to `""`
- `presence` - a boolean to mark the presence of the species, defaults to `true`
- `where` - a tuple giving the location as longitude,latitude in WGS84, or `missing`, defaults to `missing`
- `when` - a `DateTime` giving the date of observation, or `missing`, defaults to `missing`

When the interface is properly implemented for any type that is a sub-type of `AbstractOccurrence`, there is an `Occurrence` object can be created directly with *e.g.* `Occurrence(observation)`. There is, similarly, an automatically implemented `convert` method.
"""
Base.@kwdef mutable struct Occurrence <: AbstractOccurrence
    what::String = ""
    presence::Bool = true
    where::Union{Missing,Tuple{<:AbstractFloat,<:AbstractFloat}} = missing
    when::Union{Missing,DateTime} = missing
end

@testitem "We can construct an occurrence" begin
    using Dates
    occ = Occurrence("species_sp", true, (rand(), rand()), Dates.now())
    @test occ.what == "species_sp"
end

"""
    Occurrences

This is a sub-type of `AbstractOccurrenceCollection`. No default value.
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
