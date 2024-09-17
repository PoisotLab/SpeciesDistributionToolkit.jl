# # Zonal statistics

# In this tutorial, we will

using SpeciesDistributionToolkit
using Statistics
using CairoMakie
CairoMakie.activate!(; type = "png", px_per_unit = 3.0) #hide

# -

spatial_extent = (left = -7.0, bottom = 46.0, right = 0.8, top = 50.0)

#-

dataprovider = RasterData(CHELSA2, BioClim)

#-

layer = SDMLayer(dataprovider; layer = "BIO12", spatial_extent...)

#-

mask!(layer, SpeciesDistributionToolkit.gadm("FRA", "Bretagne"))
layer = trim(layer)
heatmap(layer; axis=(; aspect=DataAspect()))

#-

polygons = SpeciesDistributionToolkit.gadm("FRA", 4, "Bretagne")

# -

z = mosaic(median, layer, polygons)
nodata!(z, 0.0)

#-

heatmap(z; axis=(; aspect=DataAspect()))