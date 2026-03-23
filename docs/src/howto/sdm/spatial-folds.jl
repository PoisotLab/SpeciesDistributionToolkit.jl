# # Tessellation

# It is possible to generate tessellations (homogenous tilings of a surface)
# from several type of objects.

using SpeciesDistributionToolkit
const SDT = SpeciesDistributionToolkit
using CairoMakie

# We will start by getting the different type of data that can be used to
# generate a tessellation, starting with polygons:

EUR = getpolygon(PolygonData(NaturalEarth, Countries))["Region" => "Europe"]
pol = EUR["Switzerland"]
bb = SDT.boundingbox(pol; padding = 0.5)
EUR = clip(EUR, bb)

# We will also grab some occurrences:

records = OccurrencesInterface.__demodata()

# And we will also get a layer:

layer = SDMLayer(RasterData(CHELSA2, AverageTemperature); bb...)
mask!(layer, pol)

# Finally, we will show how the tessellation can be generated in a
# projection-aware way, so we'll also define a correct projection for this area.

proj = "EPSG:2056"

# ## Generating a tessellation

# The `tessellate` function has method for layers, occurrences (including SDMs),
# and polygons. They all share the same options.

T = tessellate(pol, 20.0)

# This will generate a tessellation where each division of the space has a
# surface that is equivalent to a circle with a radius of 20km. In this case,
# each tile will have a surface that is (in km²) approx.
