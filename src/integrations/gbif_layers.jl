import Base: getindex
import Base: setindex!
import SimpleSDMLayers: mask!, mask

"""
    Base.getindex(p::T, occurrence::GBIF.GBIFRecord) where {T <: SimpleSDMLayer}

Extracts the value of a layer at a given position for a `GBIFRecord`. If the
`GBIFRecord` has no latitude or longitude, this will return `nothing`.
"""
function Base.getindex(layer::SDMLayer, record::GBIF.GBIFRecord)
    ismissing(record.latitude) && return nothing
    ismissing(record.longitude) && return nothing
    return layer[record.longitude, record.latitude]
end

"""
    Base.setindex!(layer::SDMLayer, v, record::GBIFRecord)

Changes the values of the cell including the point at the requested latitude and
longitude.
"""
function Base.setindex!(
    layer::SDMLayer{T},
    v::T,
    record::GBIF.GBIFRecord,
) where {T}
    ismissing(record.latitude) && return nothing
    ismissing(record.longitude) && return nothing
    return setindex!(layer, v, record.longitude, record.latitude)
end

"""
    Base.getindex(layer::T, records::GBIF.GBIFRecords) where {T <: SimpleSDMLayer}

Returns the values of a layer at all occurrences in a `GBIFRecords` collection.
"""
function Base.getindex(layer::SDMLayer, records::GBIF.GBIFRecords)
    K = eltype(layer)
    return convert(
        Vector{K},
        filter(!isnothing, [layer[r] for r in records]),
    )
end

"""
    Base.getindex(layer::SDMLayer, records::Vector{GBIF.GBIFRecord})

Returns the values of a layer at all occurrences in a `GBIFRecord` array.
"""
function Base.getindex(layer::SDMLayer, records::Vector{GBIF.GBIFRecord})
    return [layer[record] for record in records]
end

function SimpleSDMLayers.quantize!(layer::SDMLayer, records::GBIFRecords)
    ef = StatsBase.ecdf(layer[records])
    map!(ef, layer.grid, layer.grid)
    return layer
end

#=

"""
    mask!(layer::SimpleSDMResponse{T}, records::GBIF.GBIFRecords) where {T <: AbstractBool}

Fills a layer (most likely created with `similar`) so that the values are `true`
if an occurrence is found in the cell, `false` if not.
"""
function SimpleSDMLayers.mask!(
    layer::SDMLayer{T},
    records::GBIF.GBIFRecords,
) where {T <: Bool}
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
function SimpleSDMLayers.mask!(
    layer::SDMLayer{T},
    records::GBIF.GBIFRecords,
) where {T <: Number}
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
function SimpleSDMLayers.mask(
    layer::SDMLayer,
    records::GBIF.GBIFRecords,
    element_type::Type = Bool,
)
    returnlayer = similar(layer, element_type)
    mask!(returnlayer, records)
    return returnlayer
end

"""
    clip(layer::SDMLayer, records::GBIF.GBIFRecords)

Returns a clipped version around all occurrences in a
GBIFRecords collection.
"""
function clip(layer::SDMLayer, records::GBIF.GBIFRecords)
    occ_latitudes = latitudes(records)
    occ_longitudes = longitudes(records)

    lat_min, lat_max = extrema(occ_latitudes)
    lon_min, lon_max = extrema(occ_longitudes)

    lat_Δ = abs(lat_max - lat_min)
    lon_Δ = abs(lon_max - lon_min)

    scaling = 0.1
    lon_s = scaling * lon_Δ
    lat_s = scaling * lat_Δ

    lat_max = min(layer.top, lat_max + lat_s)
    lat_min = max(layer.bottom, lat_min - lat_s)
    lon_max = min(layer.right, lon_max + lon_s)
    lon_min = max(layer.left, lon_min - lon_s)

    return clip(layer; left = lon_min, right = lon_max, bottom = lat_min, top = lat_max)
end

=#