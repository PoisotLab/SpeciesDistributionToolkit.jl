# # Use with the SDeMo package

using SpeciesDistributionToolkit
using CairoMakie
using Statistics
CairoMakie.activate!(; type = "png", px_per_unit = 3.0) #hide

# In this tutorial, we will clip a layer to a polygon (in GeoJSON format), then
# use the same polygon to filter GBIF records.

# We provide a very lightweight wrapper around the
# [GADM](https://gadm.org/index.html) database, which will return data as
# ready-to-use GeoJSON files. For example, we can get the borders of
# Switzerland, as featured in [the excellent tutorial on SDMs by Damaris
# Zurell](https://damariszurell.github.io/SDM-Intro/).

CHE = SpeciesDistributionToolkit.gadm("CHE")

#-

provider = RasterData(CHELSA2, BioClim)
layers = [
    SDMLayer(
        provider;
        layer = x,
        left = 0.0,
        right = 20.0,
        bottom = 35.0,
        top = 55.0,
    ) for x in [1, 5, 2, 8, 3, 14, 12, 19]
]

#-

layers = [trim(mask!(layer, CHE)) for layer in layers]
layers = map(l -> convert(SDMLayer{Float32}, l), layers)

#-

ouzel = taxon("Turdus torquatus")
presences = occurrences(
    ouzel,
    first(layers),
    "occurrenceStatus" => "PRESENT",
    "limit" => 300,
    "datasetKey" => "4fa7b334-ce0d-4e88-aaae-2e0c138d049e",
)

#-

while length(presences) < count(presences)
    occurrences!(presences)
end

# -

presencelayer = zeros(first(layers), Bool)
for occ in mask(presences, CHE)
    presencelayer[occ.longitude, occ.latitude] = true
end

#-

background = pseudoabsencemask(DistanceToEvent, presencelayer)
bgpoints = backgroundpoints(background, sum(presencelayer))

#-

f = Figure(; size=(800,400))
ax = Axis(f[1,1]; aspect=DataAspect())
heatmap!(ax,
    first(layers);
    colormap = :navia
)
scatter!(ax, presencelayer; color = :black)
scatter!(ax, bgpoints; color = :red, markersize = 4)
lines!(ax, CHE.geometry[1], color=:black) #hide
hidedecorations!(ax) #hide
hidespines!(ax) #hide
current_figure() #hide

#-

sdm = SDM(MultivariateTransform{PCA}, NaiveBayes, layers, presencelayer, bgpoints)

#-

folds = kfold(sdm);
cv = crossvalidate(sdm, folds; threshold = true);

#-

mcc.(cv.validation)
fscore.(cv.validation)

#-

forwardselection!(sdm, folds, [1]; verbose=true)

#-

train!(sdm)

#-

varimp = variableimportance(sdm, folds)
varimp ./= sum(varimp)

#-

x, y = partialresponse(sdm, 1; threshold = false)
lines(x, y)

#-

prd = predict(sdm, layers; threshold = false)

#-

bag = Bagging(sdm, 20)
train!(bag)
unc = predict(bag, layers; consensus = iqr, threshold = false)

#-

outofbag(bag) |> dor

#-

f = Figure(; size=(800,800))
ax = Axis(f[1, 1]; aspect = DataAspect(), title = "Prediction")
heatmap!(ax, prd; colormap = :linear_worb_100_25_c53_n256)
contour!(ax, predict(sdm, layers), color=:black, linewidth=0.5) #hide
lines!(ax, CHE.geometry[1], color=:black) #hide
hidedecorations!(ax) #hide
hidespines!(ax) #hide
ax2 = Axis(f[2, 1]; aspect = DataAspect(), title = "Uncertainty")
heatmap!(ax2, quantize(unc); colormap = :linear_gow_60_85_c27_n256)
contour!(ax2, predict(sdm, layers), color=:black, linewidth=0.5) #hide
lines!(ax2, CHE.geometry[1], color=:black) #hide
hidedecorations!(ax2) #hide
hidespines!(ax2) #hide
current_figure() #hide

#-

part_v1 = partialresponse(sdm, layers, 1; threshold = false)

#-

shap_v1 = explain(sdm, layers, 1; threshold = false, samples = 50)

#-

f = Figure(; size=(800,800))
ax = Axis(f[1, 1]; aspect = DataAspect(), title = "Shapley values")
hm = heatmap!(ax, shap_v1; colormap = :diverging_gwv_55_95_c39_n256, colorrange=(-0.3, 0.3))
contour!(ax, predict(sdm, layers), color=:black, linewidth=0.5) #hide
lines!(ax, CHE.geometry[1], color=:black) #hide
hidedecorations!(ax) #hide
hidespines!(ax) #hide
Colorbar(f[1,2], hm)
ax2 = Axis(f[2, 1]; aspect = DataAspect(), title = "Partial response")
hm = heatmap!(ax2, part_v1; colormap = :linear_gow_65_90_c35_n256, colorrange=(0, 1))
contour!(ax2, predict(sdm, layers), color=:black, linewidth=0.5) #hide
lines!(ax2, CHE.geometry[1], color=:black) #hide
Colorbar(f[2,2], hm)
hidedecorations!(ax2) #hide
hidespines!(ax2) #hide
current_figure() #hide

#-

S = [explain(sdm, layers, v; threshold = false, samples = 50) for v in variables(sdm)]

#-

f = Figure(; size=(800,400))
ax = Axis(f[1,1]; aspect=DataAspect())
heatmap!(ax, mosaic(argmax, S), colormap=cgrad(:glasbey_category10_n256, length(variables(sdm)), categorical=true))
contour!(ax, predict(sdm, layers), color=:black, linewidth=0.5) #hide
lines!(ax, CHE.geometry[1], color=:black) #hide
hidedecorations!(ax) #hide
hidespines!(ax) #hide
current_figure() #hide