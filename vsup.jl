using Revise
using CairoMakie
using SpeciesDistributionToolkit
const SDT = SpeciesDistributionToolkit

pol = getpolygon(PolygonData(OpenStreetMap, Places); place = "Corsica");
spatialextent = SDT.boundingbox(pol; padding = 0.1)

# some layers

provider = RasterData(CHELSA2, BioClim)
L = SDMLayer{Float16}[
    SDMLayer(
        provider;
        layer = i,
        spatialextent...,
    ) for i in layers(provider)
]

mask!(L, pol)

# Model
model = SDM(RawData, Logistic, SDeMo.__demodata()...)
variables!(model, ForwardSelection)
predict(model, L; threshold = false) |> heatmap

ens = Bagging(model, 50)
bagfeatures!(ens)
train!(ens)

# unpack

val = predict(model, L; threshold = false)
unc = predict(ens, L; threshold = false, consensus = iqr)


f = Figure()
ax_bv = Axis(f[1,1]; aspect=DataAspect())
ax_vs = Axis(f[1,2]; aspect=DataAspect())
bivariate!(ax_bv, val, unc)
vsup!(ax_vs, val, unc)
current_figure()
