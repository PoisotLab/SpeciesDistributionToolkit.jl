
using GBIF


occurrence(1425221362)


fieldnames(Occurrence)


gimme_some_species = Dict("scientificName" => "Mus musculus", "year" => 1999, "hasCoordinate" => true)
sp_set = occurrences(gimme_some_species)


next!(sp_set)
length(sp_set)


complete!(sp_set)
length(sp_set)


map(x -> x.country, sp_set) |> unique |> sort


qualitycontrol!(sp_set)
length(sp_set)


function is_from_canada(o::Occurrence)
  get(o, "publishingCountry", nothing) == "CA"
end


restart!(sp_set)
complete!(sp_set)

