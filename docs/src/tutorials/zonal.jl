# # Zonal statistics

# In this tutorial, we will

using SpeciesDistributionToolkit
using Statistics
using CairoMakie
CairoMakie.activate!(; type = "png", px_per_unit = 2) #hide

#-

spatial_extent = (left = 165.739746, bottom = -47.587547, right = 180.812988, top = -33.649514)

#-

dataprovider = RasterData(CHELSA2, BioClim)

# precipitation of coldest quarter

layer = SDMLayer(dataprovider; layer = "BIO19", spatial_extent...)

#-

mask!(layer, SpeciesDistributionToolkit.gadm("NZL"))
layer = trim(layer)

#-

# fig-trimmed-layer
heatmap(layer; axis=(; aspect=DataAspect()))
current_figure() #hide

#-

districts = SpeciesDistributionToolkit.gadm("NZL", 2);

# We can start looking at how these map onto the landscape:

# fig-districts
heatmap(zone(layer, districts); colormap=:hokusai, axis=(; aspect=DataAspect()))
current_figure() #hide

# The layer resulting from the `zone` operation has integer values, and the
# values correspond to the polygon to which each pixel belongs. Note that the
# pixels that are not within a polygon are turned off.

z = mosaic(median, layer, districts)
nodata!(z, 0.0)

#-

# fig-zone-index
heatmap(z; axis=(; aspect=DataAspect()))
current_figure() #hide

#-

districtnames = SpeciesDistributionToolkit.gadmlist("NZL", 2)
districtnames[1:10]

#- 

top5 = first.(sort(byzone(median, layer, districts, districtnames); by=(x) -> x.second, rev=true)[1:5])

#-

# fig-highlight-areas
f, ax, plt = heatmap(layer; axis=(; aspect=DataAspect()), colormap=[:lightgrey, :black])
[lines!(ax, districts[i], label=districtnames[i], linewidth=3) for i in indexin(top5, districtnames)]
axislegend(position=(0, 0.7), nbanks=1)
hidedecorations!(ax) #hide
hidespines!(ax) #hide
current_figure() #hide

