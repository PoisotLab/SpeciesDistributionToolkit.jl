type Occurrence
  key::Integer
  datasetKey::AbstractString
  publishingOrgKey::AbstractString
  publishingCountry::AbstractString
  protocol::Symbol
  lastCrawled::DateTime
  lastParsed::DateTime
  crawlId::Integer
  extensions::Dict{Any}
  basisOfRecord::Symbol
  individualCount::Integer
  kingdomKey::Integer
  phyl
end
