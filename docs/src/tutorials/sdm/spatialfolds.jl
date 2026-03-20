# # Spatial cross-validation

# In this tutorial, we will TK

using SpeciesDistributionToolkit
using CairoMakie
using PrettyTables
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

model = SDM(PCATransform, Logistic, L, presencelayer, absencelayer);
hyperparameters!(classifier(model), :interactions, :self);

# variogram for temperature

Lᵢ = L[1]
x, y, n = variogram(Lᵢ; width=15., shift=3.)

#figure variogram-first
f = Figure()
ax = Axis(f[1, 1]; xlabel = "Distance (km)", ylabel = "Semivariogram")
hlines!(ax, [var(Lᵢ)]; color = :grey40, linestyle = :dash)
scatter!(
    ax,
    x,
    y;
    markersize = n ./ maximum(n) .* 8 .+ 2,
    color = :grey55,
)
xlims!(ax; low = 0.0)
ylims!(ax, 0.0, quantile(y, 0.95))
current_figure() #hide

# note that with an unexported function

vario = SpeciesDistributionToolkit.fitvariogram(x, y, n; family = :gaussian)

#figure variogram-first-with-fit
vx = LinRange(extrema(x)..., 100)
lines!(ax, vx, vario.model.(vx); color = :orange, linewidth = 2, alpha = 0.6)
current_figure() #hide

# this gives a range of approx (in km)

vario.range

# we can also check the sill

vario.sill

# and compare to layer variance

var(Lᵢ)

# and check the base amount of autocorrelation for close points

vario.nugget

# we tile the model observations - ideally would be done for a surface
# corresponding to the range in the variogram but here, too large

tiles = tessellate(model, 20.0; tile = :hexagons, pointy = true)

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

assignfolds!(tiles; n = 5, order = :random)

# check what the folds look like

#figure check-folds
f = Figure()
ax = Axis(f[1, 1]; aspect = DataAspect())
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

cv_res = [
    [
        i,
        mcc(spatial_cv.training[i]),
        mcc(spatial_cv.validation[i]),
        mcc(selection_cv.training[i]),
        mcc(selection_cv.validation[i]),
        mcc(selection_cv.validation[i]) > mcc(spatial_cv.validation[i]) ? "↑" : "↓",
    ] for i in 1:length(spatial_cv.validation)
];

# this is the result as a table - see that variable selection makes cross-validation better

pretty_table(
    permutedims(hcat(cv_res...));
    alignment = [:l, :c, :c, :c, :c, :c],
    backend = :markdown,
    column_labels = ["Fold", "Train.", "Val.", "Train. + sel.", "Val. + sel.", "Trend"],
    formatters = [fmt__printf("%5.3f", [2, 3, 4, 5])],
)

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
scatter!(ax, presences(model); color = :transparent, strokecolor = :orange, strokewidth = 2)
current_figure() #hide

# tile by any shape we want, for example this is prediction aggregated in
# triangular cells

#figure tessellated-prediction
f = Figure()
ax = Axis(f[1, 1]; aspect = DataAspect())
newtiles = tessellate(P, 20.0; tile = :triangles)
heatmap!(
    ax,
    mosaic(mean, P, newtiles, "__centroid");
    colormap = Reverse(:navia),
    colorrange = (0, 1),
)
lines!(ax, landmass; color = :black)
current_figure() #hide
