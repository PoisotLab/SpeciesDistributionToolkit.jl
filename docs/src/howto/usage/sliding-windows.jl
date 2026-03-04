# # Sliding windows

using SpeciesDistributionToolkit
using CairoMakie
CairoMakie.activate!(; type = "png", px_per_unit = 3) #hide
import Statistics

# Sliding windows analyses allow to aggregate data within a set distance from a
# pixel (expressed as a radius, in kilometers) and return this information in a
# new raster with the same dimension. We will illustrate this by getting the
# average temperature in january for the country of Uruguay, and identifying
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

#figure data-temp
f = Figure()
ax = Axis(f[1, 1]; aspect = DataAspect())
hm = heatmap!(ax, temperature; colormap = :magma)
lines!(ax, region; color = :grey10)
hidedecorations!(ax)
hidespines!(ax)
Colorbar(f[1, 2], hm; label = "Average temperature in jan. (°C)")
current_figure() #hide

# We will start by reporting the average temperature within a 12 km radius from
# any given point:

avg_12km = slidingwindow(Statistics.mean, temperature; radius = 12.0)

# The radius is always expressed in kilometers. Once the operation is finished,
# we can look at the results:

#figure avg-12k
f = Figure()
ax = Axis(f[1, 1]; aspect = DataAspect())
hm = heatmap!(ax, temperature; colormap = :magma, colorrange = extrema(temperature))
lines!(ax, region; color = :grey10)
hidedecorations!(ax)
hidespines!(ax)
Colorbar(f[1, 2], hm; label = "Average temperature in jan. (°C)")
current_figure() #hide

# It is important to note that the speed of the function decreases with the
# radius of the problem. We can illustrate this with a simple (and not very
# robust) benchmark:

#figure sliding-benchmark
R = LinRange(1.0, 20.0, 12)
T = zeros(length(R))
destination = copy(temperature)
for (i,r) in enumerate(R)
    started = time()
    slidingwindow!(destination, Statistics.mean, temperature; radius=r)
    finished = time()
    T[i] = finished-started
end
f = Figure()
ax = Axis(f[1, 1]; xlabel="Window area (km²)", ylabel="Runtime (s)")
scatter!(ax, π.*R.^2.0, T, color=:white, strokecolor=:black, strokewidth=2)
xlims!(ax, 0, 1500)
ylims!(ax, 0, 30)
tightlimits!(ax)
current_figure() #hide

# To identify coldspots, it would be tempting to repeat this process for the
# standard deviation, and then combine these three layers into a z-score. But
# because of the need to identify neighboring pixels, this would be extremely
# ineffective.

# Instead, we will use the `centervalue` keyword of `slidingwindow`, which
# requires that we use a function with two arguments: the value of the reference
# pixel, and the rest of the values:

zscore(x, v) = (x - Statistics.mean(v)) / Statistics.std(v)

# We can now get the z-score of temperature around the point in a single call:

z_12km = slidingwindow(zscore, temperature; radius = 12.0, centervalue = true)

# This layer can be plotted to show which locations are colder/warmer than their
# surroundings.

#figure z-12k
f = Figure()
ax = Axis(f[1, 1]; aspect = DataAspect())
hm = heatmap!(ax, z_12km; colormap = Reverse(:managua), colorrange = (-1, 1))
lines!(ax, region; color = :grey10)
hidedecorations!(ax)
hidespines!(ax)
Colorbar(f[1, 2], hm; label = "Relative local temperature difference")
current_figure() #hide

# ## Related documentation

# ```@meta
# CollapsedDocStrings = true
# ```

# ```@docs; canonical=false
# slidingwindow
# slidingwindow!
# ```
