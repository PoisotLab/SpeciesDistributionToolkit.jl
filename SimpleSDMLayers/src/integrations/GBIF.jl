# WARNING this file is only loaded if GBIF.jl is also active
# This all happens thanks to the Requires.jl package

import Base: getindex
import Base: setindex!
import SimpleSDMLayers: clip, latitudes, longitudes, mask!, mask

SimpleSDMLayers.longitudes(record::GBIF.GBIFRecord) = record.longitude
SimpleSDMLayers.latitudes(record::GBIF.GBIFRecord) = record.latitude

"""
    latitudes(records::GBIFRecords)

Returns the non-missing latitudes.
"""
SimpleSDMLayers.latitudes(records::GBIF.GBIFRecords) = filter(!ismissing, [latitudes(record) for record in records])

"""
    longitudes(records::GBIFRecords)

Returns the non-missing longitudes.
"""
SimpleSDMLayers.longitudes(records::GBIF.GBIFRecords) = filter(!ismissing, [longitudes(record) for record in records])


"""
    Base.getindex(p::T, occurrence::GBIF.GBIFRecord) where {T <: SimpleSDMLayer}

Extracts the value of a layer at a given position for a `GBIFRecord`. If the
`GBIFRecord` has no latitude or longitude, this will return `nothing`.
"""
function Base.getindex(layer::T, record::GBIF.GBIFRecord) where {T <: SimpleSDMLayer}
   ismissing(record.latitude) && return nothing
   ismissing(record.longitude) && return nothing
   return layer[Point(record.longitude, record.latitude)]
end

"""
    Base.setindex!(layer::T, v, record::GBIFRecord) where {T <: SimpleSDMResponse}

Changes the values of the cell including the point at the requested latitude and
longitude. **Be careful**, this function will not update a cell that has
`nothing`.
"""
function Base.setindex!(layer::SimpleSDMResponse{T}, v::T, record::GBIF.GBIFRecord) where {T}
   ismissing(record.latitude) && return nothing
   ismissing(record.longitude) && return nothing
   isnothing(layer[record]) && return nothing
   setindex!(layer, v, Point(record.longitude, record.latitude))
end

"""
    clip(layer::T, records::GBIF.GBIFRecords)

Returns a clipped version (with a 10% margin) around all occurences in a
GBIFRecords collection.
"""
function SimpleSDMLayers.clip(layer::T, records::GBIF.GBIFRecords) where {T <: SimpleSDMLayer}
   occ_latitudes = latitudes(records)
   occ_longitudes = longitudes(records)

   lat_min, lat_max = extrema(occ_latitudes)
   lon_min, lon_max = extrema(occ_longitudes)

   lat_Δ = abs(lat_max - lat_min)
   lon_Δ = abs(lon_max - lon_min)

   scaling = 0.1
   lon_s = scaling*lon_Δ
   lat_s = scaling*lat_Δ

   lat_max = min(layer.top, lat_max+lat_s)
   lat_min = max(layer.bottom, lat_min-lat_s)
   lon_max = min(layer.right, lon_max+lon_s)
   lon_min = max(layer.left, lon_min-lon_s)

   return clip(layer; left=lon_min, right=lon_max, bottom=lat_min, top=lat_max)
end

"""
    Base.getindex(layer::T, records::GBIF.GBIFRecords) where {T <: SimpleSDMLayer}

Returns the values of a layer at all occurrences in a `GBIFRecords` collection.
"""
function Base.getindex(layer::T, records::GBIF.GBIFRecords) where {T <: SimpleSDMLayer}
   return convert(Vector{eltype(layer)}, filter(!isnothing, [layer[records[i]] for i in 1:length(records)]))
end

"""
    Base.getindex(layer::T, records::Vector{GBIF.GBIFRecord}) where {T <: SimpleSDMLayer}

Returns the values of a layer at all occurrences in a `GBIFRecord` array.
"""
function Base.getindex(layer::T, records::Vector{GBIF.GBIFRecord}) where {T <: SimpleSDMLayer}
   return [layer[record] for record in records]
end

"""
    mask!(layer::SimpleSDMResponse{T}, records::GBIF.GBIFRecords) where {T <: AbstractBool}

Fills a layer (most likely created with `similar`) so that the values are `true`
if an occurrence is found in the cell, `false` if not.
"""
function mask!(layer::SimpleSDMResponse{T}, records::GBIF.GBIFRecords) where {T <: Bool}
    for record in records
        if !isnothing(layer[record])
            layer[record] = true
        end
    end
    return layer
end

"""
    mask!(layer::SimpleSDMResponse{T}, records::GBIF.GBIFRecords) where {T <: Number}

Fills a layer (most likely created with `similar`) so that the values reflect
the number of occurrences in the cell.
"""
function mask!(layer::SimpleSDMResponse{T}, records::GBIF.GBIFRecords) where {T <: Number}
    for record in records
        if !isnothing(layer[record])
            layer[record] = layer[record] + one(T)
        end
    end
    return layer
end

"""
    mask(layer::SimpleSDMLayer, records::GBIF.GBIFRecords, element_type::Type=Bool)

Create a new layer storing information about the presence of occurrences in the
cells, either counting (numeric types) or presence-absence-ing (boolean types)
them.
"""
function mask(layer::SimpleSDMLayer, records::GBIF.GBIFRecords, element_type::Type=Bool)
    returnlayer = similar(layer, element_type)
    mask!(returnlayer, records)
    return returnlayer
end

