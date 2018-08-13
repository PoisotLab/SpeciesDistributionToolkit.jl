"""
**Represents an occurrence in the GBIF format**

This is currently a subset of all the fields. This `struct` is *not* mutable --
this ensures that the objects returned from the GBIF database are never modified
by the user.
"""
struct GBIFRecord
    key::Integer
    datasetKey::String
    dataset::Union{String,Nothing}
    publishingOrgKey::Union{AbstractString,Nothing}
    publishingCountry::Union{AbstractString,Nothing}
    institutionCode::Union{AbstractString,Nothing}
    protocol::Union{AbstractString,Nothing}
    crawled::Union{DateTime, Nothing}
    parsed::Union{DateTime, Nothing}
    modified::Union{DateTime, Nothing}
    interpreted::Union{DateTime, Nothing}
    countryCode::Union{AbstractString,Nothing}
    country::Union{AbstractString,Nothing}
    basisOfRecord::Symbol
    individualCount::Union{Integer, Nothing}
    latitude::Union{AbstractFloat, Nothing}
    longitude::Union{AbstractFloat, Nothing}
    precision::Union{AbstractFloat, Nothing}
    uncertainty::Union{AbstractFloat, Nothing}
    geodetic::Union{AbstractString,Nothing}
    date::Union{DateTime, Nothing}
    issues::Array{Symbol,1}
    taxonKey::Union{Integer, Nothing}
    rank::Union{String,Nothing}
    taxon::GBIFTaxon
    generic::Union{AbstractString,Nothing}
    epithet::Union{AbstractString,Nothing}
    vernacular::Union{AbstractString,Nothing}
    scientific::Union{AbstractString,Nothing}
    observer::Union{AbstractString,Nothing}
    license::Union{AbstractString,Nothing}
end

function format_date(o, d)
    t = get(o, d, nothing)
    if t == nothing
        return nothing
    else
        DateTime(t[1:19])
    end
end

"""
**Generates an occurrence from the JSON response of GBIF**
"""
function GBIFRecord(o::Dict{String, Any})
    # Prepare the taxon object
    levels = ["kingdom", "phylum", "class", "order", "family", "genus", "species"]
    r = Dict{Any,Any}()
    for l in levels
        if haskey(o, l)
            r[l] = Pair(o[l], o[l*"Key"])
        else
            r[l] = nothing
        end
    end

    this_name = o["genericName"]
    if get(o, "specificEpithet", nothing) !== nothing
        this_name *= " "*get(o, "specificEpithet", nothing)
    end

    this_record_taxon = GBIFTaxon(
        this_name,
        o["scientificName"],
        :ACCEPTED,
        :EXACT,
        r["kingdom"],
        r["phylum"],
        r["class"],
        r["order"],
        r["family"],
        r["genus"],
        r["species"],
        100,
        false
    )

    return GBIFRecord(
    o["key"],
    o["datasetKey"],
    get(o, "datasetName", nothing),
    get(o, "publishingOrgKey", nothing),
    get(o, "publishingCountry", nothing),
    get(o, "institutionCode", nothing),
    get(o, "protocol", nothing),
    format_date(o, "lastCrawled"),
    format_date(o, "lastParsed"),
    format_date(o, "modified"),
    format_date(o, "lastInterpreted"),
    get(o, "countryCode", nothing),
    get(o, "country", nothing),
    Symbol(o["basisOfRecord"]),
    get(o, "individualCount", nothing),
    get(o, "decimalLatitude", nothing),
    get(o, "decimalLongitude", nothing),
    get(o, "precision", nothing),
    get(o, "coordinateUncertaintyInMeters", nothing),
    get(o, "geodeticDatum", nothing),
    format_date(o, "eventDate"),
    Symbol.(o["issues"]),
    get(o, "taxonKey", nothing),
    get(o, "taxonRank", nothing),
    this_record_taxon,
    get(o, "genericName", nothing),
    get(o, "specificEpithet", nothing),
    get(o, "vernacularName", nothing),
    get(o, "scientificName", nothing),
    get(o, "recordedBy", nothing),
    get(o, "license", nothing)
    )
end

"""
**List of occurrences and metadata***
"""
mutable struct GBIFRecords
    offset::Integer
    count::Integer
    query::Union{Dict{String,Any},Nothing}
    occurrences::Vector{GBIFRecord}
    show::Vector{Bool}
end
