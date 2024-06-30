module SpeciesDistributionToolkit

import ArchGDAL
import GDAL

using TestItems

import Distances
# TODO: call the one from Fauxcurrences when integrated
const _distance_function = Distances.Haversine(6371.0)

using MakieCore

import StatsBase
import OffsetArrays

# We make ample use of re-export
using Reexport

# Expose the components
@reexport using SimpleSDMDatasets
@reexport using GBIF
@reexport using SimpleSDMLayers
@reexport using Fauxcurrences
@reexport using Phylopic

# Functions to get latitudes/longitudes
include("latlon.jl")
export latitudes, longitudes

# SimpleSDMLayers to wrap everything together
include("integrations/datasets_layers.jl")

# GBIF to get species occurrence data
include("integrations/gbif_layers.jl")
# export clip

# GBIF and Phylopic integration
# include("integrations/gbif_phylopic.jl")

# Plotting
include("integrations/makie.jl")

# Functions for IO
include("io/read_write.jl")
include("io/geotiff.jl")
#include("io/ascii.jl")

# Functions for pseudo-absence generation
# include("pseudoabsences.jl")
# export WithinRadius, SurfaceRangeEnvelope, RandomSelection, DistanceToEvent
 #export pseudoabsencemask, backgroundpoints

end # module SpeciesDistributionToolkit
