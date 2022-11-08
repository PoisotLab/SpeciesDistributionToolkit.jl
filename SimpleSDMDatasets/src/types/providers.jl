"""
    RasterProvider

This is an *abstract* type to label something as a provider of `RasterDataset`s.
For example, WorldClim2 and CHELSA2 are `RasterProvider`s.
"""
abstract type RasterProvider end

struct WorldClim2 <: RasterProvider end
struct EarthEnv <: RasterProvider end
struct CHELSA1 <: RasterProvider end
struct CHELSA2 <: RasterProvider end