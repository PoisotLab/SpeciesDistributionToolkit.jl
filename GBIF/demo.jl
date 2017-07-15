include("src/GBIF.jl")
using GBIF

# Single occurrence
GBIF.occurrence("1425221362")

# Search occurrences (no parameters)
GBIF.occurrences()

# Search occurrences (with parameters)
gimme_some_wolves = Dict("scientificName" => "Canis lupus")
GBIF.occurrences(gimme_some_wolves)
