using Revise
using CairoMakie
using SpeciesDistributionToolkit
const SDT = SpeciesDistributionToolkit
using Statistics

POL = getpolygon(PolygonData(OpenStreetMap, Places); place = "Switzerland")
presences = GBIF.download("10.15468/dl.wye52h")
provider = RasterData(CHELSA2, BioClim)
L = SDMLayer{Float32}[
    SDMLayer(
        provider;
        layer = x,
        SDT.boundingbox(POL; padding = 0.0)...,
    ) for x in 1:19
];
mask!(L, POL)

# We generate some pseudo-absence data:

presencelayer = mask(first(L), presences)
background = pseudoabsencemask(DistanceToEvent, presencelayer)
bgpoints = backgroundpoints(nodata(background, d -> d < 4), 2sum(presencelayer))

# This is the dataset we start from:

# fig-data-position
fig = Figure()
ax = Axis(fig[1, 1]; aspect = DataAspect())
poly!(ax, POL; color = :grey90, strokewidth = 1, strokecolor = :grey20)
scatter!(ax, presences; color = :black, markersize = 6)
scatter!(ax, bgpoints; color = :grey50, markersize = 4)
hidedecorations!(ax)
hidespines!(ax)
current_figure() #hide

# model

sdm = Bagging(SDM(RawData, NaiveBayes, L, presencelayer, bgpoints), 20)
bagfeatures!(sdm)
train!(sdm)

# output predictions

hist(predict(sdm; threshold = false))
xlims!(0, 1)
current_figure()

# calibration curve

yhat = predict(sdm; threshold = false)
C = labels(sdm)

function reliability(yhat, y; bins=11)
    cutoffs = LinRange(extrema(yhat)..., bins)
    avgpred = zeros(bins-1)
    avgactu = zeros(bins-1)
    for i in eachindex(avgpred)
        inbin = findall(x -> cutoffs[i] < x <= cutoffs[i+1], yhat)
        avgpred[i] = mean(yhat[inbin])
        avgactu[i] = mean(y[inbin])
    end
    return (avgpred, avgactu)
end

lines([0, 1], [0, 1]; color = :grey, linestyle = :dash)
scatterlines!(reliability(yhat, C)...)
current_figure()

heatmap(predict(sdm, L; threshold=false))

cal = SDeMo.calibration(sdm)
heatmap(cal(predict(sdm, L; threshold=false)))

scatter(predict(sdm; threshold=false), cal(predict(sdm; threshold=false)))
xlims!(0, 1)
ylims!(0, 1)
current_figure()

lines([0, 1], [0, 1]; color = :grey, linestyle = :dash)
scatterlines!(reliability(yhat, C; bins=9)...)
scatterlines!(reliability(cal(yhat), C; bins=9)...)
current_figure()

rpred = predict(sdm, L; threshold=false)
heatmap(rpred, colormap=:tempo, colorrange=(0, 1))

cpred = 1.0 ./ (1.0 .+ exp.(A .* rpred .+ B))
heatmap(cpred, colormap=:tempo, colorrange=(0, 1))
scatter!(presences, color=:orange, alpha=0.4, markersize=7)
current_figure()