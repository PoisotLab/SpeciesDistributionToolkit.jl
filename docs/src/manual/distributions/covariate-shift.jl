# # Measuring and mapping covariate shift

# In this vignette, we will measure the reconstruction error of a PCA, in order
# to measure the amount of covariate shift between the training data and the
# data used for prediction.

using SpeciesDistributionToolkit
const SDT = SpeciesDistributionToolkit
using CairoMakie

# We will need to rely on the integration with `MultivariateStats` in order to
# fit and then apply the PCA, so we will load this package as well:

using Statistics
using MultivariateStats # [!code highlight]

# ::: info This is a temporary vignette!
#
# This functionality will ultimately be ported to the `SDeMo` package. It is
# included as a reference, but the code will be updated to reflect the new
# functions.
#
# :::

# ## Declaring the model

# We will measure the multi-variate covariate shift, which reflects how much the
# joint distribution of variables shifts from the training data to the
# prediction data. In order to do this, we first need a model:

model = SDM(ZScore, Logistic, SDeMo.__demodata()...)
variables!(model, ForwardSelection)

# We then collect the data from the CHELSA2 BioClim on which this model was
# trained, as a series of layers:

pol = getpolygon(PolygonData(OpenStreetMap, Places); place = "Corse")
L = SDMLayer{Float32}[
    SDMLayer(RasterData(CHELSA2, BioClim); SDT.boundingbox(pol)..., layer = i) for
    i in 1:19
]
mask!(L, pol)

# ::: tip Reconciling a stack of layers
#
# In rare cases, layers from the same providers may have minute differences in
# their `x` and `y` coordinates after being clipped. In order to repair them, we
# can use the `reconcile` function or its mutating variant. This should only be
# used when the layers have non-matching coordinates.
#
# :::

reconcile!(L)

# ## PCA on the training data

# Our first step is to fit a PCA on the training data. Because we are working
# with a dataset with variables on different scales, we will transform all the
# variables so that they have a mean of 0 and unit variance.

X = features(model)[variables(model),:]
μ = vec(mean(X, dims=2))
σ = vec(mean(X, dims=2))
X = (X .- μ) ./ σ;

# We can now fit a PCA on this matrix. The package supports [fitting directly
# from layers as well](/manual/layers/multivariate/).

M = fit(PCA, X)

# ## Measuring the reconstruction error

# We now need to transform the layers, but only after ensuring that they are
# transformed using the same operations that gave us a training dataset with
# mean of 0 and unit variance.

K = (L[variables(model)] .- μ)./σ

# Our measure of covariate shit will be as follow

Y = reconstruct(M,  SpeciesDistributionToolkit._X_from_layers(predict(M, K)))

# matrix we should get

N = SpeciesDistributionToolkit._X_from_layers(K)

# proportional error for each variable

P = sqrt.((Y .- N).^2.0)

# where is this error distributed

E = dropdims(mean(P, dims=1), dims=1)

#figure Mapping of covariate shift across the different pixels
f = Figure()
ax = Axis(f[1,1]; aspect=DataAspect())
hm = heatmap!(ax, SimpleSDMLayers.burnin(L[1], E), colormap=Reverse(:navia))
Colorbar(f[1,2], hm)
current_figure() #hide

# ## Related documentation

# ```@meta
# CollapsedDocStrings = true
# ```

# ```@docs; canonical=false
# reconcile!
# reconcile
# ```
