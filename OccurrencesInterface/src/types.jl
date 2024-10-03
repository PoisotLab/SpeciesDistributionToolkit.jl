abstract type AbstractOccurrence end

abstract type AbstractOccurrenceCollection end

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

