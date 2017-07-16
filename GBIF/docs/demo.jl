include("./src/GBIF.jl")
using GBIF

# Single occurrence
occurrence("1425221362")

# Search occurrences (no parameters)
occurrences()

# Search occurrences (with parameters)
gimme_some_species = Dict("scientificName" => "Mus musculus", "year" => 1999, "hasCoordinate" => true, "limit" => 50)
sp_set = occurrences(gimme_some_species)
next!(sp_set)
complete!(sp_set)
