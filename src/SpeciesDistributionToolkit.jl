module SpeciesDistributionToolkit

import ArchGDAL
import GDAL

import Distances
# TODO: call the one from Fauxcurrences when integrated
const _distance_function = Distances.Haversine(6371.0)

using MakieCore

import StatsBase

# We make ample use of re-export
using Reexport

# Expose the components
@reexport using SimpleSDMDatasets
@reexport using GBIF
@reexport using SimpleSDMLayers
@reexport using Fauxcurrences

# SimpleSDMLayers to wrap everything together
include("integrations/datasets_layers.jl")

# GBIF to get species occurrence data
include("integrations/gbif_layers.jl")

# Plotting
include("integrations/makie.jl")

# Functions for IO
include("io/geotiff.jl")
include("io/ascii.jl")
include("io/read_write.jl")

# Functions for pseudo-absence generation
include("pseudoabsences.jl")
export WithinRadius, SurfaceRangeEnvelope, RandomSelection
export pseudoabsencemask

end # module SpeciesDistributionToolkit
