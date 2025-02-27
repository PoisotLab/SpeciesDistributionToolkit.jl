using TestItemRunner

@run_package_tests filter=ti->!(:skipci in ti.tags)

# write tests here


@testitem "We can cluster a series of layers" begin
    using Clustering
    L = SDMLayer{Float32}[SimpleSDMLayers.__demodata(reduced=true) for _ in 1:3]
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

@testitem "We can generate neutral landscapes" begin
    using NeutralLandscapes
    
end