# Test
using SpeciesDistributionToolkit
const SDT = SpeciesDistributionToolkit
using Statistics
using Random
using CairoMakie

X, y, C = SDeMo.__demodata()

pol = getpolygon(PolygonData(OpenStreetMap, Places); place = "Corse")
layers = SDMLayer{Float32}[
    SDMLayer(RasterData(CHELSA2, BioClim), pol; layer = i)
    for i in 1:19
]
mask!(layers, pol)

model = SDM(PCATransform, SGD, X, y, C)
hyperparameters!(classifier(model), :loss, :logloss)
hyperparameters!(classifier(model), :λ, 0.1)
hyperparameters!(classifier(model), :intercept, true)
train!(model)

@info classifier(model).β
@info classifier(model).θ

fi = [featureimportance(PartialDependence, model, v; threshold=false) for v in variables(model)]

fi ./= sum(fi)
v = last(findmax(fi))

fg = Figure()
ax = Axis(fg[1:2,1]; aspect=DataAspect())
fimp = Axis(fg[1, 2])
shp = Axis(fg[2, 2])
hm = heatmap!(
    ax,
    predict(model, layers; threshold=false),
    colormap = :batlowW,
    colorrange = (0, 1)
)
for i in eachindex(labels(model))
    c = labels(model)[i] ? :red : :teal
    lines!(fimp, explainmodel(CeterisParibus, model, v, i; threshold=false)..., color=(c, 0.1))
end
Colorbar(fg[3,1:2], hm, vertical=false)
scatter!(shp, explainmodel(ShapleyMC, model, v; threshold=false)..., color=(:grey50, 0.5))
current_figure()
