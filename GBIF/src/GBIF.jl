module GBIF

using Requests
using JSON

const gbifurl = "http://api.gbif.org/v1/"

# package code goes here
include("query.jl")

include("types.jl")
export Occurrence, Occurrences

include("occurrence.jl")
export occurrence, occurrences

include("paging.jl")
export next!

end # module
