"""
**Represents an occurrence in the GBIF format**

This is currently a subset of all the fields. This `struct` is *not* mutable --
this ensures that the objects returned from the GBIF database are never modified
by the user.

The `taxon` field is a `GBIFTaxon` object, and can therefore be manipulated as
any other `GBIFTaxon`.
"""
struct GBIFRecord
    key::Int64
    datasetKey::AbstractString
    dataset::Union{Missing, AbstractString}
    publishingOrgKey::Union{Missing, AbstractString}
    publishingCountry::Union{Missing, AbstractString}
    institutionCode::Union{Missing, AbstractString}
    protocol::Union{Missing, AbstractString}
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
    identified::Union{Missing, DateTime}
    issues::Vector{Symbol}
    taxonKey::Union{Missing, Integer}
    rank::Union{Missing, AbstractString}
    taxon::GBIFTaxon
    generic::Union{Missing, AbstractString}
    epithet::Union{Missing, AbstractString}
    vernacular::Union{Missing, AbstractString}
    scientific::Union{Missing, AbstractString}
    observer::Union{Missing, AbstractString}
    license::Union{Missing, AbstractString}
    presence::Bool
end

"""
**Internal function to format dates in records**
"""
function format_date(o, d)
    t = get(o, d, missing)
    if t === nothing || ismissing(t)
        return missing
    else
        try
            return DateTime(t[1:19])
        catch
            return missing
        end
    end
end

"""
**Generates an occurrence from the JSON response of GBIF**
"""
function GBIFRecord(o::Dict{String, Any})
    # Prepare the taxon object
    levels = ["kingdom", "phylum", "class", "order", "family", "genus", "species"]
    r = Dict{Any, Any}()
    for l in levels
        if haskey(o, l)
            r[l] = Pair(o[l], o[l * "Key"])
        else
            r[l] = missing
        end
    end

    # The name of the taxon is the generic name + specific epithet, but if the
    # generic name is asbent, this defaults to the scientificName.
    if !ismissing(get(o, "genericName", missing))
        this_name = o["genericName"]
        if !ismissing(get(o, "specificEpithet", missing))
            this_name *= " " * get(o, "specificEpithet", missing)
        end
    else
        this_name = o["scientificName"]
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
        false,
    )

    formatted_record = GBIFRecord(
        o["key"],
        o["datasetKey"],
        get(o, "datasetName", missing),
        get(o, "publishingOrgKey", missing),
        get(o, "publishingCountry", missing),
        get(o, "institutionCode", missing),
        get(o, "protocol", missing),
        get(o, "countryCode", missing),
        get(o, "country", missing),
        Symbol(get(o, "basisOfRecord", "UNKNOWN")),
        get(o, "individualCount", missing),
        get(o, "decimalLatitude", missing),
        get(o, "decimalLongitude", missing),
        get(o, "precision", missing),
        get(o, "coordinateUncertaintyInMeters", missing),
        get(o, "geodeticDatum", missing),
        format_date(o, "eventDate"),
        format_date(o, "dateIdentified"),
        Symbol.(o["issues"]),
        get(o, "taxonKey", missing),
        get(o, "taxonRank", missing),
        this_record_taxon,
        get(o, "genericName", missing),
        get(o, "specificEpithet", missing),
        get(o, "vernacularName", missing),
        get(o, "scientificName", missing),
        get(o, "recordedBy", missing),
        get(o, "license", missing),
        get(o, "occurrenceStatus", "PRESENT") == "PRESENT",
    )
    return formatted_record
end

"""
**List of occurrences and metadata**

This type has actually very few information: the `query` field stores the query
parameters. This type is mutable and fully iterable.

The `occurrences` field is pre-allocated, meaning that it will contain `#undef`
elements up to the total number of hits on GBIF. When iterating, this is taken
care of automatically, but this needs to be accounted for if writing code that
accesses this field directly.
"""
mutable struct GBIFRecords
    query::Union{Vector{Pair}, Nothing}
    occurrences::Vector{GBIFRecord}
end
