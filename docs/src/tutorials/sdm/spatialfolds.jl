# # Spatial cross-validation

# In this tutorial, we will TK

using SpeciesDistributionToolkit
using CairoMakie
using Statistics
CairoMakie.activate!(; type = "png", px_per_unit = 2) #hide
import Random #hide
Random.seed!(123451234123121); #hide

# ## Getting the data

records = OccurrencesInterface.__demodata()
landmass = getpolygon(PolygonData(OpenStreetMap, Places); place = "Oregon")
records = Occurrences(mask(records, landmass))
spatial_extent = SpeciesDistributionToolkit.boundingbox(landmass)

# out

provider = RasterData(CHELSA2, BioClim)
L = SDMLayer{Float32}[
    SDMLayer(
        provider;
        layer = x,
        spatial_extent...,
    ) for x in eachindex(layers(provider))
];

mask!(L, landmass)

# We will generate pseudo-absences at random in a radius around each known
# observations. The distance between an observation and a pseudo-absence is
# between 40 and 130 km.

presencelayer = mask(first(L), records)
absencemask =
    pseudoabsencemask(BetweenRadius, presencelayer; closer = 40.0, further = 120.0)
absencelayer = backgroundpoints(absencemask, 2sum(presencelayer))

# Training on model v1

model = SDM(RawData, Logistic, L, presencelayer, absencelayer)
hyperparameters!(classifier(model), :interactions, :all)

# variogram for temperature

Lᵢ = L[1]
x, y, n = variogram(Lᵢ; samples = 5000)

#figure variogram-first
f = Figure()
ax = Axis(f[1, 1]; xlabel = "Distance (km)", ylabel = "Semivariance")
hlines!(ax, [var(Lᵢ)]; color = :grey40, linestyle = :dash)
scatter!(
    ax,
    x,
    y;
    markersize = n ./ maximum(n) .* 8 .+ 2,
    strokecolor = :black,
    color = :grey98,
    strokewidth = 1,
)
current_figure() #hide

# we tile the model observations

tiles = tessellate(model, 25.0; tile = :hexagons, pointy = true)

#figure initial-tiling
f = Figure()
ax = Axis(f[1, 1]; aspect = DataAspect())
poly!(ax, landmass; color = :grey98)
poly!(ax, intersect(tiles, landmass); color = :darkgreen, alpha = 0.1)
lines!(ax, intersect(tiles, landmass); color = :grey60)
scatter!(ax, presences(model); color = :darkgreen)
scatter!(ax, absences(model); color = :grey20, markersize = 4)
lines!(ax, landmass; color = :black)
current_figure() #hide

# we now assign the folds for cross validation

assignfolds!(tiles; n = 6, order = :balanced)

# check what the folds look like

#figure check-folds
f = Figure()
ax = Axis(f[1, 1]; aspect = DataAspect())
poly!(ax, landmass; color = :grey90)
colpal = Makie.wong_colors()[1:maximum(uniqueproperties(tiles)["__fold"])]
for k in uniqueproperties(tiles)["__fold"]
    poly!(ax, tiles["__fold" => k]; color = colpal[k], alpha = 0.3)
    for f in tiles["__fold" => k].features
        text!(
            ax,
            f.properties["__centroid"];
            text = string(f.properties["__fold"]),
            align = (:center, :center),
            color = colpal[k],
        )
    end
end
lines!(ax, tiles; color = :grey40)
current_figure() #hide

# this turns into folds

blockfolder = spatialfold(tiles)
folds = blockfolder(model)

# now we can cross-validate

spatial_cv = crossvalidate(model, folds)

# we get the value of the first variable by fold

fold_mean = byzone(mean, Lᵢ, tiles, "__fold")

# look at the results

