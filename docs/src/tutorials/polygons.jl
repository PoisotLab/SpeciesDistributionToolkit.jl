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

# Thanks to the good people in the French Open Street Map community, it is very
# simple to query a `.geojson` file for any OSM identifier. In our case, we will
# download the polygons that describes the state of Vermont and New Hampshire:

VT = GeoJSON.read(Downloads.download("http://polygons.openstreetmap.fr/get_geojson.py?id=60759", tempname()))[1][1];
NH = GeoJSON.read(Downloads.download("http://polygons.openstreetmap.fr/get_geojson.py?id=67213", tempname()))[1][1];

# The next step is to get a layer, and so we will download the data about
# deciduous broadleaf trees from [EarthEnv](/datasets/EarthEnv#landcover):

bbox = (; left = -73.7, right = -70., bottom = 42.5, top = 45.5)
provider = RasterData(EarthEnv, LandCover)
layer = SDMLayer(provider; layer = "Deciduous Broadleaf Trees", bbox...)

# There are a few ways to interact with a polygon. The first thing we can try is
# to `hide!` everything that is within the polygon from the original layer:

hide!(layer, NH)
heatmap(layer; colormap = [:lightgrey, :black], axis = (; aspect = DataAspect()))

#-

hide!(layer, VT)
heatmap(layer; colormap = [:lightgrey, :black], axis = (; aspect = DataAspect()))

# ::: details A note about borders...
# 
# Figuring out whether a point is inside a polygon is fairly easy as long as the
# point is not exactly on the border of the polygon. To help decide what to do
# in this situation, all the methods that deal with a polygon accept a keyword
# argument, `strict`, to decide whether points on the polygon should be included
# in the operation. The default value of `strict` is `false`. 
# 
# :::

# The opposite operation to `hide!` is `reveal!`, which will show the cells that
# are inside the polygon. This is the inverse operation from `hide!`, so we can
# use this to return to the original layer.

reveal!(layer, NH)
heatmap(layer; colormap = [:lightgrey, :black], axis = (; aspect = DataAspect()))

#-

reveal!(layer, VT)
heatmap(layer; colormap = [:lightgrey, :black], axis = (; aspect = DataAspect()))

# The final operation (and arguably the one we care about the most) is `mask!`,
# which will turn off every pixel that is not within the polygon:

mask!(layer, VT)
heatmap(layer; colormap = [:lightgrey, :black], axis = (; aspect = DataAspect()))

# The `mask!` function has a *non-mutating* version for GBIF records. To show 

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

# ::: details Why is the mask for occurrences non-mutating?
# 
# Simply put: the `GBIFRecords` object stores information about the query, and
# we are applying operations that are unrelated to the query itself. For this
# reason, the mask function will take an occurrences query as input, but return
# an array of occurrences. For most methods in the package, however, these two
# objects are equivalent. 
# 
# :::

# Finally, we can scatter these occurrences (after masking) on the layer:

scatter!(mask(presences, VT), color=:orange, markersize=3)
current_figure() #hide

# Note that we can also use polygons to index layers:

layer = SDMLayer(provider; layer = "Urban/Built-up", bbox...)
layer[VT] |> extrema
