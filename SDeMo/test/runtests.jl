using TestItemRunner

@run_package_tests filter=ti->!(:skipci in ti.tags)

@testitem "We can get data from a STAC catalogue" begin
    using STAC
    biab = STAC.Catalog("https://stac.geobon.org/")
    ghmts = biab["ghmts"].items["GHMTS"].assets["GHMTS"]
    L = SDMLayer(ghmts; left=12.5, right=23.75, bottom=45.5, top=51.0)
#SDMLayer(f)

end

# write tests here

## NOTE add JET to the test environment, then uncomment
# using JET
# @testset "static analysis with JET.jl" begin
#     @test isempty(JET.get_reports(report_package(SDMLayers, target_modules=(SDMLayers,))))
# end

## NOTE add Aqua to the test environment, then uncomment
# @testset "QA with Aqua" begin
#     import Aqua
#     Aqua.test_all(SDMLayers; ambiguities = false)
#     # testing separately, cf https://github.com/JuliaTesting/Aqua.jl/issues/77
#     Aqua.test_ambiguities(SDMLayers)
# end
