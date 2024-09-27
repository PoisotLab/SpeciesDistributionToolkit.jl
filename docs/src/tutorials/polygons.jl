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

# We provide a very lightweight wrapper around the
# [GADM](https://gadm.org/index.html) database, which will return data as
# ready-to-use GeoJSON files. For example, we can get the borders of
# Switzerland, as featured in [the excellent tutorial on SDMs by Damaris
# Zurell](https://damariszurell.github.io/SDM-Intro/).

CHE = SpeciesDistributionToolkit.gadm("CHE")

# ::: details More about GADM
# 
# The only other function to interact with GADM is `gadmlist`, which takes either
# a series of places, as in
#
SpeciesDistributionToolkit.gadmlist("FRA", "Bretagne")
# 
# or a level, to provide a list of places within a three-letter coded area at a
# specific depth:
# 
SpeciesDistributionToolkit.gadmlist("FRA", 3)[1:3]
# 
# :::

# The next step is to get a layer, and so we will download the data about
# deciduous broadleaf trees from [EarthEnv](/datasets/EarthEnv#landcover):

provider = RasterData(EarthEnv, LandCover)
layer = SDMLayer(
    provider;
    layer = "Deciduous Broadleaf Trees",
    left = 0.0,
    right = 20.0,
    bottom = 35.0,
    top = 55.0,
)

# We can check that this polygon is larger than the area we want:

# fig-whole-region
heatmap(layer; colormap = :navia, axis = (; aspect = DataAspect()))
current_figure() #hide

# We can now mask this layer according to the polygon:

mask!(layer, CHE)

# fig-region-masked
heatmap(layer; colormap = :navia, axis = (; aspect = DataAspect()))
current_figure() #hide

# This is a much larger layer than we need! For this reason, we will trim it so that the empty areas are removed:

# fig-region-trimmed
heatmap(trim(layer); colormap = :navia, axis = (; aspect = DataAspect()))
current_figure() #hide

# Let's now get some occurrences in the area defined by the layer boundingbox,
# while specifying the dataset key for the [eBird Observation
# Dataset](https://www.gbif.org/dataset/4fa7b334-ce0d-4e88-aaae-2e0c138d049e):

ouzel = taxon("Turdus torquatus")
presences = occurrences(
    ouzel,
    trim(layer),
    "occurrenceStatus" => "PRESENT",
    "limit" => 300,
    "datasetKey" => "4fa7b334-ce0d-4e88-aaae-2e0c138d049e",
)

# ::: details Occurrences from a layer
# 
# The `GBIF.occurrences` method can accept a layer as its second argument, to
# limit to the occurrence of a species within the bounding box of this layer. If
# a layer is used as the sole argument, all occurrences in the bounding box are
# queried.
# 
# :::

while length(presences) < count(presences)
    occurrences!(presences)
end

# We can plot the layer and all occurrences:

# fig-all-occurrences
heatmap(trim(layer); colormap = :navia, axis = (; aspect = DataAspect()))
scatter!(presences; color = :orange, markersize = 4)
current_figure() #hide

# Some of these occurrences are outside of the masked region in the layer. For
# this reason, we will use the *non-mutating* `mask` method on the GBIF records:

# fig-trimmed-occurrences
heatmap(trim(layer); colormap = :navia, axis = (; aspect = DataAspect()))
scatter!(mask(presences, CHE); color = :orange, markersize = 4)
current_figure() #hide

# ::: details A note about vectors of occurrences
# 
# The reason why `mask` called on a GBIF result is not mutating the result is
# that GBIF results also store the query that was used. For this reason, it
# makes little sense to modify this object. The non-mutating `mask` returns a
# vector of GBIF records, which for most purposes can be used in-place of the
# result.
# 
# :::

#-
