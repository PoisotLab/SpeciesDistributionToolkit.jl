# Working with future climate data

using SpeciesDistributionsToolkit
using CairoMakie
using GeoMakie

# Bounding box

spatial_extent = (left = -169.0, right = -50.0, bottom = 24.0, top = 71.0)

# Get some data

dataprovider = RasterData(WorldClim2, BioClim)

# Get some info about what we want

we_want = (resolution = 5.0, layer = "BIO1")

# Get the baseline

baseline = SimpleSDMPredictor(dataprovider; we_want..., spatial_extent...)
