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
include(joinpath(@__DIR__, "types", "datasets.jl"))
export RasterDataset
export BioClim, Elevation, MinimumTemperature, MaximumTemperature, AverageTemperature,
    Precipitation, SolarRadiation, WindSpeed, WaterVaporPressure, LandCover,
    HabitatHeterogeneity, Topography

include(joinpath(@__DIR__, "types", "providers.jl"))
export RasterProvider
export WorldClim2, EarthEnv, CHELSA1, CHELSA2

include(joinpath(@__DIR__, "types", "futures.jl"))
export FutureScenario, FutureModel

include(joinpath(@__DIR__, "types", "enums.jl"))

# CMIP6 exports
export CMIP6Scenario, CMIP6Model
export SSP126, SSP245, SSP370, SSP585
export ACCESS_CM2, ACCESS_ESM1_5, BCC_CSM2_MR, CanESM5, CanESM5_CanOE, CMCC_ESM2,
    CNRM_CM6_1, CNRM_CM6_1_HR, CNRM_ESM2_1, EC_Earth3_Veg, EC_Earth3_Veg_LR, FIO_ESM_2_0,
    GFDL_ESM4, GISS_E2_1_G, GISS_E2_1_H, HadGEM3_GC31_LL, INM_CM4_8, INM_CM5_0,
    IPSL_CM6A_LR, MIROC_ES2L, MIROC6, MPI_ESM1_2_LR, MPI_ESM1_2_HR, MRI_ESM2_0, UKESM1_0_LL

# Specifier types
include(joinpath(@__DIR__, "types", "specifiers.jl"))
export RasterData, Future

# Common interface
include(joinpath(@__DIR__, "interface.jl"))

# Providers
include(joinpath(@__DIR__, "providers", "CHELSA", "chelsa_v1.jl"))
include(joinpath(@__DIR__, "providers", "CHELSA", "chelsa_v2.jl"))
include(joinpath(@__DIR__, "providers", "CHELSA", "chelsa_future_v2.jl"))
include(joinpath(@__DIR__, "providers", "EarthEnv", "earthenv.jl"))
include(joinpath(@__DIR__, "providers", "WorldClim", "worldclim_v2.jl"))
include(joinpath(@__DIR__, "providers", "WorldClim", "worldclim_future_v2.jl"))

# Key checker
include(joinpath(@__DIR__, "keychecker.jl"))

# Downloader function
include(joinpath(@__DIR__, "downloader.jl"))
export downloader

end # module SimpleSDMDatasets
