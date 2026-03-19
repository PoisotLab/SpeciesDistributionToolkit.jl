# Variograms

# TK

using SpeciesDistributionToolkit
const SDT = SpeciesDistributionToolkit
using CairoMakie

# Get some info on temperature

polygon = getpolygon(PolygonData(NaturalEarth, Countries))["Japan"]
temperature = SDMLayer(RasterData(CHELSA2, AverageTemperature); SDT.boundingbox(polygon)...)
mask!(temperature, polygon)

# get variogram

x, y, n = variogram(temperature; samples=2000, bins=100)

#figure variogram-temp
f = Figure()
ax = Axis(f[1,1]; xlabel="Distance", ylabel="Variogram")
scatter!(ax, x, y, markersize=n ./ maximum(n) .* 8 .+ 4)
current_figure() #hide

# can fit a model

# ::: warning Not exported
#
# in progress
#
# :::

m = SDT.fitvariogram(x, y, n; family=:spherical)

#figure vario-fit
f = Figure()
ax = Axis(f[1,1]; xlabel="Distance", ylabel="Variogram")
scatter!(ax, x, y, markersize=n ./ maximum(n) .* 8 .+ 4)
vx = LinRange(extrema(x)..., 50)
lines!(ax, vx, m.model.(vx))
current_figure() #hide

# ```@meta
# CollapsedDocStrings = true
# ```

# ## Related documentation
# 
# ```@docs; canonical=false
# variogram
# SpeciesDistributionToolkit.fitvariogram
# ```
