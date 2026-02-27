CHELSA2Scenario = Union{SSP126, SSP370, SSP585}
CHELSA2Model = Union{GFDL_ESM4, IPSL_CM6A_LR, MPI_ESM1_2_HR, MRI_ESM2_0, UKESM1_0_LL}
CHELSA2ProjectedDataset = Union{
    BioClim,
    Precipitation,
    AverageTemperature,
    MinimumTemperature,
    MaximumTemperature,
}

provides(
    ::RasterData{CHELSA2, T},
    ::Projection{S, M},
) where {T <: CHELSA2ProjectedDataset, S <: CHELSA2Scenario, M <: CHELSA2Model} = true

timespans(
    ::RasterData{CHELSA2, T},
    ::Projection{S, M},
) where {T <: CHELSA2ProjectedDataset, S <: CHELSA2Scenario, M <: CHELSA2Model} = [
    Year(2011) => Year(2040),
    Year(2041) => Year(2070),
    Year(2071) => Year(2100),
]

function source(
    data::RasterData{CHELSA2, T},
    future::Projection{S, M};
    layer = first(SimpleSDMDatasets.layers(data, future)),
    timespan = first(SimpleSDMDatasets.timespans(data, future)),
) where {T <: BioClim, S <: CHELSA2Scenario, M <: CHELSA2Model}
    var_code = (layer isa Integer) ? layer : findfirst(isequal(layer), layers(data))
    var_code = lpad(var_code, 2, '0')
    year_sep = string(timespan.first.value) * "-" * string(timespan.second.value)
    model_sep = replace(uppercase(string(M)) * "/" * lowercase(string(S)), "_" => "-")
    root = "https://os.unil.cloud.switch.ch/chelsa02/chelsa/global/bioclim/bio$(var_code)/$(year_sep)/$(model_sep)/"
    stem = "CHELSA_$(lowercase(replace(string(M), "_" => "-")))_$(lowercase(string(S)))_bio$(var_code)_$(year_sep)_V.2.1.tif"
    return (
        url = root * stem,
        filename = lowercase(stem),
        outdir = destination(data, future),
    )
end

function source(
    data::RasterData{CHELSA2, T},
    future::Projection{S, M};
    month = first(SimpleSDMDatasets.months(data, future)),
    timespan = first(SimpleSDMDatasets.timespans(data, future)),
) where {T <: CHELSA2ProjectedDataset, S <: CHELSA2Scenario, M <: CHELSA2Model}
    var_code = _var_slug(data)
    month_code = lpad(string(month.value), 2, '0')
    year_sep = string(timespan.first.value) * "-" * string(timespan.second.value)
    model_code = replace(uppercase(string(M)), "_" => "-")
    model_sep = replace(uppercase(string(M)) * "/" * lowercase(string(S)), "_" => "-")
    scenario_code = replace(lowercase(string(S)), "_" => "-")
    scenario_sep = lowercase(string(S))
    root = "https://os.zhdk.cloud.switch.ch/chelsav2/GLOBAL/climatologies/$(year_sep)/$(model_sep)/$(var_code)/"
    stem = "CHELSA_$(lowercase(model_code))_r1i1p1f1_w5e5_$(scenario_code)_$(var_code)_$(month_code)_$(replace(year_sep, "-"=>"_"))_norm.tif"
    return (
        url = root * stem,
        filename = lowercase(stem),
        outdir = destination(data, future),
    )
end

@testitem "We have implemented CHELSA v2 future properly" begin
    using Dates

    @test CHELSA2 <: RasterProvider

    # Test the interface
    for D in Base.uniontypes(SimpleSDMDatasets.CHELSA2ProjectedDataset)
        data = RasterData(CHELSA2, D)
        for M in Base.uniontypes(SimpleSDMDatasets.CHELSA2Model)
            for S in Base.uniontypes(SimpleSDMDatasets.CHELSA2Scenario)
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
        data, future = RasterData(CHELSA2, BioClim), Projection(SSP585, GFDL_ESM4)
        out = downloader(data, future; layer = "BIO12")
        @test isfile(first(out))
        @test out[2] == SimpleSDMDatasets.filetype(data, future)
    end

    begin
        data, future =
            RasterData(CHELSA2, AverageTemperature), Projection(SSP126, IPSL_CM6A_LR)
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