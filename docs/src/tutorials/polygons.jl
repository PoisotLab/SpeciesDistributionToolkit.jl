# # Working with polygons

using SpeciesDistributionToolkit
import GeoJSON
import Downloads
using CairoMakie
CairoMakie.activate!(; type = "png", px_per_unit = 3.0) #hide

# In this tutorial, we will clip a layer to a polygon (in GeoJSON format), then
# use the same polygon to filter GBIF records.

# Thanks to the good people in the French Open Street Map community, it is very
# simple to query a `.geojson` file for any OSM identifier:

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

#-


species = taxon("Procyon lotor")
query = [
    "hasCoordinate" => true,
    "country" => "US",
    "limit" => 300,
    "occurrenceStatus" => "PRESENT",
    "decimalLatitude" => (bbox.bottom, bbox.top),
    "decimalLongitude" => (bbox.left, bbox.right),
]
presences = occurrences(species, query...)
while length(presences) < count(presences)
    occurrences!(presences)
end

#-

scatter!(mask(presences, VT), color=:orange, markersize=3)
current_figure()