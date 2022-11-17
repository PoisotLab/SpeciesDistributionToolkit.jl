module TestSSDCHELSA2

using SimpleSDMDatasets
using Test
using Dates

@test CHELSA2 <: RasterProvider

# Test the interface
for T in Base.uniontypes(SimpleSDMDatasets.CHELSA2Dataset)
    @test SimpleSDMDatasets.provides(CHELSA2, T)
    data = RasterData(CHELSA2, T)
    @test SimpleSDMDatasets.resolutions(data) |> isnothing
end

@test layerdescriptions(RasterData(CHELSA2, BioClim))["BIO1"] == "Annual Mean Temperature"

@test SimpleSDMDatasets.months(RasterData(CHELSA2, BioClim)) |> isnothing
@test SimpleSDMDatasets.extrakeys(RasterData(CHELSA2, BioClim)) |> isnothing
@test SimpleSDMDatasets.layers(RasterData(CHELSA2, BioClim)) |> !isnothing

@test SimpleSDMDatasets.months(RasterData(CHELSA2, Precipitation)) |> !isnothing
@test SimpleSDMDatasets.extrakeys(RasterData(CHELSA2, AverageTemperature)) |> isnothing
@test SimpleSDMDatasets.layers(RasterData(CHELSA2, MinimumTemperature)) |> isnothing

begin
    out = downloader(RasterData(CHELSA2, BioClim); layer="BIO12")
    @test isfile(first(out))
    @test out[2] == SimpleSDMDatasets.filetype(RasterData(CHELSA2, BioClim))
end

begin
    out = downloader(RasterData(CHELSA2, AverageTemperature); month=Month(6))
    @test isfile(first(out))
    @test out[2] == SimpleSDMDatasets.filetype(RasterData(CHELSA2, AverageTemperature))
end

begin
    out = downloader(RasterData(CHELSA2, MinimumTemperature); month=Month(12))
    @test isfile(first(out))
    @test out[2] == SimpleSDMDatasets.filetype(RasterData(CHELSA2, MinimumTemperature))
end

begin
    out = downloader(RasterData(CHELSA2, MaximumTemperature); month=Month(1))
    @test isfile(first(out))
    @test out[2] == SimpleSDMDatasets.filetype(RasterData(CHELSA2, MaximumTemperature))
end

begin
    out = downloader(RasterData(CHELSA2, Precipitation); month=Month(10))
    @test isfile(first(out))
    @test out[2] == SimpleSDMDatasets.filetype(RasterData(CHELSA2, Precipitation))
end

end
