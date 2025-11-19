module PseudoAbsences

using OccurrencesInterface
using SimpleSDMLayers
using TestItems
import Distances
import StatsBase

# The main distance function we use
const _earth_radius = 6371.0
const _distancefunction = Distances.Haversine(_earth_radius)

# Types for the background point generation
include("types.jl")
export PseudoAbsenceGenerator
export WithinRadius
export SurfaceRangeEnvelope
export RandomSelection
export DistanceToEvent
export DegreesToEvent

include("pseudoabsencemask.jl")
export pseudoabsencemask

include("backgroundpoints.jl")
export backgroundpoints

end # module PseudoAbsences
