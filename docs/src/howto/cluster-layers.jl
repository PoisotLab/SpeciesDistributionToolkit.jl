# # Clustering layers

# The purpose of this vignette is to demonstrate how we can use the `Clustering`
# package to apply k-means or fuzzy C-means on layers.

# This functionality is supported through an extension, which is only active
# when the `Clustering` package is loaded. For versions of Julia that do not
# support extensions, this is handled through the `Require` package.

using SpeciesDistributionToolkit
using CairoMakie
using Statistics
import StatsBase
using Clustering # [!code highlight]
CairoMakie.activate!(; type = "png", px_per_unit = 2) #hide

# We will get two layers to work with:

spatial_extent = (left = 8.412, bottom = 41.325, right = 9.662, top = 43.060)
dataprovider = RasterData(CHELSA1, BioClim)
temperature = SDMLayer(dataprovider; layer = "BIO1", spatial_extent...)
precipitation = SDMLayer(dataprovider; layer = "BIO12", spatial_extent...)

# normalize

L = [temperature, precipitation]
L = (L .- mean.(L)) ./ std.(L)

# k-means

K = kmeans(L, 3)

# move to layer uses the last argument to give a template

k = SDMLayer(K, first(L))

# fig-kmeans
fig, ax, hm = heatmap(
    k,
    colormap = :Spectral,
    figure = (; size = (800, 400)),
    axis = (; aspect = DataAspect()),
)
current_figure() #hide

# can also do fuzzy c-means

F = fuzzy_cmeans(L, 2)

# return to layer

f = SDMLayer(F, first(L))

# fig-fuzzycmeans
fig, ax, hm = heatmap(
    F[1],
    colormap = :bamako,
    figure = (; size = (800, 400)),
    axis = (; aspect = DataAspect()),
)
Colorbar(fig[:, end + 1], hm)
current_figure() #hide

# can do validation too