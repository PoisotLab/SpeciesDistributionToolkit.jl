using TestItemRunner

@run_package_tests filter=ti->!(:skipci in ti.tags)

# write tests here

@testitem "We can generate neutral landscapes" begin
    using NeutralLandscapes
    @test SDMLayer(DiamondSquare(), (10, 20)) isa SDMLayer
end

@testitem "We can generate neutral landscapes with a template" begin
    using NeutralLandscapes
    X = SimpleSDMLayers.__demodata(reduced=true)
    Y = SDMLayer(RectangularCluster(), X)
    @test X.x == Y.x
    @test X.y == Y.y
    @test X.crs == Y.crs
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

@testitem "We can fit a PCA on a vector of layers" begin
    using MultivariateStats
    using NeutralLandscapes
    L = [SDMLayer(DiamondSquare(), (30, 50)) for _ in 1:8]
    P = fit(PCA, L; maxoutdim=2)
    @test typeof(P) <: MultivariateStats.PCA
    @test size(P, 1) == length(L)
    @test size(P, 2) <= 2
end

@testitem "We can transform a vector of layers with a PCA" begin
    using MultivariateStats
    using NeutralLandscapes
    L = [SDMLayer(DiamondSquare(), (30, 50)) for _ in 1:8]
    P = fit(PCA, L; maxoutdim=3)
    M = predict(P, L)
    @test M isa Vector{<:SDMLayer}
    @test length(M) <= 3
end

@testitem "We can heatmap" begin
    using CairoMakie
    L = SDMLayer(DiamondSquare(), (10, 20))
    heatmap(L)
    @test true
end

@testitem "We can heatmap with a different color scale" begin
    using CairoMakie
    L = SDMLayer(DiamondSquare(), (10, 20))
    heatmap(L; colormap=:Spectral)
    @test true
end