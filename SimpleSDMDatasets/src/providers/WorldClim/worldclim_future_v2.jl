WorldClim2Scenario = Union{SSP126, SSP245, SSP370, SSP585}
WorldClim2Model = Union{
    ACCESS_CM2,
    ACCESS_ESM1_5,
    BCC_CSM2_MR,
    CanESM5,
    CanESM5_CanOE,
    CMCC_ESM2,
    CNRM_CM6_1,
    CNRM_CM6_1_HR,
    CNRM_ESM2_1,
    EC_Earth3_Veg,
    EC_Earth3_Veg_LR,
    FIO_ESM_2_0,
    GFDL_ESM4,
    GISS_E2_1_G,
    GISS_E2_1_H,
    HadGEM3_GC31_LL,
    INM_CM4_8,
    INM_CM5_0,
    IPSL_CM6A_LR,
    MIROC_ES2L,
    MIROC6,
    MPI_ESM1_2_LR,
    MPI_ESM1_2_HR,
    MRI_ESM2_0,
    UKESM1_0_LL,
}
WorldClim2FutureDataset = Union{
    BioClim,
    Precipitation,
    MinimumTemperature,
    MaximumTemperature,
}

provides(
    ::RasterData{WorldClim2, T},
    ::Projection{S, M},
) where {T <: WorldClim2FutureDataset, S <: WorldClim2Scenario, M <: WorldClim2Model} = true

provides(
    ::RasterData{WorldClim2, T},
    ::Projection{SSP370, FIO_ESM_2_0},
) where {T <: WorldClim2FutureDataset} = false

provides(
    ::RasterData{WorldClim2, T},
    ::Projection{SSP245, GFDL_ESM4},
) where {T <: WorldClim2FutureDataset} = false

provides(
    ::RasterData{WorldClim2, T},
    ::Projection{SSP585, GFDL_ESM4},
) where {T <: WorldClim2FutureDataset} = false

provides(
    ::RasterData{WorldClim2, T},
    ::Projection{SSP370, HadGEM3_GC31_LL},
) where {T <: WorldClim2FutureDataset} = false

downloadtype(
    ::RasterData{WorldClim2, T},
    ::F,
) where {T <: WorldClim2FutureDataset, F <: Projection} = _file

timespans(
    ::RasterData{WorldClim2, T},
    ::Projection{S, M},
) where {T <: WorldClim2FutureDataset, S <: WorldClim2Scenario, M <: WorldClim2Model} = [
    Year(2021) => Year(2040),
    Year(2041) => Year(2060),
    Year(2061) => Year(2080),
    Year(2081) => Year(2100),
]

function source(
    data::RasterData{WorldClim2, T},
    future::Projection{S, M};
    timespan = first(SimpleSDMDatasets.timespans(data, future)),
    resolution = maximum(keys(SimpleSDMDatasets.resolutions(data))),
    args...,
) where {T <: WorldClim2FutureDataset, S <: WorldClim2Scenario, M <: WorldClim2Model}
    var_code = T <: BioClim ? "bioc" : _var_slug(data)
    res_code = get(resolutions(data), resolution, "10m")
    year_sep = string(timespan.first.value) * "-" * string(timespan.second.value)
    mod_code = replace(string(M), "_" => "-")
    ssp_code = lowercase(string(S))
    root = "https://geodata.ucdavis.edu/cmip6/$(res_code)/$(mod_code)/$(ssp_code)/"
    stem = "wc2.1_$(res_code)_$(var_code)_$(mod_code)_$(ssp_code)_$(year_sep).tif"
    return (
        url = root * stem,
        filename = lowercase(stem),
        outdir = destination(data, future),
    )
end

function bandnumber(
    data::RasterData{WorldClim2, BioClim},
    ::F;
    kwargs...,
) where {F <: Projection}
    @assert :layer in keys(kwargs)
    l = values(kwargs).layer
    return (l isa Integer) ? l : findfirst(isequal(l), layers(data))
end
