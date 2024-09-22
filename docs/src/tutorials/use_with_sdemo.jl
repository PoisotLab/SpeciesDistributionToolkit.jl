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
    ) for x in [5, 2, 14]
]

#-

layers = [trim(mask!(layer, CHE)) for layer in layers]

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

# We can plot the layer and all occurrences:

heatmap(first(layers); colormap = :navia, axis = (; aspect = DataAspect()))
scatter!(presences; color = :orange, markersize = 4)
current_figure() #hide

# -

presencelayer = zeros(first(layers), Bool)
for occ in mask(presences, CHE)
    presencelayer[occ.longitude, occ.latitude] = true
end

#-

background = pseudoabsencemask(DistanceToEvent, presencelayer)
bgpoints = backgroundpoints(background, sum(presencelayer))

#-

heatmap(
    first(layers);
    colormap = :navia,
    axis = (; aspect = DataAspect()),
    figure = (; size = (800, 500)),
)
scatter!(presencelayer; color = :black)
scatter!(bgpoints; color = :red, markersize = 4)
current_figure() #hide

#-

sdm = SDM(MultivariateTransform{PCA}, NaiveBayes, layers, presencelayer, bgpoints)

#-

folds = kfold(sdm; k = 15);
cv = crossvalidate(sdm, folds; threshold = false)
mcc.(cv.validation)
ci(cv.validation)
train!(sdm)

#-

x, y = partialresponse(sdm, 1; threshold = false)
scatter(x, y)

#-

prd = predict(sdm, layers; threshold = false)

#-

f = Figure()
ax = Axis(f[1, 1]; aspect = DataAspect(), title = "Prediction")
heatmap!(ax, prd; colormap = :Blues)
hidedecorations!(ax) #hide
hidespines!(ax) #hide
current_figure() #hide

#-

bag = Bagging(sdm, 20)
train!(bag)
unc = predict(bag, layers; consensus = iqr, threshold = false)

#-

outofbag(bag) |> mcc

#-

ax2 = Axis(f[2, 1]; aspect = DataAspect(), title = "Uncertainty")
heatmap!(ax2, quantize(unc, 10); colormap = :Purples)
hidedecorations!(ax2) #hide
hidespines!(ax2) #hide
current_figure() #hide

#-

part_v1 = partialresponse(sdm, layers, 1; threshold = false)

#-

shap_v1 = explain(sdm, layers, 1; threshold = false, samples = 50)

#-

f = Figure()
ax = Axis(f[1, 1]; aspect = DataAspect(), title = "Shapley values")
hm = heatmap!(ax, shap_v1; colormap = :roma, colorrange=(-0.3, 0.3))
hidedecorations!(ax) #hide
hidespines!(ax) #hide
Colorbar(f[1,2], hm)
ax2 = Axis(f[2, 1]; aspect = DataAspect(), title = "Partial response")
hm = heatmap!(ax2, part_v1; colormap = :Oranges, colorrange=(0, 1))
Colorbar(f[2,2], hm)
hidedecorations!(ax2) #hide
hidespines!(ax2) #hide
current_figure() #hide

#-
