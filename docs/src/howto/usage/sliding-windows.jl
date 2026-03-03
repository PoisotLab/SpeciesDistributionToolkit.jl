# # Sliding windows

using SpeciesDistributionToolkit
using CairoMakie
CairoMakie.activate!(; type = "png", px_per_unit = 3) #hide
import Statistics

# Get some data

region = getpolygon(PolygonData(NaturalEarth, Countries); resolution=10)["Trinidad and Tobago"]

# boundingbox

extent = SpeciesDistributionToolkit.boundingbox(region)

# layers

temperature = SDMLayer(RasterData(CHELSA2, AverageTemperature); extent...)
mask!(temperature, region)

# see data

# fig-data-temp
f = Figure()
ax = Axis(f[1,1]; aspect=DataAspect())
hm = heatmap!(ax, temperature, colormap=Reverse(:heat))
lines!(ax, region, color=:grey10)
hidedecorations!(ax)
hidespines!(ax)
Colorbar(f[1,2], hm)
current_figure() #hide

# standard deviation within a 5km radius

# note that this is a long operation because it needs to be done for every pixel
# in the layer

std_5km = slidingwindow(Statistics.std, temperature; radius=5.0)

# fig-data-sliding
f = Figure()
ax = Axis(f[1,1]; aspect=DataAspect())
hm = heatmap!(ax, std_5km, colormap=Reverse(:heat))
lines!(ax, region, color=:grey10)
hidedecorations!(ax)
hidespines!(ax)
Colorbar(f[1,2], hm)
current_figure() #hide

# add info about timing and why it's long

# ## Related documentation

# ```@meta
# CollapsedDocStrings = true
# ```

# ```@docs; canonical=false
# slidingwindow
# slidingwindow!
# ```
