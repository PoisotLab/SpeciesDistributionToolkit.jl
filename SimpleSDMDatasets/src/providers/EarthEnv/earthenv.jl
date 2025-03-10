EarthEnvDataset = Union{LandCover, HabitatHeterogeneity}
provides(::Type{EarthEnv}, ::Type{T}) where {T <: EarthEnvDataset} = true

url(::Type{EarthEnv}) = "https://www.earthenv.org/"
blurb(::Type{EarthEnv}) = md"""
The EarthEnv project is a collaborative project of biodiversity scientists and
remote sensing experts to develop near-global standardized, 1km resolution
layers for monitoring and modeling biodiversity, ecosystems, and climate. The
work is supported by NCEAS, NASA, NSF, and Yale University.
"""

@testitem "We have implemented EarthEnv properly" begin
    @test EarthEnv <: RasterProvider

    # Test the interface
    for T in Base.uniontypes(SimpleSDMDatasets.EarthEnvDataset)
        @test SimpleSDMDatasets.provides(EarthEnv, T)
        data = RasterData(EarthEnv, T)
        @test typeof(data) == RasterData{EarthEnv, T}
    end

    @test SimpleSDMDatasets.months(RasterData(EarthEnv, LandCover)) |> isnothing
    @test SimpleSDMDatasets.layers(RasterData(EarthEnv, LandCover)) |> !isnothing
    @test SimpleSDMDatasets.resolutions(RasterData(EarthEnv, LandCover)) |> isnothing
    @test SimpleSDMDatasets.resolutions(RasterData(EarthEnv, HabitatHeterogeneity)) |>
          !isnothing

    begin
        out = downloader(RasterData(EarthEnv, LandCover); layer = "Shrubs", full = true)
        @test isfile(first(out))
        @test out[2] == SimpleSDMDatasets.filetype(RasterData(EarthEnv, LandCover))
    end

    begin
        out = downloader(RasterData(EarthEnv, LandCover); layer = "Shrubs", full = false)
        @test isfile(first(out))
        @test out[2] == SimpleSDMDatasets.filetype(RasterData(EarthEnv, LandCover))
    end

    begin
        out = downloader(
            RasterData(EarthEnv, HabitatHeterogeneity);
            layer = "Standard deviation",
            resolution = 2.5,
        )
        @test isfile(first(out))
        @test out[2] ==
              SimpleSDMDatasets.filetype(RasterData(EarthEnv, HabitatHeterogeneity))
    end

    begin
        out = downloader(
            RasterData(EarthEnv, HabitatHeterogeneity);
            layer = "Range",
            resolution = 12.5,
        )
        @test isfile(first(out))
        @test out[2] ==
              SimpleSDMDatasets.filetype(RasterData(EarthEnv, HabitatHeterogeneity))
    end

    begin
        out = downloader(RasterData(EarthEnv, HabitatHeterogeneity); layer = 7)
        @test isfile(first(out))
        @test out[2] ==
              SimpleSDMDatasets.filetype(RasterData(EarthEnv, HabitatHeterogeneity))
    end

    begin
        out = downloader(RasterData(EarthEnv, HabitatHeterogeneity); layer = 9)
        @test isfile(first(out))
        @test out[2] ==
              SimpleSDMDatasets.filetype(RasterData(EarthEnv, HabitatHeterogeneity))
    end

    begin
        out = downloader(RasterData(EarthEnv, HabitatHeterogeneity); layer = 14)
        @test isfile(first(out))
        @test out[2] ==
              SimpleSDMDatasets.filetype(RasterData(EarthEnv, HabitatHeterogeneity))
    end
end