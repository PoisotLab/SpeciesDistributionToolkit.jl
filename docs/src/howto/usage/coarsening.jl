# # Coarsening layers

using SpeciesDistributionToolkit
using CairoMakie
CairoMakie.activate!(; type = "png", px_per_unit = 3) #hide
import Statistics

# We will use the `coarsen` function to decrease the size of a layer while also
# applying an operation on the cells that are merged. Note that this is an
# operation similar to `interpolate`.

region = getpolygon(PolygonData(NaturalEarth, Countries); resolution=10)["Panama"]
extent = SpeciesDistributionToolkit.boundingbox(region)
temperature = SDMLayer(RasterData(CHELSA2, AverageTemperature); extent...)
mask!(temperature, region)

# We will look at the temperature distribution in the raw data.

# fig-data-temp
f = Figure()
ax = Axis(f[1, 1]; aspect = DataAspect())
hm = heatmap!(ax, temperature; colormap = :magma)
lines!(ax, region; color = :grey10)
hidedecorations!(ax)
hidespines!(ax)
Colorbar(f[1, 2], hm; label = "Average temperature in jan. (°C)")
current_figure() #hide

# To reduce the size of the layer, we must include a mask, which gives the size
# of the cells that will be merged to create a new cell. Here, we will merge 16
# cells together.

coarse_temperature = coarsen(Statistics.mean, temperature, (4, 4))

# ::: warning The layer size must be compatible
#
# The number of cells on each size must a multiple of the coarsening window
# size.
#
# :::

# New pixels for which at least of the cells had a value will also have a value
# in the coarsened layer. If this is an issue (for example, look at coastlines
# in the next figure), you can use the `mask!` function after the coarsening.

# We now look at the layer with coarser resolution:

# fig-data-coarsen
f = Figure()
ax = Axis(f[1,1]; aspect=DataAspect())
hm = heatmap!(ax, coarse_temperature, colormap=:magma, colorrange=extrema(temperature))
lines!(ax, region, color=:grey10)
hidedecorations!(ax)
hidespines!(ax)
Colorbar(f[1, 2], hm; label = "Average temperature in jan. (°C)")
current_figure() #hide

# This method is primarily useful when you want to test an approach without
# using the full data resolution.

# ## Related documentation

# ```@meta
# CollapsedDocStrings = true
# ```

# ```@docs; canonical=false
# coarsen
# interpolate
# ```
