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

"""
    EarthEnv

This provider offers access to the EarthEnv data, accessible from `https://www.earthenv.org/`.
"""
struct EarthEnv <: RasterProvider end

"""
    CHELSA1

This providers offers access to the version 1 of CHELSA data, accessible from `https://chelsa-climate.org/`. See also `CHELSA2`.
"""
struct CHELSA1 <: RasterProvider end

"""
    CHELSA2

This providers offers access to the version 2 of CHELSA data, accessible from `https://chelsa-climate.org/`. See also `CHELSA1`.
"""
struct CHELSA2 <: RasterProvider end
