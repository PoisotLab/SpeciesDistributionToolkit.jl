using TestItemRunner

@run_package_tests filter=ti->!(:skipci in ti.tags)

# THESE TESTS ARE MEANT TO BE RUN MANUALLY - LOOK AT THE OUTPUT

@testitem "We can do a plot and the arguments are respected" begin
    using CairoMakie
    pd = PolygonData(NaturalEarth, Countries)
    d = getpolygon(pd)["Subregion" => "Northern America"]
    poly(d, color=:teal)
    lines!(d, color=:pink, linewidth=1)
    current_figure()

    # test obviously true statement to count it towards completing in test summary
    @test 1 == 1 
end

@testitem "The EPA polygons are the right side up" begin
    using CairoMakie
    pd = PolygonData(EPA, Ecoregions)
    d = getpolygon(pd)
    poly(d, color=:grey80, strokecolor=:black, strokewidth=1)

    # test obviously true statement to count it towards completing in test summary
    @test 1 == 1 
end