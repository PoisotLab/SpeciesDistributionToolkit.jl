# Variograms

# TK

using SpeciesDistributionToolkit
const SDT = SpeciesDistributionToolkit
using PrettyTables
using CairoMakie
CairoMakie.activate!(; type = "png", px_per_unit = 2) #hide
using Statistics

# ## Variograms on layers

# Get some info on temperature

polygon = getpolygon(PolygonData(ESRI, Places))["Place name" => "Corse"]
temperature = SDMLayer(RasterData(CHELSA2, AverageTemperature); SDT.boundingbox(polygon)...)
mask!(temperature, polygon);

#figure temp-vario-map
f = Figure()
ax = Axis(f[1,1]; aspect=DataAspect())
hm = heatmap!(ax, temperature, colormap=:thermal)
lines!(ax, polygon, color=:black)
hidespines!(ax)
hidedecorations!(ax)
Colorbar(f[1,2], hm)
current_figure() #hide

# get variogram

x, y, n = variogram(temperature; width=5., shift=2.);

#figure variogram-temp
f = Figure()
ax = Axis(f[1,1]; xlabel="Distance", ylabel="Variogram")
scatter!(ax, x, y, markersize=n ./ maximum(n) .* 8 .+ 4, color=:grey50)
ylims!(ax, quantile(y, [0.0, 0.9])...)
current_figure() #hide

# ## Variogram on SDMs

L = [SDMLayer(RasterData(CHELSA2, BioClim); SDT.boundingbox(polygon)..., layer=i) for i in 1:19]
mask!(L, polygon)
records = SDeMo.__demodata()
model = SDM(RawData, NaiveBayes, records...)
variables!(model, [1, 12])
train!(model)

# variog

x, y, n = variogram(model; variable=1, width=2., shift=1.); # [!code highlight]
xl, yl, nl = variogram(L[1], width=2., shift=1.);

#figure vario-on-sdm
f = Figure()
ax = Axis(f[1,1]; xlabel="Distance", ylabel="Variogram")
scatter!(ax, x, y, markersize=n ./ maximum(n) .* 8 .+ 4, color=:purple, label="Training instances")
scatter!(ax, xl, yl, markersize=nl ./ maximum(nl) .* 8 .+ 4, color=:forestgreen, marker=:rect, label="Layer")
axislegend(ax, position=:rt)
ylims!(ax, quantile(y, [0.0, 0.9])...)
current_figure() #hide

# ## Variogram on occurrences

# We can also generate the variogram on a collection of occurrences, which is
# primarily useful to check the distance at which two observations are likely to
# be different.

x, y, n = variogram(Occurrences(model))

#figure vario-on-sdm
f = Figure()
ax = Axis(f[1,1]; xlabel="Distance", ylabel="Variogram")
scatter!(ax, x, y, markersize=n ./ maximum(n) .* 8 .+ 4, color=:teal)
ylims!(ax, quantile(y, [0.0, 0.9])...)
current_figure() #hide

# ## Fitting a model to the variogram

# ::: warning Not exported
#
# in progress
#
# these are also convenience functions
#
# :::

x, y, n = variogram(L[2], width=1., shift=0.5)

# This function relies on the Nelder-Mead solver to find an approximate value of
# the parameters. Note that the error associated to each parameter set accounts
# for the number of samples in each bin, and that samples get linearly less
# weight with decreasing number of observations.

G = SDT.fitvariogram(x, y, n; family=:gaussian);
E = SDT.fitvariogram(x, y, n; family=:exponential);
S = SDT.fitvariogram(x, y, n; family=:spherical);

# The outputs are named tuples with fields for the nugget, sill, range, as well
# as the error, and a function giving the best model.

#figure vario-fit
f = Figure()
ax = Axis(f[1,1]; xlabel="Distance", ylabel="Variogram")
scatter!(ax, x, y, markersize=n ./ maximum(n) .* 8 .+ 4, color=:grey50)
vx = LinRange(extrema(x)..., 100)
lines!(ax, vx, G.model.(vx), label="Gaussian")
lines!(ax, vx, E.model.(vx), label="Exponential", linestyle=:dash)
lines!(ax, vx, S.model.(vx), label="Spherical", linestyle=:dot)
ylims!(ax, quantile(y, [0.0, 0.9])...)
axislegend(ax, position=:lt)
current_figure() #hide

# We can aggregate this information to figure out which model describes the data
# better:

M = permutedims(hcat([[m.range, m.sill, m.nugget, m.error] for m in [G, E, S]]...));
M = hcat(["Gaussian", "Exponential", "Spherical"], M);

#-

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
