function SimpleSDMDatasets.blurb(::RasterData{P, BioClim}) where {P <: RasterProvider}
    return md"""
    The BioClim variables are derived from monthly data about precipitation and
    temperature, and convey information about annual variation, as well as
    extreme values for specific quarters. These variables are usually thought to
    represent limiting environmental conditions.
    """
end

function SimpleSDMDatasets.blurb(::RasterData{P, Elevation}) where {P <: RasterProvider}
    return md"""
    Information about elevation, that usually comes from a DEM.
    """
end

function SimpleSDMDatasets.blurb(::RasterData{P, MinimumTemperature}) where {P <: RasterProvider}
    return md"""
    Minimum temperature within each grid cell, usually represented in degrees,
    and usually provided as part of a dataset giving daily, weekly, or monthly
    temporal resolution.
    """
end

function SimpleSDMDatasets.blurb(::RasterData{P, MaximumTemperature}) where {P <: RasterProvider}
    return md"""
    Maximum temperature within each grid cell, usually represented in degrees,
    and usually provided as part of a dataset giving daily, weekly, or monthly
    temporal resolution.
    """
end

function SimpleSDMDatasets.blurb(::RasterData{P, AverageTemperature}) where {P <: RasterProvider}
    return md"""
    Average temperature within each grid cell, usually represented in degrees,
    and usually provided as part of a dataset giving daily, weekly, or monthly
    temporal resolution.
    """
end

function SimpleSDMDatasets.blurb(::RasterData{P, Precipitation}) where {P <: RasterProvider}
    return md"""
    Precipitation (rainfall) within each grid cell, usually represented as the
    total amount received, and usually provided as part of a dataset giving
    daily, weekly, or monthly temporal resolution.
    """
end

function SimpleSDMDatasets.blurb(::RasterData{P, Topography}) where {P <: RasterProvider}
    return md"""
    Information about the shape of terrain, that unlike `Elevation` can provide
    information about more than the altitude.
    """
end

function SimpleSDMDatasets.blurb(::RasterData{P, HabitatHeterogeneity}) where {P <: RasterProvider}
    return md"""
    Derived information about the topography, giving information about the local
    heterogeneity within a grid cell.
    """
end

function SimpleSDMDatasets.blurb(::RasterData{P, LandCover}) where {P <: RasterProvider}
    return md"""
    Information about the type of land-use within each pixel, that can be
    communicated as a fraction (*i.e.* the proportion of the cell occupied by a
    specific category), or as a consensus.
    """
end