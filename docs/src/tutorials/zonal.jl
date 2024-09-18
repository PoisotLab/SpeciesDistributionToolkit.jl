# # Zonal statistics

# In this tutorial, we will

using SpeciesDistributionToolkit
using Statistics
using CairoMakie
CairoMakie.activate!(; type = "png", px_per_unit = 3.0) #hide

# The good people from Bretagne have a very interesting saying about whom it usually rains on. And 

spatial_extent = (left = -7.0, bottom = 46.0, right = 0.8, top = 50.0)

#-

dataprovider = RasterData(CHELSA2, BioClim)

# precipitation of coldest quarter

layer = SDMLayer(dataprovider; layer = "BIO19", spatial_extent...)

#-

mask!(layer, SpeciesDistributionToolkit.gadm("FRA", "Bretagne"))
layer = trim(layer)
heatmap(layer; axis=(; aspect=DataAspect()))

#-

districts = SpeciesDistributionToolkit.gadm("FRA", 4, "Bretagne")

# We can start looking at how these map onto the landscape:

heatmap(zone(layer, districts); colormap=:autumn, axis=(; aspect=DataAspect()))

# The layer resulting from the `zone` operation has integer values, and the
# values correspond to the polygon to which each pixel belongs. Note that the
# pixels that are not within a polygon are turned off.

z = mosaic(median, layer, districts)
nodata!(z, 0.0)

#-

heatmap(z; axis=(; aspect=DataAspect()))

#-

districtnames = SpeciesDistributionToolkit.gadmlist("FRA", 4, "Bretagne")

#- 

top10 = first.(sort(byzone(median, layer, districts, districtnames); by=(x) -> x.second, rev=true)[1:10])

#-

heatmap(z)
[lines!(districts[i], color=:red) for i in indexin(top10, districtnames)]
current_figure()

