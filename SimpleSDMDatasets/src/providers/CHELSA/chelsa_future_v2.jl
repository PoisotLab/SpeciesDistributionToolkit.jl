CHELSA2Scenario = Union{SSP126, SSP370, SSP585}
CHELSA2Model = Union{GFDL_ESM4, IPSL_CM6A_LR, MPI_ESM1_2_HR, MRI_ESM2_0, UKESM1_0_LL}
CHELSA2ProjectedDataset = Union{BioClim, Precipitation, AverageTemperature, MinimumTemperature, MaximumTemperature}

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
    year_sep = string(timespan.first.value) * "-" * string(timespan.second.value)
    model_sep = replace(uppercase(string(M)) * "/" * lowercase(string(S)), "_" => "-")
    root = "https://envicloud.wsl.ch/envicloud/chelsa/chelsa_V2/GLOBAL/climatologies/$(year_sep)/$(model_sep)/bio/"
    stem = "CHELSA_bio$(var_code)_$(year_sep)_$(lowercase(replace(string(M), "_" => "-")))_$(lowercase(string(S)))_V.2.1.tif"
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
    scenario_code = replace(lowercase(string(S)), "_" => "-")
    root = "https://envicloud.wsl.ch/envicloud/chelsa/chelsa_V2/GLOBAL/climatologies/$(year_sep)/$(model_code)/$(scenario_code)/$(var_code)/"
    stem = "CHELSA_$(lowercase(model_code))_r1i1p1f1_w5e5_$(scenario_code)_$(var_code)_$(month_code)_$(replace(year_sep, "-"=>"_"))_norm.tif"
    return (
        url = root * stem,
        filename = lowercase(stem),
        outdir = destination(data, future),
    )
end
