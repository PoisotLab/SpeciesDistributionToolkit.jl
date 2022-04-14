module Fauxcurrences

import Distances
using GBIF
using SimpleSDMLayers
using LinearAlgebra
using Statistics
using StatsBase

# Earth's radius in km for the Haversine distance
const _earth_radius = 6371.0
const _distancefunction = Distances.Haversine(_earth_radius)

include("coordinates.jl")

include("utilities.jl")

include("bootstrap.jl")

end # module
