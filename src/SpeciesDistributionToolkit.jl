module SpeciesDistributionToolkit

import ArchGDAL
import GDAL

# We make ample use of re-export
using Reexport

# GBIF to get species occurrence data
@reexport using GBIF

# SimpleSDMLayers to wrap everything together
@reexport using SimpleSDMLayers

# Fauxcurrences
# @rexport using Fauxcurrences

# SimpleSDMDatasets for access to layers
@reexport using SimpleSDMDatasets

# Functions for IO
include("io/geotiff.jl")
include("io/ascii.jl")

# Integrate the datasets to the layers
include("integrations/datasets_layers.jl")

# Integrate GBIF to the layers
include("integrations/gbif_layers.jl")

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
