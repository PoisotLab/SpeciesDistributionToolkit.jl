module TestThatWeCanReadStuff

    using SpeciesDistributionToolkit

    # Get some EarthEnv data
    layer = SimpleSDMPredictor(RasterData(EarthEnv, LandCover); layer=1)

    # Write the data
    f = tempname()
    SpeciesDistributionToolkit._write_geotiff(f, [layer], driver="GTiff", nodata=0x0)
    @test isfile(f)

    # Read the data
    layer2 = SpeciesDistributionToolkit._read_geotiff(f, SimpleSDMPredictor)

end