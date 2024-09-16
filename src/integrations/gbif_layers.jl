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

function SimpleSDMLayers.quantize(layer::SDMLayer, records::GBIFRecords)
    ef = StatsBase.ecdf(layer[records])
    return ef.(layer)
end

function SimpleSDMLayers.mask(layer::SDMLayer, records::GBIF.GBIFRecords)
    out = zeros(layer, Bool)
    for record in records
        out[record] = true
    end
    return out
end

function SimpleSDMLayers.mask(
    layer::SDMLayer,
    records::GBIF.GBIFRecords,
    ::Type{T},
) where {T <: Number}
    out = zeros(layer, T)
    for record in records
        out[record] += one(T)
    end
    return out
end

function _bbox_from_layer(layer::SDMLayer)
    EL = eastings(layer)
    NL = northings(layer)
    prj = SimpleSDMLayers.Proj.Transformation(layer.crs, "+proj=longlat +datum=WGS84 +no_defs"; always_xy = true)

    b1 = [prj(EL[1], n) for n in NL]
    b2 = [prj(EL[end], n) for n in NL]
    b3 = [prj(e, NL[1]) for e in EL]
    b4 = [prj(e, NL[end]) for e in EL]
    bands = vcat(b1, b2, b3, b4)

    nx = extrema(first.(bands))
    ny = extrema(last.(bands))
    return (; left = nx[1], right = nx[2], bottom = ny[1], top = ny[2])
end

function GBIF.occurrences(t::GBIFTaxon, layer::SDMLayer, query::Pair...)
    spatial_extent = SpeciesDistributionToolkit._bbox_from_layer(layer)
    query = (query..., "decimalLatitude" => (spatial_extent.bottom, spatial_extent.top))
    query = (query..., "decimalLongitude" => (spatial_extent.left, spatial_extent.right))
    query = (query..., "hasCoordinate" => true)
    return occurrences(t, query...)
end

function GBIF.occurrences(layer::SDMLayer, query::Pair...)
    spatial_extent = SpeciesDistributionToolkit._bbox_from_layer(layer)
    query = (query..., "decimalLatitude" => (spatial_extent.bottom, spatial_extent.top))
    query = (query..., "decimalLongitude" => (spatial_extent.left, spatial_extent.right))
    query = (query..., "hasCoordinate" => true)
    return occurrences(query...)
end