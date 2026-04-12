# # Spatial thinning of occurrences

using Revise
using SpeciesDistributionToolkit
const SDT = SpeciesDistributionToolkit
using CairoMakie

# get data

aoi = getpolygon(PolygonData(NaturalEarth, Countries))["United States of America"]
aoi = clip(aoi, (left=-140., right=-50., top=50., bottom=20.))

# records

records = Occurrences(mask(OccurrencesInterface.__demodata(), aoi));

#figure initial-datapoints
f = Figure()
ax = Axis(f[1,1], aspect=DataAspect())
poly!(ax, aoi, color=:grey98)
lines!(ax, aoi, color=:grey10)
scatter!(ax, records, color=:darkgreen)
current_figure() #hide

# get a thinned version with at least 100km between each point

thinned = thin(records, 80.);

#figure thinned-datapoints
f = Figure()
ax = Axis(f[1,1], aspect=DataAspect())
poly!(ax, aoi, color=:grey98)
scatter!(ax, records, color=:grey80, markersize=12)
lines!(ax, aoi, color=:grey10)
scatter!(ax, thinned, color=:darkgreen, markersize=6)
current_figure() #hide

# results are differentso good idea to replicate

#figure thinned-datapoints-replicated
f = Figure()
ax = Axis(f[1,1], aspect=DataAspect())
poly!(ax, aoi, color=:grey98)
scatter!(ax, records, color=:grey80, markersize=12)
lines!(ax, aoi, color=:grey10)
for _ in 1:5
    scatter!(ax, thin(records, 80.), markersize=6)
end
current_figure() #hide

# effect of distance on number points

#figure effect-distance-n-points
D = LinRange(0, 350, 20)
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
