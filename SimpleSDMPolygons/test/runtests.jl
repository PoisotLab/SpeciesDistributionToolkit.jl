using TestItemRunner

@run_package_tests filter=ti->!(:skipci in ti.tags)

@testitem "We can do a plot" begin
    using CairoMakie
    pd = PolygonData(NaturalEarth, Countries)
    d = getpolygon(pd)
    poly(d)
    lines!(d, color=:red)

    # test obviously true statement to count it completing in test summary
    @test 1 == 1 
end