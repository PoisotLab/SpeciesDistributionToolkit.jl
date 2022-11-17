module TestSSDWorldClim2

using SimpleSDMDatasets
using Test
using Dates

@test WorldClim2 <: RasterProvider

# Test the interface
for T in Base.uniontypes(SimpleSDMDatasets.WorldClim2Dataset)
    @test SimpleSDMDatasets.provides(WorldClim2, T)
    data = RasterData(WorldClim2, T)
    @test typeof(data) == RasterData{WorldClim2,T}
    @test SimpleSDMDatasets.resolutions(data) |> !isnothing
end

@test SimpleSDMDatasets.months(RasterData(WorldClim2, BioClim)) |> isnothing
@test SimpleSDMDatasets.months(RasterData(WorldClim2, AverageTemperature)) |> !isnothing
@test SimpleSDMDatasets.months(RasterData(WorldClim2, AverageTemperature)) |> !isempty
@test SimpleSDMDatasets.layers(RasterData(WorldClim2, AverageTemperature)) |> isnothing
@test SimpleSDMDatasets.layers(RasterData(WorldClim2, BioClim)) |> !isnothing

@test layerdescriptions(RasterData(WorldClim2, BioClim))["BIO1"] == "Annual Mean Temperature"

begin
    out = downloader(RasterData(WorldClim2, BioClim); resolution=10.0, layer="BIO8")
    @test isfile(first(out))
    @test out[2] == SimpleSDMDatasets.filetype(RasterData(WorldClim2, BioClim))
end

begin
    out = downloader(RasterData(WorldClim2, BioClim); resolution=5.0, layer="BIO4")
    @test isfile(first(out))
    @test out[2] == SimpleSDMDatasets.filetype(RasterData(WorldClim2, BioClim))
end

begin
    out = downloader(RasterData(WorldClim2, Elevation); resolution=5.0)
    @test isfile(first(out))
    @test out[2] == SimpleSDMDatasets.filetype(RasterData(WorldClim2, Elevation))
end

begin
    out = downloader(
        RasterData(WorldClim2, MaximumTemperature);
        resolution=10.0,
        month=Month(4)
    )
    @test isfile(first(out))
    @test out[2] == SimpleSDMDatasets.filetype(RasterData(WorldClim2, MaximumTemperature))
end

begin
    out = downloader(
        RasterData(WorldClim2, MinimumTemperature);
        resolution=2.5,
        month=Month(12)
    )
    @test isfile(first(out))
    @test out[2] == SimpleSDMDatasets.filetype(RasterData(WorldClim2, MinimumTemperature))
end

begin
    out = downloader(
        RasterData(WorldClim2, AverageTemperature);
        resolution=10.0,
        month=Month(4)
    )
    @test isfile(first(out))
    @test out[2] == SimpleSDMDatasets.filetype(RasterData(WorldClim2, AverageTemperature))
end

begin
    out = downloader(
        RasterData(WorldClim2, SolarRadiation);
        resolution=10.0,
        month=Month(4)
    )
    @test isfile(first(out))
    @test out[2] == SimpleSDMDatasets.filetype(RasterData(WorldClim2, SolarRadiation))
end

begin
    out = downloader(
        RasterData(WorldClim2, WindSpeed);
        resolution=10.0,
        month=Month(4)
    )
    @test isfile(first(out))
    @test out[2] == SimpleSDMDatasets.filetype(RasterData(WorldClim2, WindSpeed))
end

begin
    out = downloader(
        RasterData(WorldClim2, WaterVaporPressure);
        resolution=10.0,
        month=Month(4)
    )
    @test isfile(first(out))
    @test out[2] == SimpleSDMDatasets.filetype(RasterData(WorldClim2, WaterVaporPressure))
end

end
