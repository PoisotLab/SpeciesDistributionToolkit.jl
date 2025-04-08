using TestItemRunner

@run_package_tests filter=ti->!(:skipci in ti.tags)

@testitem "We can plot a series of occurrences" begin
    using CairoMakie
    r = OccurrencesInterface.__demodata()
    scatter(r)
    scatter(Occurrences(r))
end

@testitem "We can hexbin of occurrences" begin
    using CairoMakie
    r = OccurrencesInterface.__demodata()
    hexbin(r)
    hexbin(Occurrences(r))
end

@testitem "We can plot a series of occurrences and color by attribute" begin
    using CairoMakie
    r = OccurrencesInterface.__demodata()
    scatter(r, color=presence(r))
    scatter(Occurrences(r), color=presence(r))
end