"""
**Represents an occurrence in the GBIF format**

This is currently a subset of all the fields. This `struct` is *not* mutable --
this ensures that the objects returned from the GBIF database are never modified
by the user.
"""
struct GBIFRecord
    key::Integer
    datasetKey::String
    dataset::Union{Missing, String}
    publishingOrgKey::Union{Missing, AbstractString}
    publishingCountry::Union{Missing, AbstractString}
    institutionCode::Union{Missing, AbstractString}
    protocol::Union{Missing, AbstractString}
    crawled::Union{Missing, DateTime}
    parsed::Union{Missing, DateTime}
    modified::Union{Missing, DateTime}
    interpreted::Union{Missing, DateTime}
    countryCode::Union{Missing, AbstractString}
    country::Union{Missing, AbstractString}
    basisOfRecord::Symbol
    individualCount::Union{Missing, Integer}
    latitude::Union{Missing, AbstractFloat}
    longitude::Union{Missing, AbstractFloat}
    precision::Union{Missing, AbstractFloat}
    uncertainty::Union{Missing, AbstractFloat}
    geodetic::Union{Missing, AbstractString}
    date::Union{Missing, DateTime}
    issues::Array{Symbol,1}
    taxonKey::Union{Missing, Integer}
    rank::Union{Missing, String}
    taxon::GBIFTaxon
    generic::Union{Missing, AbstractString}
    epithet::Union{Missing, AbstractString}
    vernacular::Union{Missing, AbstractString}
    scientific::Union{Missing, AbstractString}
    observer::Union{Missing, AbstractString}
    license::Union{Missing, AbstractString}
end

"""
**Internal function to format dates in records**
"""
function format_date(o, d)
    t = get(o, d, missing)
    if t === nothing || ismissing(t)
        return missing
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
            r[l] = missing
        end
    end

    this_name = o["genericName"]
    if !ismissing(get(o, "specificEpithet", missing))
        this_name *= " "*get(o, "specificEpithet", missing)
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
    get(o, "datasetName", missing),
    get(o, "publishingOrgKey", missing),
    get(o, "publishingCountry", missing),
    get(o, "institutionCode", missing),
    get(o, "protocol", missing),
    format_date(o, "lastCrawled"),
    format_date(o, "lastParsed"),
    format_date(o, "modified"),
    format_date(o, "lastInterpreted"),
    get(o, "countryCode", missing),
    get(o, "country", missing),
    Symbol(o["basisOfRecord"]),
    get(o, "individualCount", missing),
    get(o, "decimalLatitude", missing),
    get(o, "decimalLongitude", missing),
    get(o, "precision", missing),
    get(o, "coordinateUncertaintyInMeters", missing),
    get(o, "geodeticDatum", missing),
    format_date(o, "eventDate"),
    Symbol.(o["issues"]),
    get(o, "taxonKey", missing),
    get(o, "taxonRank", missing),
    this_record_taxon,
    get(o, "genericName", missing),
    get(o, "specificEpithet", missing),
    get(o, "vernacularName", missing),
    get(o, "scientificName", missing),
    get(o, "recordedBy", missing),
    get(o, "license", missing)
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
