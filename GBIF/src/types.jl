"""
**Represents an occurrence in the GBIF format**

This is currently a subset of all the fields.
"""
struct Occurrence
  key::Integer
  datasetKey::String
  publishingOrgKey::String
  publishingCountry::String
  basisOfRecord::Symbol
  individualCount::Union{Integer, Void}
  latitude::Union{AbstractFloat, Void}
  longitude::Union{AbstractFloat, Void}
  precision::Union{AbstractFloat, Void}
  date::DateTime
  issues::Array{Symbol,1}
  taxonKey::Integer
  rank::Symbol
  class::Symbol
  name::AbstractString
end

"""
**Generates an occurrence from the JSON response of GBIF**
"""
function Occurrence(o::Dict{String, Any})
  return Occurrence(
    o["key"],
    o["datasetKey"],
    o["publishingOrgKey"],
    o["publishingCountry"],
    o["basisOfRecord"],
    get(o, "individualCount", nothing),
    get(o, "decimalLatitude", nothing),
    get(o, "decimalLongitude", nothing),
    get(o, "precision", nothing),
    DateTime(o["eventDate"][1:19]),
    o["issues"],
    o["taxonKey"],
    o["taxonRank"],
    o["class"],
    o["scientificName"]
  )
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
