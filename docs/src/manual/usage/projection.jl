# # Interpolating to a new projection

using SpeciesDistributionToolkit
using CairoMakie

# The `interpolate` method can be used to project data into another coordinate
# system. For example, we can get bird richness data for metropolitan France and
# Corsica, in the Eckert IV projection:

spatial_extent = (; left = -4.87, right = 9.63, bottom = 41.31, top = 51.14)
dataprovider = RasterData(BiodiversityMapping, BirdRichness)
layer = SDMLayer(dataprovider; layer = "Birds", spatial_extent...)

# The projection of a layer can be seen with:

projection(layer)

# ::: info Re-projecting other objects 
# 
# Objects that are not layers can be projected for data visualization with
# `reproject` -- there is a [manual entry](/manual/dataviz/projections) for this
# use-case.
#
# :::

# We can check out the original data:

#figure initial
fig, ax, hm = heatmap(
    layer;
    colormap = :navia,
    figure = (; size = (800, 400)),
    axis = (; aspect = DataAspect()),
)
Colorbar(fig[:, end + 1], hm)
current_figure() #hide

# And project them to the more locally appropriate [EPSG:27574](https://epsg.io/27574):

ws = interpolate(layer; dest = "EPSG:27574")

# Note that we are specifying the projection as an EPSG code, but the package is
# agnostic as to the way to specify it. Using a WKT or a PROJ4 string would work
# just as well. This is because, internally, the projection string will be
# parsed and converted to an appropriate representation. This is generally the
# PROJ4 string for coordinates projection, and the WKT for export.

# By default, this produces a layer with the same dimension as the input, and
# uses bilinear interpolation:

#figure interpolated
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

# We can also pass a custom PROJ string if we want. For example, we will use an
# orthoraphic projection, centered around a point within the layer:

ws2 = interpolate(layer; dest = "+proj=ortho +lon_0=1.0859 +lat_0=45.6429")

# We can plot the outcome to see that it was correctly applied:

#figure orthoprojection
fig, ax, hm = heatmap(
    ws2;
    colormap = :navia,
    figure = (; size = (800, 400)),
    axis = (; aspect = DataAspect()),
)
Colorbar(fig[:, end + 1], hm)
current_figure() #hide

# ```@meta
# CollapsedDocStrings = true
# ```

# ## Related documentation
#
# ```@docs; canonical=false
# SpeciesDistributionToolkit.interpolate
# SpeciesDistributionToolkit.interpolate!
# projection
# reproject
# ```
