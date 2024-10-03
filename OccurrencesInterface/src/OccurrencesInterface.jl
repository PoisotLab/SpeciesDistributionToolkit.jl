module OccurrencesInterface

using Dates
using TestItems

abstract type AbstractOccurrence end
export AbstractOccurrence

abstract type AbstractOccurrenceCollection end
export AbstractOccurrenceCollection

mutable struct Occurrence{T<:AbstractFloat} <: AbstractOccurrence
    what::String
    presence::Bool
    where::Union{Missing,Tuple{T,T}}
    when::Union{Missing,DateTime}
end
export Occurrence

@testitem "We can construct an occurrence" begin
    using Dates
    occ = Occurrence("speciessp", true, (rand(), rand()), Dates.now())
    @test Occurrence.what == "speciesp"
end

mutable struct Occurrences <: AbstractOccurrenceCollection
    records::Vector{Occurrences}
end
Occurrences(occ::Occurrences...) = Occurrences([occ...])
export Occurrences

@testitem "We can construct a series of occurrences" begin
    using Dates
    occ = Occurrence("speciessp", true, (rand(), rand()), Dates.now())
    occs = [copy(occ) for _ in 1:10]
    @test occs isa Occurrences
end

end # module OccurrencesInterface
