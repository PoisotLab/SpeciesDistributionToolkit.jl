# # ... get the bounding box for an object?

using SpeciesDistributionToolkit
using CairoMakie
CairoMakie.activate!(; type = "png", px_per_unit = 2) #hide

# The `boundingbox` method accepts most types that `SpeciesDistributionToolkit`
# knows about, and returns a tuple:

occ = occurrences("hasCoordinate" => true, "country" => "BR")
SpeciesDistributionToolkit.boundingbox(occ)

# We can also specify a padding (in degrees) that is added to the bounding box:

SpeciesDistributionToolkit.boundingbox(occ; padding = 1.0)

# ::: info Why specify the module?
# 
# Makie and CairoMakie export a method called `boundingbox`. To remove any
# ambiguities when the method is called at a time where any Makie backed is
# loaded, we must specific which module we are calling it from. Note that the
# dispatch signature of the method implemented by SpeciesDistributionToolkit is
# not ambiguous.
# 
# :::

# This is useful to restrict the part of a layer that is loaded:

L = SDMLayer(
    RasterData(EarthEnv, LandCover);
    layer = 1,
    SpeciesDistributionToolkit.boundingbox(occ; padding = 0.5)...,
)

# Note that the bounding box is returned in WGS84, but the function to load any
# part of a layer will handle the conversion.

# fig-partialload
heatmap(L; colormap = :Greys)
scatter!(occ)
current_figure() #hide

# The same method also applies to polygons:

CHE = SpeciesDistributionToolkit.gadm("CHE");
SpeciesDistributionToolkit.boundingbox(CHE; padding = 0.5)

# ```@meta
# CollapsedDocStrings = true
# ```

# ```@docs; canonical=false
# SpeciesDistributionToolkit.boundingbox
# ```
