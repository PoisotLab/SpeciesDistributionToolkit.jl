module SpeciesDistributionToolkit

using TestItems

using MakieCore
import StatsBase

# We make ample use of re-export
using Reexport

# Expose the components
@reexport using SimpleSDMDatasets
@reexport using GBIF
@reexport using SimpleSDMLayers
@reexport using Fauxcurrences
@reexport using Phylopic

import Distances
const _distance_function = Fauxcurrences._distancefunction

import PolygonOps

# Functions to get latitudes/longitudes
include("latlon.jl")
export latitudes, longitudes

# SimpleSDMLayers to wrap everything together
include("integrations/datasets_layers.jl")

# GBIF to get species occurrence data
include("integrations/gbif_layers.jl")
# export clip

# GBIF and Phylopic integration
include("integrations/gbif_phylopic.jl")

# Plotting
include("integrations/makie.jl")

# Functions for pseudo-absence generation
include("pseudoabsences.jl")
export WithinRadius, SurfaceRangeEnvelope, RandomSelection, DistanceToEvent
export pseudoabsencemask, backgroundpoints

# Functions to deal with polygons
include("polygons.jl")
export hide!
export reveal!

end # module SpeciesDistributionToolkit
