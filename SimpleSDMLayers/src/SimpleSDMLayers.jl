module SimpleSDMLayers

using Distances
using Statistics
using GeometryBasics
export Point, Polygon
using PolygonOps
using StatsBase
using Tables

# Basic types for the package
include("lib/types.jl")
export SimpleSDMLayer, SimpleSDMResponse, SimpleSDMPredictor
export RasterCell # eltype for the layers, very useful to build table interface later

# Main functions to match coordinates
include("lib/coordinateconversion.jl")

# Implements a series of interfaces (AbstractArray, iteration, and indexing)
include("interfaces/common.jl")
include("interfaces/iteration.jl")

include("interfaces/indexing.jl")
include("interfaces/broadcast.jl")

# Additional overloads
include("lib/overloads.jl")

# Raster clipping
include("lib/clip.jl")
export clip

include("lib/generated.jl")

include("lib/basics.jl")
export latitudes, longitudes, boundingbox, grid, cellsize

include("operations/coarsen.jl")
include("operations/sliding.jl")
include("operations/mask.jl")
include("operations/rescale.jl")
include("operations/mosaic.jl")
include("operations/tiling.jl")
export coarsen, slidingwindow, mask, rescale!, rescale, mosaic, tile, tile!, stitch

end # module
