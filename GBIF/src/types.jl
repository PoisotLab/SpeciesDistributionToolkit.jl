"""
**Represents an occurrence in the GBIF format**

This is currently a subset of all the fields.
"""
struct Occurrence
  key::Integer
  datasetKey::String
  publishingOrgKey::Union{AbstractString, Void}
  publishingCountry::Union{AbstractString, Void}
  countryCode::Union{AbstractString, Void}
  country::Union{AbstractString, Void}
  basisOfRecord::Symbol
  individualCount::Union{Integer, Void}
  latitude::Union{AbstractFloat, Void}
  longitude::Union{AbstractFloat, Void}
  precision::Union{AbstractFloat, Void}
  uncertainty::Union{AbstractFloat, Void}
  geodetic::Union{AbstractString, Void}
  date::DateTime
  issues::Array{Symbol,1}
  taxonKey::Integer
  kingdomKey::Union{Integer, Void}
  phylumKey::Union{Integer, Void}
  classKey::Union{Integer, Void}
  orderKey::Union{Integer, Void}
  familyKey::Union{Integer, Void}
  genusKey::Union{Integer, Void}
  speciesKey::Union{Integer, Void}
  kingdom::Union{AbstractString, Void}
  phylum::Union{AbstractString, Void}
  class::Union{AbstractString, Void}
  order::Union{AbstractString, Void}
  family::Union{AbstractString, Void}
  genus::Union{AbstractString, Void}
  species::Union{AbstractString, Void}
  rank::Symbol
  name::AbstractString
  generic::Union{AbstractString, Void}
  vernacular::Union{AbstractString, Void}
  observer::Union{AbstractString, Void}
  license::Union{AbstractString, Void}
end

"""
**Generates an occurrence from the JSON response of GBIF**
"""
function Occurrence(o::Dict{String, Any})
  return Occurrence(
    o["key"],
    o["datasetKey"],
    get(o, "publishingOrgKey", nothing),
    get(o, "publishingCountry", nothing),
    get(o, "countryCode", nothing),
    get(o, "country", nothing),
    o["basisOfRecord"],
    get(o, "individualCount", nothing),
    get(o, "decimalLatitude", nothing),
    get(o, "decimalLongitude", nothing),
    get(o, "precision", nothing),
    get(o, "coordinateUncertaintyInMeters", nothing),
    get(o, "geodeticDatum", nothing),
    DateTime(o["eventDate"][1:19]),
    o["issues"],
    o["taxonKey"],
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
    o["taxonRank"],
    o["scientificName"],
    get(o, "genericName", nothing),
    get(o, "vernacularName", nothing),
    get(o, "recordedBy", nothing),
    get(o, "license", nothing)
  )
end

import Base.show

"""
**Show an occurrence**
"""
function show(io::IO, o::Occurrence)
  println(io, "GBIF $(o.key)\t$(o.name)")
end

"""
**...***
"""
mutable struct Occurrences
  offset::Integer
  count::Integer
  query::Union{Dict,Void}
  occurrences::Array{Occurrence, 1}
end

import Base.length, Base.getindex, Base.endof

function length(o::Occurrences)
  length(o.occurrences)
end

function getindex(o::Occurrences, i::Int64)
  o.occurrences[i]
end

function getindex(o::Occurrences, r::UnitRange{Int64})
  o.occurrences[r]
end

function endof(o::Occurrences)
  endof(o.occurrences)
end
