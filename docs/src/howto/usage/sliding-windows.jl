# # Sliding windows

using SpeciesDistributionToolkit
using CairoMakie
CairoMakie.activate!(; type = "png", px_per_unit = 3) #hide
import Statistics

# Get some data

region = getpolygon(PolygonData(NaturalEarth, Countries))["Cuba"]

# boundingbox

extent = SpeciesDistributionToolkit.boundingbox(region)

# layers

temperature = SDMLayer(RasterData(CHELSA2, AverageTemperature); extent...)
mask!(temperature, region)

# see data

heatmap(temperature)

# standard deviation within a 5km radius

# note that this is a long operation because it needs to be done for every pixel
# in the layer

# std_5km = slidingwindow(Statistics.std, temperature; radius=5.0)

# ## Related documentation

# ```@meta
# CollapsedDocStrings = true
# ```

# ```@docs; canonical=false
# slidingwindow
# slidingwindow!
# ```
