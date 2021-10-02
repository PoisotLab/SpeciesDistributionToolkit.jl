
"""
    LayerProvider

A `LayerProvider` is an abstract type used to dispatch the correct call of
`SimpleSDMPredictor` to a specific dataset. A dataset is specified by a
`LayerProvider` and a `LayerDataset`, as well as optionally one or multiple
layers, and future climate information.
"""
abstract type LayerProvider end

"""
    LayerDataset

A `LayerDataset` is a specific set of rasters provided by a `LayerProvider`.
"""
abstract type LayerDataset end

"""
    WorldClim

TODO WorldClim

This provider currently offers `BioClim` data, both historical and future under
`CMIP6`.
"""
struct WorldClim <: LayerProvider end

"""
    CHELSA

TODO CHELSA

This provider currently offers `BioClim` data, both historical and future under
`CMIP5`.
"""
struct CHELSA <: LayerProvider end

"""
    EarthEnv

Data from the earthenv project, all released under a CC-BY-NC license to Tuanmu
& Jetz. This provider currently offers `LandCover` and `HabitatHeterogeneity`
rasters.
"""
struct EarthEnv <: LayerProvider end

"""
    BioClim

A list of 19 bioclimatic variables derived from the monthly temperature and
precipitation data. This dataset is provided by `WorldClim` and `CHELSA`, both
of which offer future versions under `CMIP5` and `CMIP6` models.

| Variable | Description                                                |
| ------   | ------                                                     |
| 1        | Annual Mean Temperature                                    |
| 2        | Mean Diurnal Range (Mean of monthly (max temp - min temp)) |
| 3        | Isothermality (BIO2/BIO7) (* 100)                          |
| 4        | Temperature Seasonality (standard deviation *100)          |
| 5        | Max Temperature of Warmest Month                           |
| 6        | Min Temperature of Coldest Month                           |
| 7        | Temperature Annual Range (BIO5-BIO6)                       |
| 8        | Mean Temperature of Wettest Quarter                        |
| 9        | Mean Temperature of Driest Quarter                         |
| 10       | Mean Temperature of Warmest Quarter                        |
| 11       | Mean Temperature of Coldest Quarter                        |
| 12       | Annual Precipitation                                       |
| 13       | Precipitation of Wettest Month                             |
| 14       | Precipitation of Driest Month                              |
| 15       | Precipitation Seasonality (Coefficient of Variation)       |
| 16       | Precipitation of Wettest Quarter                           |
| 17       | Precipitation of Driest Quarter                            |
| 18       | Precipitation of Warmest Quarter                           |
| 19       | Precipitation of Coldest Quarter                           |
"""
struct BioClim <: LayerDataset end

"""
    LandCover

Information on land cover, currently only provided by `EarthEnv`.
"""
struct LandCover <: LayerDataset end

"""
    HabitatHeterogeneity

Information on habitat heterogeneity, currently only provided by `EarthEnv`.
"""
struct HabitatHeterogeneity <: LayerDataset end

"""
    SharedSocioeconomicPathway

Enumeration of the four SSPs, which can be listed with
`instances(SharedSocioeconomicPathway)`. These are meant to be used with `CMIP6`
models.
"""
@enum SharedSocioeconomicPathway SSP126 SSP245 SSP370 SSP585

"""
    RepresentativeConcentrationPathway

Enumeration of the four RCPs, which can be listed with
`instances(RepresentativeConcentrationPathway)`. These are meant to be used with
`CMIP5` models.
"""
@enum RepresentativeConcentrationPathway RCP26 RCP45 RCP60 RCP85

"""
    CMIP6

Enumeration of the models from CMIP6, which can be listed with
`instances(CMIP6)`.
"""
@enum CMIP6 BCCCSM2MR CNRMCMS61 CNRMESM21 CanESM5 GFDLESM4 IPSLCM6ALR MIROCES2L MIROC6 MRIESM2

"""
    CMIP5

Enumeration of the models from CMIP5, which can be listed with
`instances(CMIP5)`.
"""
@enum CMIP5 ACCESS10 BNUESM CCSM4 CESM1BGC CESM1CAM5 CMCCCMS CMCCCM CNRMCM5 CSIROMK360 CanESM2 FGOALSG2 FIOESM GFDLCM3 GFDLESM2G GFDLESM2M GISSE2HCC GISSE2H GISSE2RCC GISSE2R HADGEM2AO HADGEM2CC IPSLCM5ALR IPSLCM5AMR MIROCESMCHEM MIROCESM MIROC5 MPIESMLR MPIESMMR MRICGCM3 MRIESM1 NORESM1M BCCCSM11 INMCM4

# Provider paths
_rasterpath(::Type{WorldClim}) = "WorldClim"
_rasterpath(::Type{CHELSA}) = "CHELSA"
_rasterpath(::Type{EarthEnv}) = "EarthEnv"

# Dataset paths
_rasterpath(::Type{BioClim}) = "BioClim"
_rasterpath(::Type{LandCover}) = "LandCover"
_rasterpath(::Type{HabitatHeterogeneity}) = "HabitatHeterogeneity"

