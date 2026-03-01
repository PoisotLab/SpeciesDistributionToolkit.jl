# # Coarsening layers

using SpeciesDistributionToolkit
using CairoMakie
CairoMakie.activate!(; type = "png", px_per_unit = 3) #hide
import Statistics

# Get some data

region = getpolygon(PolygonData(NaturalEarth, Countries); resolution=10)["Honduras"]

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

# coarsened version

coarse_temperature = coarsen(Statistics.mean, temperature, (3, 7))

# if you want to get rid of pixels whose center now lies outside the polygon, you can mask this layer

mask!(coarse_temperature, region)

#

# fig-data-coarsen
f = Figure()
ax = Axis(f[1,1]; aspect=DataAspect())
hm = heatmap!(ax, coarse_temperature, colormap=Reverse(:heat), colorrange=extrema(temperature))
lines!(ax, region, color=:grey10)
hidedecorations!(ax)
hidespines!(ax)
Colorbar(f[1,2], hm)
current_figure() #hide


# note that this is a long operation because it needs to be done for every pixel
# in the layer

# std_5km = slidingwindow(Statistics.std, temperature; radius=2.0)

# ## Related documentation

# ```@meta
# CollapsedDocStrings = true
# ```

# ```@docs; canonical=false
# slidingwindow
# slidingwindow!
# ```
