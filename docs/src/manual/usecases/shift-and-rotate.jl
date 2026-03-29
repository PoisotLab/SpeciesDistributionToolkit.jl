# # Shift and rotate

# In this tutorial, we will apply the "Shift and Rotate" technique
# [ridder2024generating](@cite) to generate realistic maps of predictors to
# provide a null sample for the performance of an SDM. We will also look at the
# quantile mapping function, which ensures that the null sample has the exact
# same distribution of values compared to the original data.

using SpeciesDistributionToolkit
const SDT = SpeciesDistributionToolkit
using CairoMakie

# We will get some occurrences from the butterfly *Aglais caschmirensis* in Pakistan:

pol = getpolygon(PolygonData(NaturalEarth, Countries))["Uganda"]
extent = SDT.boundingbox(pol; padding=5.0)

# And then get some bioclimatic variables:

provider = RasterData(CHELSA2, AverageTemperature)
L = SDMLayer(provider; extent...)

# In order to facilitate the search for rotation parameters, it is a good idea
# to downscale the layer a little

P = interpolate(L, dest=L.crs, newsize=(90, 90))

C = trim(mask(P, pol))

# figure Full area
f = Figure()
ax = Axis(f[1,1]; aspect=DataAspect())
hm = heatmap!(ax, P, colormap=:batlowW)
lines!(ax, pol, color=:black)
Colorbar(f[1,2], hm, label="Average temperature")
current_figure() #hide

# We now find a rotation -- we know the extent we added to the bounding box, so
# we can start by adding this as a constraint

θ = findrotation(C, P; maxiter=100, longitudes=(-5, 5), latitudes=(-5, 5), rotations=(-180, 180))

# The rotation is a shift in latitude and longitude, and then a rotation around
# the axis. It is returned as a tuple, which can be passed to the `roator`,
# which handles the actual rotation.

# We can, for example, shift and rotate the first layer:

Y = shiftandrotate(C, P, θ)

# 

# figure Full area with rotation
f = Figure()
ax = Axis(f[1,1]; aspect=DataAspect())
hm = heatmap!(ax, P, colormap=:batlowW, alpha=0.4)
lines!(ax, pol, color=:black)
scatter!(ax, θ(lonlat(C)), color=:red, markersize=4)
Colorbar(f[1,2], hm, label="Average temperature")
current_figure() #hide

# We can apply this transformation to the original (full resolution) data

X = trim(mask(L, pol))
M = shiftandrotate(X, L, θ)

#figure Rotated target landscape
f = Figure()
ax = Axis(f[1,1]; aspect=DataAspect())
heatmap!(ax, P, colormap=:batlowW, alpha=0.2)
hm = heatmap!(ax, M, colormap=:batlowW, colorrange=extrema(P))
lines!(ax, pol, color=:black)
Colorbar(f[1,2], hm, label="Average temperature")
current_figure() #hide

# compare the distributions

#figure Density of the two layers
f = Figure()
ax = Axis(f[1,1])
density!(ax, M, label="Shift and rotate")
density!(ax, X, label="True values", color=:transparent, strokecolor=:black, linestyle=:dash, strokewidth=1)
axislegend(ax, position=:rt)
ylims!(ax, low=0)
current_figure() #hide

# Now, also ensure that although the spatial structure of this layer has
# changed, it should have the same distribution of values as the original layer.
# This can be done with the quantile transfer function:

X2 = quantiletransfer(M, X)

#figure Density of the two layers after transfer
f = Figure()
ax = Axis(f[1,1])
density!(ax, M, label="Shift and rotate")
density!(ax, X, label="True values", color=:transparent, strokecolor=:black, linestyle=:dash, strokewidth=1)
density!(ax, X2, label="After transfer", color=:transparent, strokecolor=:red, strokewidth=2)
axislegend(ax, position=:rt)
ylims!(ax, low=0)
current_figure() #hide

# now we plot side by side

#figure Side by side
f = Figure()
a1 = Axis(f[1,1]; aspect=DataAspect(), title="True values")
a2 = Axis(f[1,2]; aspect=DataAspect(), title="Shift, rotate, transfer")
hm = heatmap!(a1, X, colormap=:batlowW, colorrange=extrema(X))
heatmap!(a2, X2, colormap=:batlowW, colorrange=extrema(X))
Colorbar(f[1,3], hm, label="Average temperature")
current_figure() #hide

# ## Related documentation

# ```@meta
# CollapsedDocStrings = true
# ```

# ```@docs; canonical=false
# shiftandrotate
# findrotation
# quantiletransfer
# quantiletransfer!
# ```

# ## References

# ```@bibliography
# Pages = [@__FILE__]
# Style = :authoryear
# ```