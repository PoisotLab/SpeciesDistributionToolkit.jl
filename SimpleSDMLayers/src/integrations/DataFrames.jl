# WARNING this file is only loaded if DataFrames.jl is also active
# This all happens thanks to the Requires.jl package

import Base: getindex
import Base: setindex!
import SimpleSDMLayers: clip, latitudes, longitudes

"""
    Base.getindex(p::T, r::GBIF.GBIFRecords) where {T <: SimpleSDMLayer}

Returns the values of a layer at all occurrences in a `DataFrame`.
"""
function Base.getindex(l::T, df::DataFrames.DataFrame; latitude = :latitude, longitude = :longitude) where {T <: SimpleSDMLayer}
    lats = df[:, latitude]
    lons = df[:, longitude]
    return [l[lon, lat] for (lon, lat) in zip(lons, lats)]
end