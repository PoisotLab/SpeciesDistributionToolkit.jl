# # Applying multivariate transformations

# The purpose of this vignette is to demonstrate how we can use the `MultivariateStats`
# package on layers.

# This functionality is supported through an extension, which is only active
# when the `MultivariateStats` package is loaded.

using SpeciesDistributionToolkit
using Statistics
import StatsBase
using MultivariateStats # [!code highlight]
using CairoMakie

# The support is currently limited to PCA

spatial_extent = (left = 8.412, bottom = 41.325, right = 9.662, top = 43.060)
dataprovider = RasterData(CHELSA1, BioClim)
L = [SDMLayer(dataprovider; layer = i, spatial_extent...) for i in [1, 3, 8, 12]]

# We can fit a PCA the "normal" way:

M = fit(PCA, L; maxoutdim = 2)

# Note that this will return a `PCA` result object. We can use it to project a
# vector of layers:

X = predict(M, L)

# The last argument *must* be a vector of layers (or a vector of layers), which will be
# used as a template to store the output values in.

# ::: danger Data leakage
# 
# Transforming the layers before extracting the values of environmental
# conditions for SDMs creates data leakage and should never be done. `SDeMo`
# handles projections the correct way.
# 
# :::

# We can visualize the result of this projection (first principal component):

#figure pca
fig, ax, hm = heatmap(
    X[1];
    colormap = :Spectral,
    figure = (; size = (800, 400)),
    axis = (; aspect = DataAspect()),
)
current_figure() #hide

# Note that the `reconstruct` operation, which works _from_ the projected data
# and attemps to reconstruct the original data, is also supported:

R = reconstruct(M, X)

#figure Original and reconstructed first layer
f = Figure()
ao = Axis(f[1,1]; aspect=DataAspect(), title="Original")
ar = Axis(f[1,2]; aspect=DataAspect(), title="Reconstructed")
heatmap!(ao, L[1], colormap=Reverse(:navia), colorrange=extrema(L[1]))
heatmap!(ar, R[1], colormap=Reverse(:navia), colorrange=extrema(L[1]))
for a in [ar, ao]
    hidespines!(a)
    hidedecorations!(a)
end
current_figure() #hide