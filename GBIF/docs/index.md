# GBIF.jl introduction

~~~ julia
using GBIF

# Single occurrence
GBIF.occurrence("1425221362")

# Search occurrences (no parameters)
GBIF.occurrences()

# Search occurrences (with parameters)
gimme_some_wolves = Dict("scientificName" => "Canis lupus", "year" => "2003", "hasCoordinate" => true, "limit" => 50)
wolves_2003 = GBIF.occurrences(gimme_some_wolves)

@assert length(wolves_2003.occurrences) == 50

next!(wolves_2003)
@assert length(wolves_2003.occurrences) == 100

wolves_2003.query["limit"] = 100
next!(wolves_2003)
@assert length(wolves_2003.occurrences) == 200
~~~
