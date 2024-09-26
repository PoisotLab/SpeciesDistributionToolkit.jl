CHELSA1Scenario = Union{RCP26, RCP45, RCP60, RCP85}
CHELSA1Model = Union{
    ACCESS1_0,
    BNU_ESM,
    CCSM4,
    CESM1_BGC,
    CESM1_CAM5,
    CMCC_CESM,
    CMCC_CMS,
    CMCC_CM,
    CNRM_CM5,
    CSIRO_Mk3_6_0,
    CSIRO_Mk3L_1_2,
    CanESM2,
    EC_EARTH,
    FGOALS_g2,
    FIO_ESM,
    GFDL_CM3,
    GFDL_ESM2G,
    GFDL_ESM2M,
    GISS_E2_H_CC,
    GISS_E2_H,
    GISS_E2_R_CC,
    GISS_E2_R,
    HadGEM2_AO,
    HadGEM2_CC,
    HadGEM2_ES,
    IPSL_CM5A_LR,
    IPSL_CM5A_MR,
    MIROC_ESM_CHEM,
    MIROC_ESM,
    MIROC5,
    MPI_ESM_LR,
    MPI_ESM_MR,
    MRI_CGCM3,
    MRI_ESM1,
    NorESM1_ME,
}
CHELSA1ProjectedDataset = Union{
    BioClim,
    Precipitation,
    AverageTemperature,
    MinimumTemperature,
    MaximumTemperature,
}

provides(
    ::RasterData{CHELSA1, T},
    ::Projection{S, M},
) where {T <: CHELSA1ProjectedDataset, S <: CHELSA1Scenario, M <: CHELSA1Model} = true

timespans(
    ::RasterData{CHELSA1, T},
    ::Projection{S, M},
) where {T <: CHELSA1ProjectedDataset, S <: CHELSA1Scenario, M <: CHELSA1Model} = [
    Year(2041) => Year(2060),
    Year(2061) => Year(2080),
]

function source(
    data::RasterData{CHELSA1, T},
    future::Projection{S, M};
    layer = first(SimpleSDMDatasets.layers(data, future)),
    timespan = first(SimpleSDMDatasets.timespans(data, future)),
) where {T <: BioClim, S <: CHELSA1Scenario, M <: CHELSA1Model}
    var_code = (layer isa Integer) ? layer : findfirst(isequal(layer), layers(data))
    year_sep = string(timespan.first.value) * "-" * string(timespan.second.value)
    root = "https://os.zhdk.cloud.switch.ch/chelsav1/cmip5/$(year_sep)/bio/"
    stem = "CHELSA_bio_mon_$(replace(string(M), "_" => "-"))_$(lowercase(string(S)))_r1i1p1_g025.nc_$(var_code)_$(year_sep)_V1.2.tif"
    return (
        url = root * stem,
        filename = lowercase(stem),
        outdir = destination(data, future),
    )
end

function source(
    data::RasterData{CHELSA1, T},
    future::Projection{S, M};
    month = first(SimpleSDMDatasets.months(data, future)),
    timespan = first(SimpleSDMDatasets.timespans(data, future)),
) where {T <: CHELSA1ProjectedDataset, S <: CHELSA1Scenario, M <: CHELSA1Model}
    var_code = _var_slug(data)
    if var_code == "tmean"
        var_code = "tas"
    end
    var_url =
        Dict(["pr" => "prec", "tasmin" => "tmin", "tas" => "temp", "tasmax" => "tmax"])
    month_code = string(month.value)
    year_sep = string(timespan.first.value) * "-" * string(timespan.second.value)
    root = "https://os.zhdk.cloud.switch.ch/chelsav1/cmip5/$(year_sep)/$(var_url[var_code])/"
    stem = "CHELSA_$(var_code)_mon_$(replace(string(M), "_" => "-"))_$(lowercase(string(S)))_r1i1p1_g025.nc_$(month_code)_$(year_sep)_V1.2.tif"
    return (
        url = root * stem,
        filename = lowercase(stem),
        outdir = destination(data, future),
    )
end
