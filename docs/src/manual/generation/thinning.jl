# # Spatial thinning of occurrences

using Revise
using SpeciesDistributionToolkit
const SDT = SpeciesDistributionToolkit
using CairoMakie

# To illustrate spatial thinning, we will look at observations of the sasquatch
# in the USA. The polygon is clipped to focus on the continental US.

aoi = getpolygon(PolygonData(NaturalEarth, Countries))["United States of America"]
aoi = clip(aoi, (left=-140., right=-50., top=50., bottom=20.))

# The sightings data are available as a demonstration dataset:

records = Occurrences(mask(OccurrencesInterface.__demodata(), aoi));

# Some of the sightings are very clustered, both to one another and also to more
# densely populated places.

#figure initial-datapoints
f = Figure(; size=(600, 300))
ax = Axis(f[1,1], aspect=DataAspect())
poly!(ax, aoi, color=:grey98)
lines!(ax, aoi, color=:grey10)
scatter!(ax, records, color=:darkgreen, markersize=4)
hidespines!(ax)
hidedecorations!(ax)
current_figure() #hide

# We start by getting a thinned version where a point will have no neighbors
# within a 60km radius:

thinned = thin(records, 60.);

# ::: info Runtime of spatial thinning
#
# The algorithm we use tends to remain efficient until the distance requested is
# much smaller than the average distance between neighboring points. In other
# words, asking for occurrences separated by 50km will be much faster than
# asking for occurrences separated by 1km.
#
# :::

# The points we get after this step should respect the spatial structure of the
# data, but be much sparser.

#figure thinned-datapoints
f = Figure(; size=(600, 300))
ax = Axis(f[1,1], aspect=DataAspect())
poly!(ax, aoi, color=:grey98)
scatter!(ax, records, color=:grey80, markersize=12)
lines!(ax, aoi, color=:grey10)
scatter!(ax, thinned, color=:darkgreen, markersize=4)
hidespines!(ax)
hidedecorations!(ax)
current_figure() #hide

# Note that the algorithm works with some stochasticity, so it is a good idea to
# either set the RNG seed before proceeding, or to run it several time to check
# that the specific points retained do not change the results too much.

# Finally, it is a good idea to examine how the number of remaining points is
# affected by distance.

#figure effect-distance-n-points
D = LinRange(0, 150, 25)
n = [length(thin(records, d)) for d in D]
f = Figure()
ax = Axis(f[1,1]; xlabel="Distance (km)", ylabel="Nb. points")
scatter!(ax, D, n, color=:black)
ylims!(ax, low=0.0)
xlims!(ax, extrema(D)...)
current_figure() #hide

# ## Related documentation

# ```@meta
# CollapsedDocStrings = true
# ```

# ```@docs; canonical=false
# PseudoAbsences.thin
# ```
