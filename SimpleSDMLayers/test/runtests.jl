using TestItemRunner

@run_package_tests filter=ti->!(:skipci in ti.tags)

# write tests here


@testitem "We can cluster a series of layers" begin
    using Clustering
    L = [SDMLayer(
        RasterData(CHELSA1, BioClim);
        layer = i,
        left = -66.0,
        right = -62.0,
        bottom = 45.0,
        top = 46.5,
    ) for i in [1, 12]]
    K = kmeans(L, 3)
    C = SDMLayer(K, L)
    q = clustering_quality(L, K; quality_index = :davies_bouldin)
    @test typeof(C) <: SDMLayer
    @test maximum(C) == 3
    @test K isa ClusteringResult
end


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
