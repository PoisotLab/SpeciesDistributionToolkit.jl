# # ... interpolate to a new projection?

using SpeciesDistributionToolkit
using CairoMakie
CairoMakie.activate!(; type = "png", px_per_unit = 2) #hide

# The `interpolate` method can be used to project data into another coordinate
# system. For example, we can get bird richness data for metropolitan France and
# Corsica, in the Eckert IV projection:

spatial_extent = (; left = -4.87, right = 9.63, bottom = 41.31, top = 51.14)
dataprovider = RasterData(BiodiversityMapping, BirdRichness)
layer = SDMLayer(dataprovider; layer = "Birds", spatial_extent...)

# We can check out the original data:

# fig-initial
fig, ax, hm = heatmap(
    layer;
    colormap = :navia,
    figure = (; size = (800, 400)),
    axis = (; aspect = DataAspect()),
)
Colorbar(fig[:, end + 1], hm)
current_figure() #hide

# And project them to the more locally appropriate [EPSG:27574](https://epsg.io/27574):

proj_string = "+proj=lcc +lat_1=42.165 +lat_0=42.165 +lon_0=0 +k_0=0.99994471 +x_0=234.358 +y_0=4185861.369 +ellps=clrk80ign +pm=paris +towgs84=-168,-60,320,0,0,0,0 +units=m +no_defs"
ws = interpolate(layer; dest = proj_string)

# By default, this produces a layer with the same dimension as the input, and
# uses bilinear interpolation:

# fig-interpolated
fig, ax, hm = heatmap(
    ws;
    colormap = :navia,
    figure = (; size = (800, 400)),
    axis = (; aspect = DataAspect()),
)
Colorbar(fig[:, end + 1], hm)
current_figure() #hide

# ::: tip Overwrite a layer
# 
# There is an `interpolate!` method that will perform interpolation on an
# already existing layer. This is useful if you want to rapidly bring data from
# a layer to something compatible with another layer.
#
# :::

# ```@meta
# CollapsedDocStrings = true
# ```
