module TestSSDCHELSA1

using SimpleSDMDatasets
using Test
using Dates

@test CHELSA1 <: RasterProvider

# Test the interface
for T in Base.uniontypes(SimpleSDMDatasets.CHELSA1Dataset)
    @test SimpleSDMDatasets.provides(CHELSA1, T)
    data = RasterData(CHELSA1, T)
    @test SimpleSDMDatasets.resolutions(data) |> isnothing
end

@test SimpleSDMDatasets.months(RasterData(CHELSA1, BioClim)) |> isnothing
@test SimpleSDMDatasets.extrakeys(RasterData(CHELSA1, BioClim)) |> isnothing
@test SimpleSDMDatasets.layers(RasterData(CHELSA1, BioClim)) |> !isnothing

begin
    out = downloader(RasterData(CHELSA1, BioClim); layer = "BIO12")
    @test isfile(first(out))
    @test out[2] == SimpleSDMDatasets.filetype(RasterData(CHELSA1, BioClim))
end

begin
    out = downloader(RasterData(CHELSA1, AverageTemperature); month = Month(6))
    @test isfile(first(out))
    @test out[2] == SimpleSDMDatasets.filetype(RasterData(CHELSA1, AverageTemperature))
end

begin
    out = downloader(RasterData(CHELSA1, MinimumTemperature); month = Month(12))
    @test isfile(first(out))
    @test out[2] == SimpleSDMDatasets.filetype(RasterData(CHELSA1, MinimumTemperature))
end

begin
    out = downloader(RasterData(CHELSA1, MaximumTemperature); month = Month(1))
    @test isfile(first(out))
    @test out[2] == SimpleSDMDatasets.filetype(RasterData(CHELSA1, MaximumTemperature))
end

begin
    out = downloader(RasterData(CHELSA1, Precipitation); month = Month(10))
    @test isfile(first(out))
    @test out[2] == SimpleSDMDatasets.filetype(RasterData(CHELSA1, Precipitation))
end

end