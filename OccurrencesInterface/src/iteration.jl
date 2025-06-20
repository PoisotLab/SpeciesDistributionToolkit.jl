Base.length(o::Occurrences) = length(elements(o))

@testitem "We can get the length of Occurrences" begin
    o = OccurrencesInterface.__demodata()
    @test length(o) == length(elements(o))
end

Base.eltype(::Type{Occurrences}) = Occurrence

@testitem "The type of Occurrences is correctly identified" begin
    o = OccurrencesInterface.__demodata()
    @test eltype(o) == typeof(o[1])
end

function Base.iterate(occ::Occurrences)
    if length(occ) == 0
        return nothing
    end
    return (occ[1], 2)
end

function Base.iterate(occ::Occurrences, state)
    if state > length(occ)
        return nothing
    end
    return (occ[state], state+1)
end

@testitem "We can iterate over Occurrences" begin
    occ = OccurrencesInterface.__demodata()
    @test [o for o in occ] isa Vector{Occurrence}
end