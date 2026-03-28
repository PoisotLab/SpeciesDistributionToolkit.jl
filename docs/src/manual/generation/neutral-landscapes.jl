# # Generating neutral landscapes

# The purpose of this vignette is to demonstrate how we can use the
# `NeutralLandscapes` package to generate random spatial structures.

using SpeciesDistributionToolkit
using CairoMakie

# This functionality is supported through an extension, which is only active
# when the `NeutralLandscapes` package is loaded.

using NeutralLandscapes # [!code highlight]

# ## Generating a neutral layer

# This is simply achieved through an overload of the `SDMLayer` constructor,
# taking a neutral landscape maker, and a size:

L = SDMLayer(DiamondSquare(), (90, 180))

#figure diamondsquare
heatmap(L)
current_figure() #hide

# ## Generating data from an existing layer

# If we have a layer already, it can be used in place of the size argument, in
# which case the mask of the layer is also preserved. This is useful to rapidly
# fill layers that have the same structure with random data. 

# We will illustrate this by only reading it a small part of an existing layer,
# a practice that is fully covered [later on in this
# manual](/manual/usage/read-part-layer/).

T = SDMLayer(RasterData(CHELSA1, BioClim); left=4., right=9., bottom=4., top=9.)
L = SDMLayer(DiamondSquare(0.1), T)

#figure Perlin Noise generated with the same grid as an existing layer
f = Figure()
ax = Axis(f[1,1]; aspect=DataAspect())
heatmap!(ax, L)
current_figure() #hide

# ## Additional arguments

# Finally, the `SDMLayer` constructor, when used this way, accepts keyword
# arguments like the `crs` of the layer, as well as its `x` and `y` fields. This
# is important if you want to ensure that the generated data can be overlaid on
# an actual layer with coordinates and projections.

# Note that by default, the returned layer will be entirely filled. You can mask
# parts of it using `nodata`, or by masking it with a layer containing actual
# data.

# ## Related documentation

# ```@meta
# CollapsedDocStrings = true
# ```

# ```@docs; canonical=false
# nodata
# nodata!
# mask!
# ```
