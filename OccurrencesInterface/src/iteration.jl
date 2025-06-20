Base.length(o::Occurrences) = length(elements(o))

@testitem "We can get the length of Occurrences" begin
    o = OccurrencesInterface.__demodata()
    @test length(o) == length(elements(o))
end