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
    layer=12,
    left=-66.0,
    right=-62.0,
    bottom=45.0,
    top=46.5,
  )
  W = wombling(precipitation)
  @test isa(W.rate, SDMLayer)
  @test isa(W.direction, SDMLayer)
end

@testitem "We can womble with a vector of layers" begin
  using SpatialBoundaries
  L = [SDMLayer(
    RasterData(CHELSA1, BioClim);
    layer=i,
    left=-66.0,
    right=-62.0,
    bottom=45.0,
    top=46.5,
  ) for i in [1, 12]]
  W = wombling(L)
  @test isa(W.rate, SDMLayer)
  @test isa(W.direction, SDMLayer)
end

@testitem "We can get data from a STAC catalogue" begin
  using STAC
  olm = STAC.Catalog("https://s3.eu-central-1.wasabisys.com/stac/openlandmap/catalog.json")
  wild_collection = olm["wilderness_li2022.human.footprint"]
  wild_item = wild_collection.items["wilderness_li2022.human.footprint_20180101_20181231"]
  wild_assets = wild_item.assets["wilderness_li2022.human.footprint_p_1km_s"]
  L = SDMLayer(wild_assets; SpeciesDistributionToolkit.boundingbox(aoi, padding=1.0)...)
  @test L isa SDMLayer
end

@testitem "We can get data from a STAC catalogue (no local storage)" begin
  using STAC
  olm = STAC.Catalog("https://s3.eu-central-1.wasabisys.com/stac/openlandmap/catalog.json")
  wild_collection = olm["wilderness_li2022.human.footprint"]
  wild_item = wild_collection.items["wilderness_li2022.human.footprint_20180101_20181231"]
  wild_assets = wild_item.assets["wilderness_li2022.human.footprint_p_1km_s"]
  L = SDMLayer(wild_assets; store=false, SpeciesDistributionToolkit.boundingbox(aoi, padding=1.0)...)
  @test L isa SDMLayer
end
