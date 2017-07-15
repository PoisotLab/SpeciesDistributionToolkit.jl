type Taxon
end

type Coordinates
  latitude::AbstractFloat
  longitude::AbstractFloat
  precision::AbstractFloat
  datum::AbstractString
end

"""
**Represents an occurrence in the GBIF format**

This is currently a subset of all the fields.
"""
type Occurrence
  key::Integer
  datasetKey::AbstractString
  publishingOrgKey::AbstractString
  publishingCountry::AbstractString
  basisOfRecord::Symbol
  individualCount::Integer
  taxon::Taxon
  coordinates::Coordinates
  date::DateTime
  issues::Array{Symbol,1}
end
