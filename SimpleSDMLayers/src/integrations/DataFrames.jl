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

"""
    Base.setindex!(p::T, v, occurrence::GBIFRecord) where {T <: SimpleSDMResponse}

Changes the values of the cell including the point at the requested latitude and
longitude.
"""
function Base.setindex!(l::SimpleSDMResponse{T}, values::Array{T}, df::DataFrames.DataFrame; latitude = :latitude, longitude = :longitude) where {T}
    lats = df[:, latitude]
    lons = df[:, longitude]
    [setindex!(l, v, lon, lat) for (v, lon, lat) in zip(values, lons, lats)]
end