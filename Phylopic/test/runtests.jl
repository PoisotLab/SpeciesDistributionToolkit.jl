using TestItemRunner

@run_package_tests filter = ti -> !(:skipci in ti.tags) verbose = true

@testitem "We can plot a single silhouette" begin
    using CairoMakie
    @test silhouetteplot(0, 0, PhylopicSilhouette("Ebolavirus"))
end

@testitem "We can plot a single silhouette with a custom size" begin
    using CairoMakie
    @test silhouetteplot(0, 0, PhylopicSilhouette("Ebolavirus"), markersize=200)
end

@testitem "We can plot multiple silhouettes" begin
    using CairoMakie
    x = sort(rand(1:250, 50))
    y = sin.(x) .+ randn(length(x)) .* 0.1
    s = [PhylopicSilhouette("Ebolavirus") for i in 1:length(x)]
    z = collect(LinRange(-1, 1, length(x)))
    @test silhouetteplot(x, y, s, color=z, colorrange=(-1, 1), colormap=:curl, markersize=20)
end