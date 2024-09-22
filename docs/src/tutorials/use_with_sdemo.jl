# # Use with the SDeMo package

using SpeciesDistributionToolkit
using CairoMakie
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

provider = RasterData(WorldClim2, BioClim)
layers = [SDMLayer(
    provider;
    layer = x,
    resolution = 0.5,
    left = 0.0,
    right = 20.0,
    bottom = 35.0,
    top = 55.0,
) for x in 1:19]

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

# ---

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

background = pseudoabsencemask(WithinRadius, presencelayer; distance = 30.0)

# -

buffer = pseudoabsencemask(WithinRadius, presencelayer; distance = 5.0)

#-

bgmask = (! buffer) & background

#-

bgpoints = backgroundpoints(bgmask, 2sum(presencelayer))

#-

heatmap(
    first(layers);
    colormap = :navia,
    axis = (; aspect = DataAspect()),
    figure = (; size = (800, 500)),
)
heatmap!(bgmask; colormap = cgrad([:transparent, :white]; alpha = 0.3))
scatter!(presencelayer; color = :black)
scatter!(bgpoints; color = :red, markersize = 4)
current_figure() #hide
