using SimpleSDMDatasets

using TestItemRunner

@run_package_tests filter=ti->!(:skipci in ti.tags)

@tesitem "We have implemented the types correctly" begin
    @test_throws "does not allow for month" downloader(
        RasterData(EarthEnv, LandCover);
        month = true,
    )

    @test_throws "no thank you is not supported for the keyword argument full" downloader(
        RasterData(EarthEnv, LandCover);
        full = "no thank you",
    )

    @test_throws "does not support multiple resolutions" downloader(
        RasterData(EarthEnv, LandCover);
        resolution = π,
    )

    @test_throws ["The resolution", "is not supported by the"] downloader(
        RasterData(WorldClim2, BioClim);
        resolution = π,
    )

    @test_throws ["The layer", "not supported by the"] downloader(
        RasterData(EarthEnv, LandCover);
        layer = "LMFAO",
    )

    @test_throws ["The month", "not supported by the"] downloader(
        RasterData(WorldClim2, AverageTemperature);
        month = "Marchtober",
    )

    @test_throws ["dataset only has"] downloader(
        RasterData(WorldClim2, BioClim);
        layer = 420,
    )

    @test_throws "does not allow for layer" downloader(
        RasterData(WorldClim2, AverageTemperature);
        layer = "Some stuff I guess",
    )

    @test_throws "dataset is not provided by" RasterData(WorldClim2, HabitatHeterogeneity)
end