
using GBIF


occurrence(1425221362)


fieldnames(Occurrence)


gimme_some_species = Dict("scientificName" => "Mus musculus", "year" => 1999, "hasCoordinate" => true)
sp_set = occurrences(gimme_some_species)


next!(sp_set)
length(sp_set.occurrences)


complete!(sp_set)
length(sp_set.occurrences)

