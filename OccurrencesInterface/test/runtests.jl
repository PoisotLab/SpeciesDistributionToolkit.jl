using TestItemRunner

@run_package_tests filter=ti->!(:skipci in ti.tags)

@testitem "We can plot a series of occurrences" begin
    using CairoMakie
    r = [Occurrence(where=(rand(), rand()), presence=rand(Bool)) for _ in 1:10]
    scatter(r)
    scatter(Occurrences(r))
end

@testitem "We can hexbin of occurrences" begin
    using CairoMakie
    r = [Occurrence(where=(rand(), rand())) for _ in 1:10]
    hexbin(r)
    hexbin(Occurrences(r))
end

@testitem "We can plot a series of occurrences and color by attribute" begin
    using CairoMakie
    r = [Occurrence(where=(rand(), rand()), presence=rand(Bool)) for _ in 1:10]
    scatter(r, color=presence(r))
    scatter(Occurrences(r), color=presence(r))
end