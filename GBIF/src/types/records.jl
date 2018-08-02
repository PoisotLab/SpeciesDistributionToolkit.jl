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
  kingdomKey::Union{Integer, Nothing}
  phylumKey::Union{Integer, Nothing}
  classKey::Union{Integer, Nothing}
  orderKey::Union{Integer, Nothing}
  familyKey::Union{Integer, Nothing}
  genusKey::Union{Integer, Nothing}
  speciesKey::Union{Integer, Nothing}
  kingdom::Union{AbstractString,Nothing}
  phylum::Union{AbstractString,Nothing}
  class::Union{AbstractString,Nothing}
  order::Union{AbstractString,Nothing}
  family::Union{AbstractString,Nothing}
  genus::Union{AbstractString,Nothing}
  species::Union{AbstractString,Nothing}
  rank::Union{String,Nothing}
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
    o["basisOfRecord"],
    get(o, "individualCount", nothing),
    get(o, "decimalLatitude", nothing),
    get(o, "decimalLongitude", nothing),
    get(o, "precision", nothing),
    get(o, "coordinateUncertaintyInMeters", nothing),
    get(o, "geodeticDatum", nothing),
    format_date(o, "eventDate"),
    o["issues"],
    get(o, "taxonKey", nothing),
    get(o, "kingdomKey", nothing),
    get(o, "phylumKey", nothing),
    get(o, "classKey", nothing),
    get(o, "orderKey", nothing),
    get(o, "familyKey", nothing),
    get(o, "genusKey", nothing),
    get(o, "speciesKey", nothing),
    get(o, "kingdom", nothing),
    get(o, "phylum", nothing),
    get(o, "class", nothing),
    get(o, "order", nothing),
    get(o, "family", nothing),
    get(o, "genus", nothing),
    get(o, "species", nothing),
    get(o, "taxonRank", nothing),
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
  occurrences::SubArray{GBIF.GBIFRecord,1,Array{GBIF.GBIFRecord,1},Tuple{Array{Int64,1}},false} # TODO be explicit on the type
  raw::Array{GBIFRecord, 1}
  show::Array{Bool,1}
end
