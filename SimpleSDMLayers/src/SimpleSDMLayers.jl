"""
### SimpleSDMLayers

`SimpleSDMLayers` is a package to provide easy to use, georeferenced representations
of raster data to assist with the construction of species distribution models.
The package provides a *single* type, `SDMLayer`, which behaves like an array,
an iterable object, and a table. It furthers implements core operations on
rasters.
"""
module SimpleSDMLayers

using TestItems

import ArchGDAL as AG
import Proj
import Tables
import Distances
import StatsBase

# Definition of the SDMLayer type and its constructors
include("types.jl")
export SDMLayer
export nodata!, nodata
export eastings, northings
export IncompatibleProjectionError, DifferentEastWestExtentError, DifferentNorthSouthExtentError

# Functions for IO
include("io/read_write.jl")
include("io/geotiff.jl")

# Include a demo dataset in a non-WGS84 projection
include("demodata.jl")

# Useful overloads for the rest of the package
include("lib/overloads.jl")

# getindex and setindex for layers
include("lib/indexing.jl")

# Iteration interface
include("lib/iterate.jl")

# Tables interface
include("lib/tables.jl")

# Broadcasting interface
include("lib/broadcasting.jl")

# Projection utilities
include("projections.jl")
export projection

# Mask layers
include("operations/mask.jl")
export mask, mask!

# Sliding window
include("operations/slidingwindow.jl")
export slidingwindow, slidingwindow!

# Tiling
include("operations/tiling.jl")
export tiles

# Quantiles, etc
include("operations/quantize.jl")
export rescale!, rescale
export quantize!, quantize

# Mosaic
include("operations/mosaic.jl")
export mosaic

# Caorsen
include("operations/coarsen.jl")
export coarsen

# Interpolation
include("interpolation.jl")
export interpolate, interpolate!

# Burn values in layers
include("operations/burnin.jl")
export burnin, burnin!

# Cell area
include("utilities/cellarea.jl")
export cellarea

# Reclassify
include("operations/reclassify.jl")
export reclassify

end # module
