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

import Proj
import Tables
import Distances
import StatsBase

# Definition of the SDMLayer type and its constructors
include("types.jl")
export SDMLayer
export nodata!, nodata
export eastings, northings

# Include a demo dataset in a non-WGS84 projection
include("demodata.jl")

# Useful overloads for the rest of the package
include("overloads.jl")

# getindex and setindex for layers
include("indexing.jl")

# Iteration interface
include("iterate.jl")

# Tables interface
include("tables.jl")

# Broadcasting interface
include("broadcasting.jl")

# Mask layers
include("mask.jl")
export mask, mask!

# Sliding window
include("slidingwindow.jl")
export slidingwindow

# Tiling
include("tiling.jl")
export tiles

# Quantiles, etc
include("quantize.jl")
export rescale!, rescale
export quantize!, quantize

# Mosaic
include("mosaic.jl")
export mosaic

end # module
