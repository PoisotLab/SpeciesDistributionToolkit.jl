# # Variograms

# The package has _limited_ functionalities to generate and fit empirical
# variograms. These are intended as companion functions to the
# [tessellation](/howto/polygons/tessellation) feature, in order to approximate
# a relevant size for the tiling.

# ::: danger Unstable part of the API
#
# The functions on this page should be considered a work in progress, and their
# behavior is likely to change in ways that will be documented here. These
# should be treated primarily as convenience functions.
#
# :::

using SpeciesDistributionToolkit
const SDT = SpeciesDistributionToolkit
using PrettyTables
using CairoMakie
CairoMakie.activate!(; type = "png", px_per_unit = 2) #hide
using Statistics

# ## Variograms on layers

# We will start by grabbing some information on temperature over the island of
# Corsica.

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

# To measure the empirical semi-variogram from this dataset, we need to specify
# the width of each bin, and by how much each bin is shifted from one to the
# other. The `variogram` function will guesstimate the number of point pairs to
# measure in order to ensure that the average coverage of each bin is around 30
# samples.

x, y, n = variogram(temperature; width=5., shift=2.);

# The `variogram` function will return the average distance within the bin `x`,
# the variance within this bin `y`, and the number of point pairs used to
# generate this bin `n`. This last information is important to fit a variogram
# model (as we will discuss later).

#figure variogram-temp
f = Figure()
ax = Axis(f[1,1]; xlabel="Distance", ylabel="Variogram")
scatter!(ax, x, y, markersize=n ./ maximum(n) .* 8 .+ 4, color=:grey50)
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

# We'll start by getting a variogram from a layer:

x, y, n = variogram(temperature, width=1., shift=0.5)

# The _unexported_ `fitvariogram` method will get the parameters for one of the
# usual variogram models.

G = SDT.fitvariogram(x, y, n; family=:gaussian);
E = SDT.fitvariogram(x, y, n; family=:exponential);
S = SDT.fitvariogram(x, y, n; family=:spherical);

# This function relies on the Nelder-Mead solver to find an approximate value of
# the parameters. Note that the error associated to each parameter set accounts
# for the number of samples in each bin, and that samples get linearly less
# weight with decreasing number of observations.

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

# ## Variogram on SDMs

# Variograms can also be generated on the training data of an SDM. We will grab
# enough data to train an SDM:

L = [SDMLayer(RasterData(CHELSA2, BioClim); SDT.boundingbox(polygon)..., layer=i) for i in 1:19]
mask!(L, polygon)
records = SDeMo.__demodata()
model = SDM(RawData, Logistic, records...)
variables!(model, ForwardSelection)

# To generate the variogram from these data, we need to specify a variable
# through the keywword argument of the same name:

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

# We can measure the range that corresponds to the variation of each variable
# selected by the model:

variomodels = [
    SDT.fitvariogram(variogram(model; variable=i)...; family=:gaussian)
    for i in variables(model)
];
ranges = [m.range for m in variomodels]

# We can then, for example, get the median range across all these variables,
# which is a common approximation for the correct block size to use in spatial
# cross-validation.

#figure vario-range-by-variable
f = Figure()
xticks = (
    1:length(variables(model)),
    "BIO".*string.(variables(model))
)
ax = Axis(f[1, 1]; ylabel="Range (km)", xticks=xticks, xticklabelrotation=π/2)
hlines!(ax, [median(ranges)], color=:grey50, linestyle=:dash)
stem!(ax, ranges, trunkcolor=:transparent, color=:black, stemcolor=:black, stemwidth=2, markersize=15, marker=:hline)
ylims!(ax, low=0.0)
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
