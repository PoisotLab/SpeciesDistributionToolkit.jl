module SpeciesDistributionToolkit

using TestItems

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
import Statistics
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

# Tessellation
include("tessellation/squares.jl")
include("tessellation/hexagons.jl")
include("tessellation/triangles.jl")
include("tessellation/tessellate.jl")
export tessellate
export assignfolds!, spatialfold

include("tessellation/spatialfold.jl")

# Extra functions
include("utilities.jl")
export gainloss, discretize

# Variograms
include("variogram.jl")
export variogram

# Reprojection
include("reproject.jl")
export reproject

# Hatching
include("crosshatch.jl")
export crosshatch, polygonize

# Get the boundingbox tuple
include("boundingbox.jl")
export boundingbox

# Graticule extension
function graticulegrid end
function graticulegrid! end
function graticulebox end
function graticulebox! end
function enlargelimits! end
export graticulebox, graticulebox!, graticulegrid, graticulegrid!, enlargelimits!

# Bivariate extension
function bivariate end
function bivariate! end
function bivariatelegend end
function bivariatelegend! end
StevensRedBlue(::Number) = nothing
StevensBluePurple(::Number) = nothing
StevensBlueGreen(::Number) = nothing
StevensYellowPurple(::Number) = nothing
ArcMapOrangeBlue(::Number) = nothing
export StevensBlueGreen, StevensBluePurple, StevensRedBlue, StevensYellowPurple, ArcMapOrangeBlue
export bivariate, bivariate!, bivariatelegend, bivariatelegend!

# VSUP extension
function vsup end
function vsup! end
function vsuplegend end
function vsuplegend! end
function vsuplegendticks end
export vsup, vsup!, vsuplegend, vsuplegend!, vsuplegendticks

end # module SpeciesDistributionToolkit
