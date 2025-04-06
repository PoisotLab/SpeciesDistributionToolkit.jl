function Base.getindex(s::AbstractOccurrenceCollection, i...)
    return getindex(elements(s), i...)
end

@testitem "We can get a slice of occurrences" begin
    using Dates
    occ = [Occurrence("speciessp",rand(Bool), (rand(), rand()), Dates.now()) for i in 1:100]
    occs = Occurrences(occ)
    @test occs[2] == occ[2]
end