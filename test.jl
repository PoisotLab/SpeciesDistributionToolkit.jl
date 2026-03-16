using Revise
using CairoMakie
using SpeciesDistributionToolkit
const SDT = SpeciesDistributionToolkit

# Get data
pol = getpolygon(PolygonData(ESRI, Places))["Place name" => "Corse"]
bb = SDT.boundingbox(pol; padding = 0.1)

model = SDM(RawData, Logistic, SDeMo.__demodata()...)

L = [SDMLayer(RasterData(CHELSA2, BioClim); layer=i, bb...) for i in layers(RasterData(CHELSA2, BioClim))]
mask!(L, pol)

h = hexagons(bb, 12.0; offset = (0, 0))

pointy = hexagons(pol, 12.0; padding = 0.2, pointy = true)
flat = hexagons(pol, 12.0; padding = 0.2, pointy = false)

f = Figure()
ax1 = Axis(f[1, 1]; aspect = DataAspect(), title = "Flat side up")
ax2 = Axis(f[1, 2]; aspect = DataAspect(), title = "Pointy side up")
poly!(ax1, pol; color = :grey90)
poly!(ax2, pol; color = :grey90)
lines!(ax1, flat; color = (:black, 0.6))
lines!(ax2, pointy; color = (:black, 0.6))
current_figure()

f = Figure()
ax = Axis(f[1, 1]; aspect = DataAspect())
lines!(ax, hexagons(model, 12.0))
scatter!(
    ax,
    model;
    color = labels(model),
    colormap = :Purples,
    strokecolor = :black,
    strokewidth = 0.4,
    markersize = 4,
)
current_figure()

f = Figure()
ax = Axis(f[1, 1]; aspect = DataAspect())
heatmap!(ax, L[1]; colormap = :navia)
lines!(ax, hexagons(L[1], 12.0; pointy = false); color = :grey60)
current_figure()

f = Figure()
ax = Axis(f[1, 1]; aspect = DataAspect())
lines!(ax, hexagons(pol, 12.0; pointy = false); color = :grey60)
scatter!(
    ax,
    model;
    color = labels(model),
    colormap = :Purples,
    strokecolor = :black,
    strokewidth = 0.4,
    markersize = 4,
)
current_figure()

h = hexagons(pol, 5.0; pointy = true)
ab = SDT.keeprelevant(h, absences(model))
pr = SDT.keeprelevant(h, presences(model))

f = Figure()
ax = Axis(f[1, 1]; aspect = DataAspect())
poly!(ax, pr; color = (:red, 0.5))
poly!(ax, ab; color = (:skyblue, 0.4))
lines!(h; color = :grey10, linewidth = 0.5)
current_figure()

h = hexagons(model, 12.5; pointy = false)
SDT.cvlabel!(h; n = 10, order = :balanced)

colpal = cgrad(:Set1, maximum(uniqueproperties(h)["__fold"]); categorical = true)

f = Figure()
ax = Axis(f[1, 1]; aspect = DataAspect())
for k in uniqueproperties(h)["__fold"]
    poly!(ax, h["__fold" => k]; color = colpal[k], alpha = 0.2)
end
for ft in h.features
    text!(
        ax,
        ft.properties["__centroid"];
        text = string(ft.properties["__fold"]),
        align = (:center, :center),
        color = :black,
    )
end
lines!(ax, h; color = :grey20)
current_figure()

function spatialfold(model::SDM, blocks::FeatureCollection)
    @assert "__fold" in keys(uniqueproperties(blocks))
    folds = Tuple{Vector{Int64}, Vector{Int64}}[]

    for fold in Base.OneTo(maximum(uniqueproperties(blocks)["__fold"]))
        occ = mask(model, blocks["__fold" => fold])
        test = sort(indexin(place(occ), place(model)))
        train = setdiff(eachindex(labels(model)), test)
        push!(folds, (train, test))
    end
    return folds
end

function spatialfold(blocks::FeatureCollection)
    return (model::SDM) -> spatialfold(model, blocks)
end

# Split the instances into folds

folds = spatialfold(h)(model)
variables!(model, AllVariables)
variables!(model, BackwardSelection, folds; verbose=true)

cv = crossvalidate(model, folds)
@info mcc(cv.validation)
@info mcc(cv.training)

f = Figure()
ax = Axis(f[1, 1]; aspect = DataAspect())
heatmap!(ax, predict(model, L; threshold=false))
for ft in h.features
    text!(
        ax,
        ft.properties["__centroid"];
        text = string(ft.properties["__fold"]),
        align = (:center, :center),
        color = :black,
    )
end
lines!(ax, h; color = :grey20)
current_figure()

x, y, n = SDT.variogram(L[1], 1000, 60)
scatter(x, y; markersize=n)