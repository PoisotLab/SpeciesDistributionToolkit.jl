using TestItemRunner

# We do NOT run the tests from the component packages, this is already done with CI
@run_package_tests filter=ti->!(:skipci in ti.tags)&(contains(ti.filename, "SpeciesDistributionToolkit.jl/src")|contains(ti.filename, "SpeciesDistributionToolkit.jl/test")) verbose=true

@testitem "We can get the gradient right" begin
    using SpatialBoundaries
    X = zeros(Float64, 200, 200)
    for i in axes(X, 1)
        X[i, :] .= i
    end
    grad = SDMLayer(X)
    Z = wombling(grad)
    @test all(unique(values(Z.rate)) .== 1.0)
    @test all(unique(values(Z.direction)) .== 180.0)
end

@testitem "We can womble with a layer" begin
    using SpatialBoundaries
    precipitation = SDMLayer(
        RasterData(CHELSA1, BioClim);
        layer = 12,
        left = -66.0,
        right = -62.0,
        bottom = 45.0,
        top = 46.5,
    )
    W = wombling(precipitation)
    @test isa(W.rate, SDMLayer)
    @test isa(W.direction, SDMLayer)
end

@testitem "We can womble with a vector of layers" begin
    using SpatialBoundaries
    L = [SDMLayer(
        RasterData(CHELSA1, BioClim);
        layer = i,
        left = -66.0,
        right = -62.0,
        bottom = 45.0,
        top = 46.5,
    ) for i in [1, 12]]
    W = wombling(L)
    @test isa(W.rate, SDMLayer)
    @test isa(W.direction, SDMLayer)
end

@testitem "We can get data from a STAC catalogue" begin
    using STAC
    biab = STAC.Catalog("https://stac.geobon.org/")
    ghmts = biab["ghmts"].items["GHMTS"].assets["GHMTS"]
    L = SDMLayer(ghmts; left=12.5, right=23.75, bottom=45.5, top=51.0)
    @test L isa SDMLayer
end

@testitem "We can get data from a STAC catalogue (no local storage)" begin
    using STAC
    biab = STAC.Catalog("https://stac.geobon.org/")
    ghmts = biab["ghmts"].items["GHMTS"].assets["GHMTS"]
    L = SDMLayer(ghmts; store=false, left=12.5, right=23.75, bottom=45.5, top=51.0)
    @test L isa SDMLayer
end