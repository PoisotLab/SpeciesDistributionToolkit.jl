"""
    RasterProvider

This is an *abstract* type to label something as a provider of `RasterDataset`s.
For example, WorldClim2 and CHELSA2 are `RasterProvider`s.
"""
abstract type RasterProvider end

"""
    WorldClim2

This provider offers access to the version 2 of the WorldClim data, accessible from `http://www.worldclim.com/version2`.
"""
struct WorldClim2 <: RasterProvider end

struct EarthEnv <: RasterProvider end

struct CHELSA1 <: RasterProvider end

struct CHELSA2 <: RasterProvider end
