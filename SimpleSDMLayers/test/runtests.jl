using TestItemRunner

@run_package_tests filter=ti->!(:skipci in ti.tags)

# write tests here


@testitem "We can cluster a series of layers" begin
    using Clustering
    L = [SimpleSDMLayers.__demodata(reduced=true) for _ in 1:3]
    for l in L
        l.grid .+= randn(size(l.grid))
    end
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
