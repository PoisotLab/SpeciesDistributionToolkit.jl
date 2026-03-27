# # Measuring and mapping covariate shift

using SpeciesDistributionToolkit
const SDT = SpeciesDistributionToolkit
using Statistics
import StatsBase
using MultivariateStats # [!code highlight]
using CairoMakie

# The support is currently limited to PCA

model = SDM(RawData, Logistic, SDeMo.__demodata()...)
variables!(model, ForwardSelection)

# 

pol = getpolygon(PolygonData(OpenStreetMap, Places); place = "Corse")
L = SDMLayer{Float32}[
    SDMLayer(RasterData(CHELSA2, BioClim); SDT.boundingbox(pol)..., layer = i) for
    i in 1:19
]
mask!(L, pol)
reconcile!(L)

# train a PCA on the training data

X = features(model)[variables(model),:]
μ = vec(mean(X, dims=2))
σ = vec(mean(X, dims=2))
X = (X .- μ) ./ σ

# fit the PCA for real

M = fit(PCA, X)

# Note that this will return a `PCA` result object. We can use it to project a
# vector of layers:

K = (L[variables(model)] .- μ)./σ

# we can also reconstruct

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
