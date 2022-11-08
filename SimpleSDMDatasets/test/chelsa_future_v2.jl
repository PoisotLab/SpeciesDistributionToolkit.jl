module TestSSDCHELSA2Future

using SimpleSDMDatasets
using Test
using Dates

@test CHELSA2 <: RasterProvider

# Test the interface
for D in Base.uniontypes(SimpleSDMDatasets.CHELSA2FutureDataset)
    data = RasterData(CHELSA2, D)
    for M in Base.uniontypes(SimpleSDMDatasets.CHELSA2Model)
        for S in Base.uniontypes(SimpleSDMDatasets.CHELSA2Scenario)
            future = Future(S, M)
            @test SimpleSDMDatasets.provides(data, future)
            @test SimpleSDMDatasets.resolutions(data, future) |> isnothing
            @test SimpleSDMDatasets.extrakeys(data, future) |> isnothing
            @test SimpleSDMDatasets.timespans(data, future) |> !isnothing
            if D <: BioClim
                @test SimpleSDMDatasets.months(data, future) |> isnothing
                @test SimpleSDMDatasets.layers(data, future) |> !isnothing
            else
                @test SimpleSDMDatasets.months(data, future) |> !isnothing
                @test SimpleSDMDatasets.layers(data, future) |> isnothing
            end
        end
    end
end

begin
    data, future = RasterData(CHELSA2, BioClim), Future(SSP585, GFDL_ESM4)
    out = downloader(data, future; layer = "BIO12")
    @test isfile(first(out))
    @test out[2] == SimpleSDMDatasets.filetype(data, future)
end

begin
    data, future = RasterData(CHELSA2, AverageTemperature), Future(SSP126, IPSL_CM6A_LR)
    out = downloader(
        data,
        future;
        month = Month(4),
        timespan = first(SimpleSDMDatasets.timespans(data, future)),
    )
    @test isfile(first(out))
    @test out[2] == SimpleSDMDatasets.filetype(data, future)
end

end