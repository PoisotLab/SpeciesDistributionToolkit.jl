abstract type LayerProvider end
abstract type LayerDataset end

struct WorldClim <: LayerProvider end
struct CHELSA <: LayerProvider end
struct EarthEnv <: LayerProvider end

struct BioClim <: LayerDataset end
struct LandCover <: LayerDataset end
struct HabitatHeterogeneity <: LayerDataset end

# Provider paths
_rasterpath(::Type{WorldClim}) = "WorldClim"
_rasterpath(::Type{CHELSA}) = "CHELSA"
_rasterpath(::Type{EarthEnv}) = "EarthEnv"

# Dataset paths
_rasterpath(::Type{BioClim}) = "BioClim"
_rasterpath(::Type{LandCover}) = "LandCover"
_rasterpath(::Type{HabitatHeterogeneity}) = "HabitatHeterogeneity"

# Future climate information as enum types
@enum SharedSocioeconomicPathway SSP126 SSP245 SSP370 SSP585
@enum RepresentativeConcentrationPathway RCP26 RCP45 RCP60 RCP85

@enum CMIP6 BCCCSM2MR CNRMCMS61 CNRMESM21 CanESM5 GFDLESM4 IPSLCM6ALR MIROCES2L MIROC6 MRIESM2
@enum CMIP5 BCCCSM2MR CNRMCMS61 CNRMESM21 CanESM5 GFDLESM4 IPSLCM6ALR MIROCES2L MIROC6 MRIESM2

# SSP path
_rasterpath(ssp::SharedSocioeconomicPathway) = _rasterpath(Val{ssp})
_rasterpath(::Type{Val{SSP126}}) = "ssp126"
_rasterpath(::Type{Val{SSP245}}) = "ssp245"
_rasterpath(::Type{Val{SSP370}}) = "ssp370"
_rasterpath(::Type{Val{SSP585}}) = "ssp585"

# CMIP6 path
_rasterpath(model::CMIP6) = _rasterpath(Val{model})
_rasterpath(::Type{Val{BCCCSM2MR}}) = "BCC-CSM2-MR"
_rasterpath(::Type{Val{CNRMCMS61}}) = "CNRM-CM6-1"
_rasterpath(::Type{Val{CNRMESM21}}) = "CNRM-ESM2-1"
_rasterpath(::Type{Val{CanESM5}}) = "CanESM5"
_rasterpath(::Type{Val{GFDLESM4}}) = "GFDL-ESM4"
_rasterpath(::Type{Val{IPSLCM6ALR}}) = "IPSL-CM6A-LR"
_rasterpath(::Type{Val{MIROCES2L}}) = "MIROC-ES2L"
_rasterpath(::Type{Val{MIROC6}}) = "MIROC6"
_rasterpath(::Type{Val{MRIESM2}}) = "MRI-ESM2-0"
