module SpeciesDistributionToolkit

import ArchGDAL
import GDAL

import Distances
# TODO: call the one from Fauxcurrences when integrated
const _distance_function = Distances.Haversine(6371.0)

import Tables
include("tables.jl")

import StatsBase

# We make ample use of re-export
using Reexport

# SimpleSDMDatasets for access to layers
@reexport using SimpleSDMDatasets

# GBIF to get species occurrence data
@reexport using GBIF
include("integrations/gbif_layers.jl")

# SimpleSDMLayers to wrap everything together
@reexport using SimpleSDMLayers
include("integrations/datasets_layers.jl")

# Fauxcurrences
# @rexport using Fauxcurrences

# Functions for IO
include("io/geotiff.jl")
include("io/ascii.jl")
include("io/read_write.jl")

# Integrate the datasets to the layers

# Functions for pseudo-absence generation
include("pseudoabsences.jl")
export WithinRadius, SurfaceRangeEnvelope, RandomSelection
export pseudoabsencemask

# Function to turn a layer into something (Geo)Makie can use
function sprinkle(layer::T) where {T <: SimpleSDMLayer}
    return (
        longitudes(layer),
        latitudes(layer),
        transpose(replace(layer.grid, nothing => NaN)),
    )
end

export sprinkle

end # module SpeciesDistributionToolkit
