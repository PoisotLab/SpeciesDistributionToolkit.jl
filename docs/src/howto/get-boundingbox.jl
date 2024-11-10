# # ... get the bounding box for an object?

using SpeciesDistributionToolkit
using CairoMakie
CairoMakie.activate!(; type = "png", px_per_unit = 2) #hide

# The `boundingbox` method accepts most types that `SpeciesDistributionToolkit`
# knows about, and returns a tuple:

occ = occurrences("hasCoordinate" => true, "country" => "BR")
boundingbox(occ)

# We can also specify a padding (in degrees) that is added to the bounding box:

boundingbox(occ; padding=1.0)

# This is useful to restrict the part of a layer that is loaded:

L = SDMLayer(RasterData(EarthEnv, LandCover), layer=2; boundingbox(occ; padding=0.5)...)

# fig-partialload
heatmap(L)
scatter!(occ)
current_figure() #hide

# ```@meta
# CollapsedDocStrings = true
# ```

# ```@docs; canonical=false
# SpeciesDistributionToolkit.boundingbox
# ```
