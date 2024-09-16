# # Working with polygons

using SpeciesDistributionToolkit
using CairoMakie
import GeoJSON
using Statistics
import Downloads
CairoMakie.activate!(; type = "png", px_per_unit = 3.0) #hide

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
# Switzerland, as featured in [Damaris Zurell excellent SDM
# tutorial](https://damariszurell.github.io/SDM-Intro/).

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

provider = RasterData(WorldClim2, Elevation)
layer = SDMLayer(provider; resolution=0.5, left=0.0, right=20.0, bottom=35.0, top=55.0)

# We can check that this polygon is larger than we want:

heatmap(layer; colormap = :navia, axis = (; aspect = DataAspect()))

# We can now mask this layer according to the polygon:

mask!(layer, CHE[1].geometry)
heatmap(layer; colormap = :navia, axis = (; aspect = DataAspect()))

# This is a much larger layer than we need! For this reason, we will trim it so that the empty areas are removed:

heatmap(trim(layer); colormap = :navia, axis = (; aspect = DataAspect()))
