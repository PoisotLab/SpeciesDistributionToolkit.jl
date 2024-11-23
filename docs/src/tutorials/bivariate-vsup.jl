# # Value-suppressing and bivariate maps

using Revise
using SpeciesDistributionToolkit
using CairoMakie
using Statistics
CairoMakie.activate!(; type = "png", px_per_unit = 2) #hide

CHE = SpeciesDistributionToolkit.gadm("CHE");
spatialextent = SpeciesDistributionToolkit.boundingbox(CHE; padding=1.0)

bio_vars = [1, 7, 10]
provider = RasterData(CHELSA2, BioClim)
layers = [
    SDMLayer(
        provider;
        layer = x,
        spatialextent...
    ) for x in bio_vars
];
layers = [trim(mask!(layer, CHE)) for layer in layers];
layers = map(l -> convert(SDMLayer{Float32}, l), layers);

ouzel = taxon("Turdus torquatus")
presences = occurrences(
    ouzel,
    first(layers),
    "occurrenceStatus" => "PRESENT",
    "limit" => 300,
    "datasetKey" => "4fa7b334-ce0d-4e88-aaae-2e0c138d049e",
)
while length(presences) < count(presences)
    occurrences!(presences)
end

presencelayer = zeros(first(layers), Bool)
for occ in mask(presences, CHE)
    presencelayer[occ.longitude, occ.latitude] = true
end

background = pseudoabsencemask(DistanceToEvent, presencelayer)
bgpoints = backgroundpoints(background, sum(presencelayer))

f = Figure(; size = (600, 300))
ax = Axis(f[1, 1]; aspect = DataAspect())
heatmap!(ax,
    first(layers);
    colormap = :linear_bgyw_20_98_c66_n256,
)
scatter!(ax, presencelayer; color = :black)
scatter!(ax, bgpoints; color = :red, markersize = 4)
lines!(ax, CHE.geometry[1]; color = :black) #hide
hidedecorations!(ax) #hide
hidespines!(ax) #hide
current_figure() #hide

sdm = SDM(ZScore, DecisionTree, layers, presencelayer, bgpoints)

# Uncertainty and value layer
ensemble = Bagging(sdm, 50)
bagfeatures!(ensemble)
train!(ensemble)
unc = predict(ensemble, layers; consensus = iqr, threshold = false)
prd = predict(ensemble, layers; consensus = median, threshold = false)

# VSUP test
ubins = 50
vbins = 50
vbin = discretize(prd, vbins)
ubin = quantize(unc, ubins) * ubins

pal = SpeciesDistributionToolkit._vsup_grid(ubins, vbins, :isoluminant_cgo_70_c39_n256)

# fig-vsup-colorpalette
f = Figure(; size=(800,400))
ax = Axis(f[1, 1]; aspect = DataAspect())
heatmap!(ax, vbin + (ubin - 1) * maximum(vbin); colormap = vcat(pal...))
lines!(ax, CHE[1].geometry, color=:black)
hidespines!(ax)
hidedecorations!(ax)
current_figure() #hide

p = PolarAxis(
    f[1, 2];
    theta_0 = -pi / 2.5,
    direction = -1,
    tellheight = false,
    tellwidth = false,
)
surface!(
    p,
    0 .. π/5,
    0 .. 1,
    zeros(size(pal));
    color = reverse(pal),
    shading = NoShading,
)
thetalims!(p, 0, pi/5)
colsize!(f.layout, 1, Relative(0.7))
current_figure()

# Bivariate palette test