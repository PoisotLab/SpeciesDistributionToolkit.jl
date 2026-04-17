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
hyperparameters!(classifier(model), :epochs, 5000)
hyperparameters!(classifier(model), :λ, 0.05)
hyperparameters!(classifier(model), :intercept, true)
@profview train!(model)

ti, vi = holdout(model)
Lt = zeros(Float64, 50)
Lv = zeros(Float64, length(Lt))
e = round.(Int64, LinRange(15, 6000, length(Lt)))
for i in eachindex(Lv)
    model = SDM(PCATransform, SGD, X, y, C)
    hyperparameters!(classifier(model), :epochs, e[i])
    hyperparameters!(classifier(model), :L1, true)
    train!(model; training=ti)
    Lv[i] = crossentropyloss(predict(model; threshold=false)[vi], labels(model)[vi])
    Lt[i] = crossentropyloss(predict(model; threshold=false)[ti], labels(model)[ti])
end

scatter(e, Lt .- Lv, color=:black)

@info classifier(model).β

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
