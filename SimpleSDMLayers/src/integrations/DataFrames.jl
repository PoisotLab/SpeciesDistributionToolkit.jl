# WARNING this file is only loaded if DataFrames.jl is also active
# This all happens thanks to the Requires.jl package

import Base: getindex
import Base: setindex!
import SimpleSDMLayers: clip, latitudes, longitudes

"""
    Base.getindex(p::T, r::GBIF.GBIFRecords) where {T <: SimpleSDMLayer}

Returns the values of a layer at all occurrences in a `DataFrame`.
"""
function Base.getindex(layer::T, df::DataFrames.DataFrame; latitude = :latitude, longitude = :longitude) where {T <: SimpleSDMLayer}
    lats = df[:, latitude]
    lons = df[:, longitude]
    return [layer[lon, lat] for (lon, lat) in zip(lons, lats)]
end

"""
    clip(p::T, r::DataFrames.DataFrame)

Returns a clipped version (with a 10% margin) around all occurences in a
`DataFrame`.
"""
function SimpleSDMLayers.clip(layer::T, df::DataFrames.DataFrame; latitude = :latitude, longitude = :longitude) where {T <: SimpleSDMLayer}
   occ_latitudes = filter(!ismissing, df[:, latitude])
   occ_longitudes = filter(!ismissing, df[:, longitude])

   lat_min = minimum(occ_latitudes)
   lat_max = maximum(occ_latitudes)
   lon_min = minimum(occ_longitudes)
   lon_max = maximum(occ_longitudes)

   lat_Δ = abs(lat_max - lat_min)
   lon_Δ = abs(lon_max - lon_min)

   scaling = 0.1
   lon_s = scaling*lon_Δ
   lat_s = scaling*lat_Δ

   lat_max = min(layer.top, lat_max+lat_s)
   lat_min = max(layer.bottom, lat_min-lat_s)
   lon_max = min(layer.right, lon_max+lon_s)
   lon_min = max(layer.left, lon_min-lon_s)

   return layer[left=lon_min, right=lon_max, bottom=lat_min, top=lat_max]
end