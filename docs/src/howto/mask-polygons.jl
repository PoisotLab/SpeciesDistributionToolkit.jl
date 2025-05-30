# # Working with polygons

using SpeciesDistributionToolkit
using CairoMakie
import GeoJSON
CairoMakie.activate!(; type = "png", px_per_unit = 2) #hide

# In this tutorial, we will clip a layer to a polygon (in GeoJSON format), then
# use the same polygon to filter GBIF records.

# ::: warning About coordinates
# 
# [GeoJSON](https://geojson.org/) coordinates are expressed in WGS84. For this
# reason, *any* polygon is assumed to be in this CRS, and all operations will be
# done by projecting the layer coordinates to this CRS.
# 
# :::

# We provide a very lightweight tool that uses open street map to turn plain
# text queries into GeoJSON polygons:

POL = getpolygon(PolygonData(OpenStreetMap, Places), place="Yosemite National Park")

# Note that if these polygons are too big, the `simplify` and `simplify!`
# methods (which are not exported) can be used to reduce their complexity.

# The next step is to get a layer, and so we will download the data about
# deciduous broadleaf trees from [EarthEnv](/datasets/EarthEnv#landcover):

provider = RasterData(EarthEnv, LandCover)
layer = SDMLayer(
    provider;
    layer = "Shrubs",
    SpeciesDistributionToolkit.boundingbox(POL; padding=1.0)...
)

# We can check that this polygon is larger than the area we want:

# fig-whole-region
heatmap(layer; colormap = :Greens, axis = (; aspect = DataAspect()))
lines!(POL, color=:red)
current_figure() #hide

# We can now mask this layer according to the polygon. This uses the same
# `mask!` method we use when masking with another layer:

mask!(layer, POL)

# fig-region-masked
heatmap(layer; colormap = :Greens, axis = (; aspect = DataAspect()))
lines!(POL, color=:black)
current_figure() #hide

# This is a much larger layer than we need! For this reason, we will trim it so
# that the empty areas are removed:

# fig-region-trimmed
heatmap(
    trim(layer);
    colormap = :Greens,
    axis = (; aspect = DataAspect()),
)
lines!(POL, color=:black)
current_figure() #hide

# Let's now get some occurrences in the area defined by the layer boundingbox:

sp = taxon("Ursus americanus")
presences = occurrences(
    sp,
    trim(layer),
    "occurrenceStatus" => "PRESENT",
    "limit" => 300,
)
while length(presences) < count(presences)
    occurrences!(presences)
end

# ::: details Occurrences from a layer
# 
# The `GBIF.occurrences` method can accept a layer as its second argument, to
# limit to the occurrence of a species within the bounding box of this layer. If
# a layer is used as the sole argument, all occurrences in the bounding box are
# queried.
# 
# :::

# We can plot the layer and the occurrences we have retrieved so far:

# fig-all-occurrences
heatmap(
    trim(layer);
    colormap = :Greens,
    axis = (; aspect = DataAspect()),
)
scatter!(presences; color = :orange, markersize = 4)
lines!(POL, color=:black)
current_figure() #hide

# Some of these occurrences are outside of the masked region in the layer. For
# this reason, we will use the *non-mutating* `mask` method on the GBIF records:

# fig-trimmed-occurrences
f, ax, plt = heatmap(
    trim(layer);
    colormap = :Greens,
    axis = (; aspect = DataAspect()),
)
scatter!(mask(presences, POL); color = :orange, markersize = 4)
lines!(POL, color=:black)
hidespines!(ax)
hidedecorations!(ax)
current_figure() #hide

# ::: details A note about vectors of occurrences
# 
# The reason why `mask` called on a GBIF result is not mutating the result is
# that GBIF results also store the query that was used. For this reason, it
# makes little sense to modify this object. The non-mutating `mask` returns a
# vector of GBIF records, which for most purposes can be used in-place of the
# result - this is because GBIF records are `AbstractOccurrence`, and vectors of these are
# handled correctly by the package.
# 
# :::

#-
