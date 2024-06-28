module SimpleSDMDatasets

import Downloads
using Dates
using ZipFile

# Set the potential paths for downloads
const _data_storage_folders = first([
    Base.DEPOT_PATH...,
    homedir(),
])

# Look for a path in the ENV, otherwise use the defaultest path from above
const _LAYER_PATH =
    get(ENV, "SDMLAYERS_PATH", joinpath(_data_storage_folders, "SimpleSDMDatasets"))
isdir(_LAYER_PATH) || mkpath(_LAYER_PATH)

# Types for datasets and providers
include("types/datasets.jl")
export RasterDataset
export BioClim, Elevation, MinimumTemperature, MaximumTemperature, AverageTemperature,
    Precipitation, SolarRadiation, WindSpeed, WaterVaporPressure, LandCover,
    HabitatHeterogeneity, Topography, SpeciesRichness

include("types/providers.jl")
export RasterProvider
export WorldClim2, EarthEnv, CHELSA1, CHELSA2, BiodiversityMapping

include("types/futures.jl")
export FutureScenario, FutureModel

include("types/enums.jl")

# CMIP6 exports
export CMIP6Scenario, CMIP6Model
export SSP126, SSP245, SSP370, SSP585
export ACCESS_CM2, ACCESS_ESM1_5, BCC_CSM2_MR, CanESM5, CanESM5_CanOE, CMCC_ESM2,
    CNRM_CM6_1, CNRM_CM6_1_HR, CNRM_ESM2_1, EC_Earth3_Veg, EC_Earth3_Veg_LR, FIO_ESM_2_0,
    GFDL_ESM4, GISS_E2_1_G, GISS_E2_1_H, HadGEM3_GC31_LL, INM_CM4_8, INM_CM5_0,
    IPSL_CM6A_LR, MIROC_ES2L, MIROC6, MPI_ESM1_2_LR, MPI_ESM1_2_HR, MRI_ESM2_0, UKESM1_0_LL
export RCP26, RCP45, RCP60, RCP85
export ACCESS1_0, BNU_ESM, CCSM4, CESM1_BGC, CESM1_CAM5, CMCC_CESM, CMCC_CMS, CMCC_CM,
    CNRM_CM5, CSIRO_Mk3_6_0, CSIRO_Mk3L_1_2, CanESM2, EC_EARTH, FGOALS_g2, FIO_ESM,
    GFDL_CM3, GFDL_ESM2G, GFDL_ESM2M, GISS_E2_H_CC, GISS_E2_H, GISS_E2_R_CC, GISS_E2_R,
    HadGEM2_AO, HadGEM2_CC, HadGEM2_ES, IPSL_CM5A_LR, IPSL_CM5A_MR, MIROC_ESM_CHEM,
    MIROC_ESM, MIROC5, MPI_ESM_LR, MPI_ESM_MR, MRI_CGCM3, MRI_ESM1, NorESM1_ME

# Specifier types
include("types/specifiers.jl")
export RasterData, Projection

# Common interface
include("interface.jl")
export layers, layerdescriptions

# Providers
include("providers/CHELSA/chelsa_v1.jl")
include("providers/CHELSA/chelsa_future_v1.jl")
include("providers/CHELSA/chelsa_v2.jl")
include("providers/CHELSA/chelsa_future_v2.jl")
include("providers/EarthEnv/earthenv.jl")
include("providers/WorldClim/worldclim_v2.jl")
include("providers/WorldClim/worldclim_future_v2.jl")
include("providers/BiodiversityMapping/biodiversitymapping.jl")

# Key checker
include("keychecker.jl")

# Downloader function
include("downloader.jl")
export downloader

end # module SimpleSDMDatasets
