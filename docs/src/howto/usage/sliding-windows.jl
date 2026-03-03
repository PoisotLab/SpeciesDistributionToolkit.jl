# # Sliding windows

using SpeciesDistributionToolkit
using CairoMakie
CairoMakie.activate!(; type = "png", px_per_unit = 3) #hide
import Statistics

# Sliding windows analyses allow to aggregate data within a set distance from a
# pixel (expressed as a radius, in kilometers) and return this information in a
# new raster with the same dimension. We will illustrate this by getting the
# average temperature in january for the country of Panama, and identifying
# places that are coldspots, _i.e._ colder than their surroundings.

# ::: warning Sliding windows can take time
#
# This analysis requires to identify the pixels around a point that are a set
# distance from the centerpoint. Internally, the function does some half-smart
# geometry to figure out the minimum number of operations, but the time required
# to identify the pixels will scale with the raster resolution _and_ size. The
# calculation will always use available threads.
#
# :::

region = getpolygon(PolygonData(NaturalEarth, Countries); resolution = 10)["Panama"]
extent = SpeciesDistributionToolkit.boundingbox(region)
temperature = SDMLayer(RasterData(CHELSA2, AverageTemperature); extent...)
mask!(temperature, region)

# We can now plot the raw data:

# fig-data-temp
f = Figure()
ax = Axis(f[1, 1]; aspect = DataAspect())
hm = heatmap!(ax, temperature; colormap = :magma)
lines!(ax, region; color = :grey10)
hidedecorations!(ax)
hidespines!(ax)
Colorbar(f[1, 2], hm; label = "Average temperature in jan. (°C)")
current_figure() #hide

# todo

std_5km = slidingwindow(Statistics.std, temperature; radius = 12.0)
avg_5km = slidingwindow(Statistics.mean, temperature; radius = 12.0)

# todo

z = (temperature - avg_5km)/std_5km

# We can now 

# fig-data-sliding
f = Figure()
ax = Axis(f[1, 1]; aspect = DataAspect())
hm = heatmap!(ax, z; colormap = Reverse(:managua), colorrange=(-1, 1))
lines!(ax, region; color = :grey10)
hidedecorations!(ax)
hidespines!(ax)
Colorbar(f[1, 2], hm, label="Relative temperature difference")
current_figure() #hide

# ## Related documentation

# ```@meta
# CollapsedDocStrings = true
# ```

# ```@docs; canonical=false
# slidingwindow
# slidingwindow!
# ```
