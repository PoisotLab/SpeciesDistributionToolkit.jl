# # Clustering layers

# The purpose of this vignette is to demonstrate how we can use the `Clustering`
# package to apply k-means or fuzzy C-means on layers.

# This functionality is supported through an extension, which is only active
# when the `Clustering` package is loaded. For versions of Julia that do not
# support extensions (this means any 1.8 version), this is handled through the
# `Require` package.

using SpeciesDistributionToolkit
using CairoMakie
using Statistics
import StatsBase
using Clustering # [!code highlight]
CairoMakie.activate!(; type = "png", px_per_unit = 2) #hide

# The support is currently limited to clustering methods that take a matrix of
# features, as distance matrices for large layers risk getting extremely large.
# To illustrate how the integration with `Clustering` works, we will get data
# from CHELSA1:

spatial_extent = (left = 8.412, bottom = 41.325, right = 9.662, top = 43.060)
dataprovider = RasterData(CHELSA1, BioClim)
L = [SDMLayer(dataprovider; layer = i, spatial_extent...) for i in [1, 3, 8, 12]]

# It makes more sense to normalize these layers, so they all have unit variance
# and a mean of zero:

L = (L .- mean.(L)) ./ std.(L)

# The syntax is the exact same as the `Clustering` package, with the feature
# matrix replaced by the vector of layers. For example, k-means with k=3 on
# these input data is done with:

K = kmeans(L, 3)

# Note that this will return a `Clustering` result object, which can therefore
# be validated using any measure of clustering performance.

# To bring this result back to a layer, we can use the following syntax:

k = SDMLayer(K, L)

# The last argument *must* be a layer (or a vector of layers), which will be
# used as a template to store the output values in. In the case of `kmeans`,
# this is the cluster to which each pixel is assigned.

# We can get the quality of this clustering with

clustering_quality(L, K; quality_index = :davies_bouldin)

# We can visualize the result of this clustering:

# fig-kmeans
fig, ax, hm = heatmap(
    k,
    colormap = :Spectral,
    figure = (; size = (800, 400)),
    axis = (; aspect = DataAspect()),
)
current_figure() #hide

# Fuzzy C-means is also supported. We can get three fuzzy clusters (under a fuzzyness parameter of 2) with

F = fuzzy_cmeans(L, 3, 2)

# This can be converted into a vector of layers with the following syntax:

f = SDMLayer(F, L)

# Each layer represents the membership of a pixel to each of the fuzzy clusters.
# If required, these can be passed through `mosaic` with `argmax` to get the
# most likely cluster.

# fig-fuzzycmeans
fig, ax, hm = heatmap(
    f[1],
    colormap = :bamako,
    figure = (; size = (800, 400)),
    axis = (; aspect = DataAspect()),
)
Colorbar(fig[:, end + 1], hm)
current_figure() #hide
