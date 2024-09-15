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

function SimpleSDMLayers.mask(layer::SDMLayer, records::GBIF.GBIFRecords, ::Type{T}) where {T <: Number}
    out = zeros(layer, T)
    for record in records
        out[record] += one(T)
    end
    return out
end
