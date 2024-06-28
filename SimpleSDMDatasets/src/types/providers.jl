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
"""
struct EarthEnv <: RasterProvider end

"""
    CHELSA1
"""
struct CHELSA1 <: RasterProvider end

"""
    CHELSA2
"""
struct CHELSA2 <: RasterProvider end

"""
    BiodiversityMapping

Global biodiveristy data from https://biodiversitymapping.org/ - see this website for citation information
"""
struct BiodiversityMapping <: RasterProvider end