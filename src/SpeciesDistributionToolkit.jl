module SpeciesDistributionToolkit

using TestItems

using MakieCore
import StatsBase

# We make ample use of re-export
using Reexport

# Expose the components
@reexport using OccurrencesInterface
@reexport using SimpleSDMDatasets
@reexport using GBIF
@reexport using SimpleSDMLayers
@reexport using SimpleSDMPolygons
@reexport using Fauxcurrences
@reexport using Phylopic
@reexport using SDeMo
@reexport using PseudoAbsences

import Distances
const _distance_function = Fauxcurrences._distancefunction

import GeoJSON
import PolygonOps
import ZipArchives
import Downloads
import HTTP

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

# SDeMo
include("integrations/sdemo.jl")

# OccurrencesInterface
include("integrations/occurrence_interface.jl")

# Functions to deal with polygons
include("polygons/polygons.jl")
include("polygons/zonal.jl")
include("polygons/mosaic.jl")
include("polygons/simplify.jl")
export trim
export zone, byzone

# Boundaries
include("boundaries/gadm.jl")
include("boundaries/osm.jl")

# Extra functions
include("utilities.jl")
export gainloss

# Get the boundingbox tuple
include("boundingbox.jl")
export boundingbox

end # module SpeciesDistributionToolkit
