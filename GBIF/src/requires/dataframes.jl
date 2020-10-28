@info "Loading DataFrames support for GBIF.jl"

format_gbif_entity(t::Missing) = missing
format_gbif_entity(t::Pair{String,Int64}) = t.first

import .DataFrames: DataFrame

function DataFrames.DataFrame(records::GBIFRecords)
  output = DataFrame(
    key = Int64[],
    name = Union{Missing,AbstractString}[],
    dataset = Union{Missing,AbstractString}[],
    published_in = Union{Missing, AbstractString}[],
    observed_in = Union{Missing, AbstractString}[],
    latitude = Union{Missing, AbstractFloat}[],
    longitude = Union{Missing, AbstractFloat}[],
    date = Union{Missing, DateTime}[],
    rank = Union{Missing, AbstractString}[],
    observer = Union{Missing, AbstractString}[],
    license = Union{Missing, AbstractString}[],
    kingdom = Union{Missing,String}[],
    phylum = Union{Missing,String}[],
    class = Union{Missing,String}[],
    order = Union{Missing,String}[],
    family = Union{Missing,String}[],
    genus = Union{Missing,String}[],
    species = Union{Missing,String}[]
  )
  for occ in records
    push!(
      output,
      (
        occ.key, occ.taxon.name, occ.dataset, occ.publishingCountry,
        occ.countryCode, occ.latitude, occ.longitude,
        occ.date, occ.rank, occ.observer, occ.license,
        format_gbif_entity(occ.taxon.kingdom),
        format_gbif_entity(occ.taxon.phylum),
        format_gbif_entity(occ.taxon.class),
        format_gbif_entity(occ.taxon.order),
        format_gbif_entity(occ.taxon.family),
        format_gbif_entity(occ.taxon.genus),
        format_gbif_entity(occ.taxon.species)
      )
    )
  end
  return output
end