# Future paths
_rasterpath(model::CMIP6) = _rasterpath(Val{model})
_rasterpath(model::CMIP5) = _rasterpath(Val{model})
_rasterpath(ssp::SharedSocioeconomicPathway) = _rasterpath(Val{ssp})
_rasterpath(rcp::RepresentativeConcentrationPathway) = _rasterpath(Val{rcp})

# SSP path
_rasterpath(::Type{Val{SSP126}}) = "ssp126"
_rasterpath(::Type{Val{SSP245}}) = "ssp245"
_rasterpath(::Type{Val{SSP370}}) = "ssp370"
_rasterpath(::Type{Val{SSP585}}) = "ssp585"

# RCP path
_rasterpath(::Type{Val{RCP26}}) = "rcp26"
_rasterpath(::Type{Val{RCP45}}) = "rcp45"
_rasterpath(::Type{Val{RCP60}}) = "rcp60"
_rasterpath(::Type{Val{RCP85}}) = "rcp85"

# CMIP6 path
_rasterpath(::Type{Val{BCCCSM2MR}}) = "BCC-CSM2-MR"
_rasterpath(::Type{Val{CNRMCMS61}}) = "CNRM-CM6-1"
_rasterpath(::Type{Val{CNRMESM21}}) = "CNRM-ESM2-1"
_rasterpath(::Type{Val{CanESM5}}) = "CanESM5"
_rasterpath(::Type{Val{GFDLESM4}}) = "GFDL-ESM4"
_rasterpath(::Type{Val{IPSLCM6ALR}}) = "IPSL-CM6A-LR"
_rasterpath(::Type{Val{MIROCES2L}}) = "MIROC-ES2L"
_rasterpath(::Type{Val{MIROC6}}) = "MIROC6"
_rasterpath(::Type{Val{MRIESM2}}) = "MRI-ESM2-0"

# CMIP5 path
_rasterpath(::Type{Val{ACCESS10}}) = "ACCESS1-0"
_rasterpath(::Type{Val{BNUESM}}) = "BNU-ESM"
_rasterpath(::Type{Val{CCSM4}}) = "CCSM4"
_rasterpath(::Type{Val{CESM1BGC}}) = "CESM1-BGC"
_rasterpath(::Type{Val{CESM1CAM5}}) = "CESM1-CAM5"
_rasterpath(::Type{Val{CMCCCMS}}) = "CMCC-CMS"
_rasterpath(::Type{Val{CMCCCM}}) = "CMCC-CM"
_rasterpath(::Type{Val{CNRMCM5}}) = "CNRM-CM5"
_rasterpath(::Type{Val{CSIROMK360}}) = "CSIRO-Mk3-6-0"
_rasterpath(::Type{Val{CanESM2}}) = "CanESM2"
_rasterpath(::Type{Val{FGOALSG2}}) = "FGOALS-g2"
_rasterpath(::Type{Val{FIOESM}}) = "FIO-ESM"
_rasterpath(::Type{Val{GFDLCM3}}) = "GFDL-CM3"
_rasterpath(::Type{Val{GFDLESM2G}}) = "GFDL-ESM2G"
_rasterpath(::Type{Val{GFDLESM2M}}) = "GFDL-ESM2M"
_rasterpath(::Type{Val{GISSE2HCC}}) = "GISS-E2-H-CC"
_rasterpath(::Type{Val{GISSE2H}}) = "GISS-E2-H"
_rasterpath(::Type{Val{GISSE2RCC}}) = "GISS-E2-R-CC"
_rasterpath(::Type{Val{GISSE2R}}) = "GISS-E2-R"
_rasterpath(::Type{Val{HADGEM2AO}}) = "HadGEM2-AO"
_rasterpath(::Type{Val{HADGEM2CC}}) = "HadGEM2-CC"
_rasterpath(::Type{Val{IPSLCM5ALR}}) = "IPSL-CM5A-LR"
_rasterpath(::Type{Val{IPSLCM5AMR}}) = "IPSL-CM5A-MR"
_rasterpath(::Type{Val{MIROCESMCHEM}}) = "MIROC-ESM-CHEM"
_rasterpath(::Type{Val{MIROCESM}}) = "MIROC-ESM"
_rasterpath(::Type{Val{MIROC5}}) = "MIROC5"
_rasterpath(::Type{Val{MPIESMLR}}) = "MPI-ESM-LR"
_rasterpath(::Type{Val{MPIESMMR}}) = "MPI-ESM-MR"
_rasterpath(::Type{Val{MRICGCM3}}) = "MRI-CGCM3"
_rasterpath(::Type{Val{MRIESM1}}) = "MRI-ESM1"
_rasterpath(::Type{Val{NORESM1M}}) = "NorESM1-M"
_rasterpath(::Type{Val{BCCCSM11}}) = "bcc-csm1-1"
_rasterpath(::Type{Val{INMCM4}}) = "inmcm4"
