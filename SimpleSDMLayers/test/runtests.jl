using TestItemRunner

@run_package_tests filter=ti->!(:skipci in ti.tags)

# write tests here

@testitem "We can generate neutral landscapes" begin
    using NeutralLandscapes
    ds = DiamondSquare()
    @info ds
    @info typeof(ds)
    @info typeof(ds) <: NeutralLandscapes.NeutralLandscapeMaker
    @test SDMLayer(DiamondSquare(), (10, 20)) isa SDMLayer
end

@testitem "We can generate neutral landscapes with a template" begin
    using NeutralLandscapes
    X = SimpleSDMLayers.__demodata(reduced=true)
    Y = SDMLayer(RectangularCluster(), X)
    @info X
    @info Y
end

@testitem "We can cluster a series of layers" begin
    using Clustering
    using NeutralLandscapes
    L = [SDMLayer(DiamondSquare(), (30, 50)) for _ in 1:8]
    K = kmeans(L, 3)
    C = SDMLayer(K, L)
    q = clustering_quality(L, K; quality_index = :davies_bouldin)
    @test typeof(C) <: SDMLayer
    @test maximum(C) == 3
    @test K isa ClusteringResult
end
