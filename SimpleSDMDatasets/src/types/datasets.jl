"""
    RasterDataset

This is an *abstract* type to label something as being a dataset. Datasets are
given by `RasterProvider`s, and the same dataset can have multiple providers.
"""
abstract type RasterDataset end

"""
    BioClim
"""
struct BioClim <: RasterDataset end

"""
    Elevation
"""
struct Elevation <: RasterDataset end

"""
    MinimumTemperature
"""
struct MinimumTemperature <: RasterDataset end

"""
    MaximumTemperature
"""
struct MaximumTemperature <: RasterDataset end

"""
    AverageTemperature
"""
struct AverageTemperature <: RasterDataset end

"""
    Precipitation
"""
struct Precipitation <: RasterDataset end

"""
    SolarRadiation
"""
struct SolarRadiation <: RasterDataset end

"""
    WindSpeed
"""
struct WindSpeed <: RasterDataset end

"""
    WaterVaporPressure
"""
struct WaterVaporPressure <: RasterDataset end

"""
    LandCover
"""
struct LandCover <: RasterDataset end

"""
    HabitatHeterogeneity
"""
struct HabitatHeterogeneity <: RasterDataset end

"""
    Topography
"""
struct Topography <: RasterDataset end

"""
    MammalRichness
"""
struct MammalRichness <: RasterDataset end

"""
    BirdRichness
"""
struct BirdRichness <: RasterDataset end

"""
    AmphibianRichness
"""
struct AmphibianRichness <: RasterDataset end