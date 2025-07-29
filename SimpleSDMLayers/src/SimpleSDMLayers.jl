"""
### SimpleSDMLayers

`SimpleSDMLayers` is a package to provide easy to use, georeferenced representations
of raster data to assist with the construction of species distribution models.
The package provides a *single* type, `SDMLayer`, which behaves like an array,
an iterable object, and a table. It furthers implements core operations on
rasters.
"""
module SimpleSDMLayers

using LinearAlgebra
using Statistics
using TestItems

import ArchGDAL
import Proj
import Tables
import Distances
import StatsBase

# Definition of the SDMLayer type and its constructors
include("types.jl")
export SDMLayer
export nodata!, nodata
export eastings, northings

# Functions for IO
include("io/read_write.jl")
include("io/geotiff.jl")

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

# Caorsen
include("coarsen.jl")
export coarsen

# Interpolation
include("interpolation.jl")
export interpolate, interpolate!

# Burn values in layers
include("burnin.jl")
export burnin, burnin!

# Cell area
include("cellarea.jl")
export cellarea

# Reclassify
include("reclassify.jl")
export reclassify

# Quantile transfer
include("quantiletransfer.jl")
export quantiletransfer, quantiletransfer!

# Shift and rotate
include("shift-and-rotate/rotations.jl")
include("shift-and-rotate/shift-and-rotate.jl")
export roll, pitch, yaw
export shiftlatitudes, shiftlongitudes, localrotation
export shiftandrotate
export find_rotations

end # module
