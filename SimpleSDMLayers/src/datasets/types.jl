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

