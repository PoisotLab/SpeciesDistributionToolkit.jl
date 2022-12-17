module SpeciesDistributionToolkit

import ArchGDAL
import GDAL

import Distances
# TODO: call the one from Fauxcurrences when integrated
const _distance_function = Distances.Haversine(6371.0)

import StatsBase

# We make ample use of re-export
using Reexport

# Expose the components
@reexport using SimpleSDMDatasets
@reexport using GBIF
@reexport using SimpleSDMLayers
# @rexport using Fauxcurrences

# SimpleSDMLayers to wrap everything together
include("integrations/datasets_layers.jl")

# GBIF to get species occurrence data
include("integrations/gbif_layers.jl")

# Functions for IO
include("io/geotiff.jl")
include("io/ascii.jl")
include("io/read_write.jl")

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
