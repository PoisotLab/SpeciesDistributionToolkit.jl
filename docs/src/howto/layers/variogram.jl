# Variograms

# TK

using SpeciesDistributionToolkit
const SDT = SpeciesDistributionToolkit
using PrettyTables
using CairoMakie

# Get some info on temperature

polygon = getpolygon(PolygonData(NaturalEarth, Countries))["Venezuela"]
temperature = SDMLayer(RasterData(CHELSA2, AverageTemperature); SDT.boundingbox(polygon)...)
mask!(temperature, polygon)

# get variogram

x, y, n = variogram(temperature; samples=4000, bins=70)

#figure variogram-temp
f = Figure()
ax = Axis(f[1,1]; xlabel="Distance", ylabel="Variogram")
scatter!(ax, x, y, markersize=n ./ maximum(n) .* 8 .+ 4, color=:grey50)
current_figure() #hide

# can fit a model

# ::: warning Not exported
#
# in progress
#
# these are also convenience functions
#
# :::

G = SDT.fitvariogram(x, y, n; family=:gaussian)
E = SDT.fitvariogram(x, y, n; family=:exponential)
S = SDT.fitvariogram(x, y, n; family=:spherical)

#figure vario-fit
f = Figure()
ax = Axis(f[1,1]; xlabel="Distance", ylabel="Variogram")
scatter!(ax, x, y, markersize=n ./ maximum(n) .* 8 .+ 4, color=:grey50)
vx = LinRange(extrema(x)..., 100)
lines!(ax, vx, G.model.(vx), label="Gaussian")
lines!(ax, vx, E.model.(vx), label="Exponential", linestyle=:dash)
lines!(ax, vx, S.model.(vx), label="Spherical", linestyle=:dot)
axislegend(ax, position=:lt)
current_figure() #hide

# check which are better

M = permutedims(hcat([[m.range, m.sill, m.nugget, m.error] for m in [G, E, S]]...))
M = hcat(["Gaussian", "Exponential", "Spherical"], M)

pretty_table(
    M;
    alignment = [:l, :c, :c, :c, :c],
    backend = :markdown,
    column_labels = ["Model", "Range", "Sill", "Nugget", "Error"],
    formatters = [fmt__printf("%3.3f", [2, 3, 4, 5])],
)

# ```@meta
# CollapsedDocStrings = true
# ```

# ## Related documentation
# 
# ```@docs; canonical=false
# variogram
# SpeciesDistributionToolkit.fitvariogram
# ```
