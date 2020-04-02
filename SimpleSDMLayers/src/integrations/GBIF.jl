# WARNING this file is only loaded if GBIF.jl is also active
# This all happens thanks to the Requires.jl package

import Base: getindex
import Base: setindex!

"""
    Base.getindex(p::T, occurrence::GBIF.GBIFRecord) where {T <: SimpleSDMLayer}

Extracts the value of a layer at a given position for a `GBIFRecord`. If the
`GBIFRecord` has no latitude or longitude, this will return `NaN`.
"""
function Base.getindex(p::T, occurrence::GBIF.GBIFRecord) where {T <: SimpleSDMLayer}
   ismissing(occurrence.latitude) && return NaN
   ismissing(occurrence.longitude) && return NaN
   return p[occurrence.longitude, occurrence.latitude]
end

"""
    Base.setindex!(p::T, v, occurrence::GBIFRecord) where {T <: SimpleSDMResponse}

Changes the values of the cell including the point at the requested latitude and
longitude.
"""
function Base.setindex!(p::SimpleSDMResponse{T}, v::T, occurrence::GBIF.GBIFRecord) where {T}
   ismissing(occurrence.latitude) && return nothing
   ismissing(occurrence.longitude) && return nothing
   setindex!(p, v, occurrence.longitude, occurrence.latitude)
end

"""
    clip(p::T, r::GBIF.GBIFRecords)

Returns a clipped version (with a 5% margin) around all occurences in a
GBIFRecords collection.
"""
function clip(p::T, r::GBIF.GBIFRecords)
   occ_latitudes = filter!(ismissing, [o.latitude for o in r])
   occ_longitudes = filter!(ismissing, [o.longitude for o in r])

   lat_min, lat_max = minimum(occ_latitudes), maximum(occ_latitudes)
   lon_min, lon_max = minimum(occ_longitudes), maximum(occ_longitudes)

   lat_Δ = lat_max - lat_min
   lon_Δ = lon_max - lon_min

   lat_max = min(p.top, (0.05*lat_Δ)+lat_max)
   lat_min = max(p.bottom, (0.05*lat_Δ)-lat_min)
   lon_max = min(p.right, (0.05*lon_Δ)+lon_max)
   lon_min = max(p.left, (0.05*lon_Δ)-lon_min)

   return p[left=lon_min, right=lon_max, bottom=lat_min, top=lat_max]
end

"""
    Base.getindex(p::T, r::GBIF.GBIFRecords) where {T <: SimpleSDMLayer}

Returns the values of a layer at all occurrences in a `GBIFRecords` collection.
"""
function Base.getindex(p::T, r::GBIF.GBIFRecords) where {T <: SimpleSDMLayer}
   return [p[o] for o in r]
end
