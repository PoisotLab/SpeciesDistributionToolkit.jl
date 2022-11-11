module TestSSDCHELSA1Projection

using SimpleSDMDatasets
using Test
using Dates

@test CHELSA1 <: RasterProvider

# Test the interface
for D in Base.uniontypes(SimpleSDMDatasets.CHELSA1ProjectedDataset)
    data = RasterData(CHELSA1, D)
    for M in Base.uniontypes(SimpleSDMDatasets.CHELSA1Model)
        for S in Base.uniontypes(SimpleSDMDatasets.CHELSA1Scenario)
            future = Projection(S, M)
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
    data, future = RasterData(CHELSA1, BioClim), Projection(RCP26, CESM1_CAM5)
    out = downloader(data, future; layer="BIO12")
    @test isfile(first(out))
    @test out[2] == SimpleSDMDatasets.filetype(data, future)
end

begin
    data, future = RasterData(CHELSA1, AverageTemperature), Projection(RCP45, CESM1_CAM5)
    out = downloader(
        data,
        future;
        month=Month(4),
        timespan=first(SimpleSDMDatasets.timespans(data, future))
    )
    @test isfile(first(out))
    @test out[2] == SimpleSDMDatasets.filetype(data, future)
end

end
