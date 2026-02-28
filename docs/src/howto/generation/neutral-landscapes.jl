# # Creating neutral landscapes

# The purpose of this vignette is to demonstrate how we can use the `NeutralLandscapes`
# package to generate random spatial structures.

# This functionality is supported through an extension, which is only active
# when the `NeutralLandscapes` package is loaded.

using SpeciesDistributionToolkit
using CairoMakie
using NeutralLandscapes # [!code highlight]
CairoMakie.activate!(; type = "png", px_per_unit = 2) #hide

# This is simply achieved through an overload of the `SDMLayer` constructor,
# taking a neutral landscape maker, and a size:

L = SDMLayer(DiamondSquare(), (100, 100))

# fig-diamondsquare
heatmap(L)
current_figure() #hide

# If we have a layer already, it can be used in place of the size argument, in
# which case the mask of the layer is also preserved. This is useful to rapidly
# fill layers with the same structure with random data.

# Finally, the `SDMLayer` constructor, when used this way, accepts keyword
# arguments like the `crs` of the layer, as well as its `x` and `y` fields.