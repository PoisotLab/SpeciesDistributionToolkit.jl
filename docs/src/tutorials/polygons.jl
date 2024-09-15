# # Working with polygons

using SpeciesDistributionToolkit
import GeoJSON
import Downloads
using CairoMakie
CairoMakie.activate!(; type = "png", px_per_unit = 3.0) #hide

# In this tutorial, we will clip a layer to a polygon (in GeoJSON format), then
# use the same polygon to filter GBIF records.

# We can get a GeoJSON representation of any Open Street Maps features:

VT = GeoJSON.read(Downloads.download("http://polygons.openstreetmap.fr/get_geojson.py?id=60759", tempname()))[1][1]

#-


bbox = (; left = -73.7, right = -71., bottom = 42.5, top = 45.5)
provider = RasterData(EarthEnv, LandCover)
layer = SDMLayer(provider; layer = "Deciduous Broadleaf Trees", bbox...)

#-

hide!(layer, VT)
heatmap(layer; colormap = [:lightgrey, :black], axis = (; aspect = DataAspect()))


#-

reveal!(layer, VT)
heatmap(layer; colormap = [:lightgrey, :black], axis = (; aspect = DataAspect()))

#-

mask!(layer, VT)
heatmap(layer; colormap = [:lightgrey, :black], axis = (; aspect = DataAspect()))