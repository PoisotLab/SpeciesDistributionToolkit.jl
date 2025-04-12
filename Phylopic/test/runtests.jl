using TestItemRunner

@run_package_tests filter=ti->!(:skipci in ti.tags) verbose=true

@testitem "We can plot a single silhouette" begin
    using CairoMakie
    @test silhouetteplot(0, 0, PhylopicSilhouette("Ebolavirus"))
end

@testitem "We can plot a single silhouette with a custom size" begin
    using CairoMakie
    @test silhouetteplot(0, 0, PhylopicSilhouette("Ebolavirus"), markersize=200)
end

@testitem "We can plot multiple silhouettes" begin
    # using CairoMakie
    # sp = PhylopicSilhouette("Procyon lotor")
    # sps = [sp for _ in 1:10]
    # @test silhouetteplot(randn(10), randn(10), sps, markersize=rand(100:150, 10))
end