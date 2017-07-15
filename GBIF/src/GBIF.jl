module GBIF

# package code goes here
export const gbifurl = "http://api.gbif.org/v1/"

include("types.jl")
export Occurrence

include("occurrence.jl")
export occurrence



end # module