#figure spatial-cv
f = Figure()
ax = Axis(f[1, 1]; ylabel = "MCC", xlabel = layers(provider)[1])
ax2 = Axis(f[1, 2])
_valstyle = (color = :white, strokewidth = 1, strokecolor = :darkgreen, markersize = 18)
_trnstyle = (
    color = :grey90,
    strokewidth = 1,
    strokecolor = :orange,
    markersize = 14,
    marker = :rect,
)
X = [fold_mean[i] for i in eachindex(folds)]
scatter!(ax, X, mcc.(spatial_cv.training); _trnstyle..., label = "Training")
scatter!(ax, X, mcc.(spatial_cv.validation); _valstyle..., label = "Validation")
errorbars!(
    ax2,
    [1],
    [mcc(spatial_cv.validation)],
    [0.5 * ci(spatial_cv.validation)];
    whiskerwidth = 12,
    color = :darkgreen,
)
scatter!(ax2, [1], [mcc(spatial_cv.validation)]; _valstyle...)
errorbars!(
    ax2,
    [2],
    [mcc(spatial_cv.training)],
    [0.5 * ci(spatial_cv.training)];
    whiskerwidth = 12,
    color = :orange,
)
scatter!(ax2, [2], [mcc(spatial_cv.training)]; _trnstyle...)
xlims!(ax2, 0, 3)
hidexdecorations!(ax2)
ylims!(ax, 0.5, 1)
ylims!(ax2, 0.5, 1)
colsize!(f.layout, 2, Relative(0.3))
axislegend(ax; position = :lt)
current_figure() #hide

# now we can look at output

# now we can check variables with these folds

variables!(model, ForwardSelection, folds; included = [1])

# beter model?

selection_cv = crossvalidate(model, folds)

#figure selection-cv
f = Figure()
ax = Axis(f[1, 1]; ylabel = "MCC", xlabel = layers(provider)[1])
ax2 = Axis(f[1, 2])
_valstyle = (color = :white, strokewidth = 1, strokecolor = :darkgreen, markersize = 18)
_trnstyle = (
    color = :grey90,
    strokewidth = 1,
    strokecolor = :orange,
    markersize = 14,
    marker = :rect,
)
X = [fold_mean[i] for i in eachindex(folds)]
scatter!(ax, X, mcc.(selection_cv.training); _trnstyle..., label = "Training")
scatter!(ax, X, mcc.(selection_cv.validation); _valstyle..., label = "Validation")
errorbars!(
    ax2,
    [1],
    [mcc(selection_cv.validation)],
    [0.5 * ci(selection_cv.validation)];
    whiskerwidth = 12,
    color = :darkgreen,
)
scatter!(ax2, [1], [mcc(selection_cv.validation)]; _valstyle...)
errorbars!(
    ax2,
    [2],
    [mcc(selection_cv.training)],
    [0.5 * ci(selection_cv.training)];
    whiskerwidth = 12,
    color = :orange,
)
scatter!(ax2, [2], [mcc(selection_cv.training)]; _trnstyle...)
xlims!(ax2, 0, 3)
hidexdecorations!(ax2)
ylims!(ax, 0.5, 1)
ylims!(ax2, 0.5, 1)
colsize!(f.layout, 2, Relative(0.3))
axislegend(ax; position = :lt)
current_figure() #hide

# table

# todo turn into PrettyTables

for i in eachindex(folds)
    @info i, mcc(spatial_cv.validation[i]), mcc(selection_cv.validation[i])
end

# make spatial prediction

P = predict(model, L; threshold = false)

#figure spatial-prediction
f = Figure()
ax = Axis(f[1, 1]; aspect = DataAspect())
heatmap!(
    ax,
    predict(model, L; threshold = false);
    colormap = Reverse(:navia),
    colorrange = (0, 1),
)
scatter!(ax, presences(model), color=:transparent, strokecolor=:orange, strokewidth=2)
current_figure() #hide

# look at prediction variogram

x, y, n = variogram(P; samples = 5000)

#figure variogram-output
f = Figure()
ax = Axis(f[1, 1]; xlabel = "Distance (km)", ylabel = "Semivariance")
hlines!(ax, [var(P)]; color = :grey40, linestyle = :dash)
scatter!(
    ax,
    x,
    y;
    markersize = n ./ maximum(n) .* 8 .+ 2,
    strokecolor = :black,
    color = :grey98,
    strokewidth = 1,
)
current_figure() #hide

# fit variogram
# {\displaystyle \gamma (h)=(s-n)(1-\exp(-h/(ra)))+n1_{(0,\infty )}(h).}

# sill, nugget, range
function expovar(a, v, n)
    __mod(h) = (1 - exp(-(3*h*h)/(a*a))) * (v - n) + n
    return __mod
end

f = expovar(550., 0.27, 0.002)

scatter(x, y)
vx = LinRange(0, 1.2*maximum(x), 50)
lines!(vx, f.(vx))
current_figure()
