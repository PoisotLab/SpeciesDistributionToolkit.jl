# # Using AdaBoost

# In this vignette, we will see how we can use AdaBoost to turn a mediocre model
# into a less mediocre one.

using SpeciesDistributionToolkit
const SDT = SpeciesDistributionToolkit
using CairoMakie
CairoMakie.activate!(; type = "png", px_per_unit = 3) #hide
import Random #hide
Random.seed!(123451234123121); #hide

# 

POL = getpolygon(PolygonData(OpenStreetMap, Places), place="Switzerland")
presences = GBIF.download("10.15468/dl.wye52h")

# get the spatial data

provider = RasterData(CHELSA2, BioClim)
L = SDMLayer{Float32}[
    SDMLayer(
        provider;
        layer = x,
        SDT.boundingbox(POL; padding=0.0)...,
    ) for x in 1:19
];

# mask 

mask!(L, POL);

# generate PA

presencelayer = mask(first(L), presences)
background = pseudoabsencemask(DistanceToEvent, presencelayer)
bgpoints = backgroundpoints(nodata(background, d -> (d < 5)|(d > 200)), 2sum(presencelayer))

# fig-data-position
fig = Figure()
ax = Axis(fig[1,1], aspect=DataAspect())
poly!(ax, POL, color=:grey90, strokewidth=1, strokecolor=:grey20)
scatter!(ax, presences, color=:black)
scatter!(ax, bgpoints, color=:grey50)
hidedecorations!(ax)
hidespines!(ax)
current_figure() #hide

# train a weak learner (bioclim)

# The BIOCLIM model [Booth2014](@cite) is one of the first SDM that was ever
# published. Because it is a climate envelope model (locations within the
# extrema of environmental variables for observed presences are assumed
# suitable, more or less), it does not usually give really good predictions.
# BIOCLIM underfits, and for this reason it is a good instance of a weak learner
# that we will attempt to improve through boosting.

sdm = SDM(RawData, NaiveBayes, L, presencelayer, bgpoints)
variables!(sdm, ForwardSelection; included=[1, 12])

# see variables

variables(sdm)

# make initial prediction with this model

prd = predict(sdm, L; threshold = false)

# plot now

# fig-bioclim-output
fg, ax, pl = heatmap(prd; colormap = :tempo, colorrange=(0,1))
ax.aspect = DataAspect()
hidedecorations!(ax)
hidespines!(ax)
lines!(ax, POL, color=:grey20)
#scatter!(ax, presences, color=:black)
#scatter!(ax, bgpoints, color=:grey50)
Colorbar(fg[1, 2], pl, height=Relative(0.6))
current_figure() #hide

# now setup the boosting

bst = AdaBoost(sdm; iterations = 100)
train!(bst)

# check the number of iterations and effect on weight

# fig-weights-iterative
scatterlines(bst.weights, color=:black)
current_figure() #hide

# look at cumulative weights, should plateau as we expect adaboost to minimize the loss exponentially fast

# fig-weights-cumsum
scatterlines(cumsum(bst.weights), color=:black)
current_figure() #hide


#-

brd = predict(bst, L)

#-

# fig-boosted-map
fg, ax, pl = heatmap(brd; colormap = :tempo, colorrange=(0, 1))
ax.aspect = DataAspect()
hidedecorations!(ax)
hidespines!(ax)
lines!(ax, POL, color=:grey20)
#scatter!(ax, presences, color=:black)
#scatter!(ax, bgpoints, color=:grey50)
Colorbar(fg[1, 2], pl, height=Relative(0.6))
current_figure() #hide

# difference of quantiles

# fig-quantile-diff
fg, ax, pl = heatmap(quantize(brd) - quantize(prd); colormap = Reverse(:balance), colorrange=(-0.5, 0.5))
ax.aspect = DataAspect()
hidedecorations!(ax)
hidespines!(ax)
lines!(ax, POL, color=:grey20)
Colorbar(fg[1, 2], pl, height=Relative(0.6))
current_figure() #hide

# test with partial response

# fig-response-boosted
fig = Figure()
ax = Axis(fig[1,1]; aspect=1)
lines!(ax, partialresponse(sdm, 1; threshold=false)..., label="Base model", linestyle=:dash, color=:grey)
lines!(ax, partialresponse(bst, 1)..., label="AdaBoost", color=:black, linewidth=2)
Legend(fig[1,2], ax)
current_figure() #hide

# find a threshold?

yhat = predict(bst; threshold=false)

T = LinRange(extrema(yhat)..., 1000)
C = zeros(ConfusionMatrix, length(T))

for i in eachindex(T)
    C[i] = ConfusionMatrix(yhat, labels(bst), T[i])
end

# now plot the learning curve for the threshold

# fig-response-curve
lines(T, mcc.(C))
current_figure() #hide

# what is the threshold

thr = T[last(findmax(mcc.(C)))]

# get the ranges with base/boosted model

rbst = brd .>= thr
rsdm = predict(sdm, L)

# and plot the difference

# fig-gainloss-boosting
fg, ax, pl = heatmap(gainloss(rsdm, rbst); colormap = [:red, :tan, :black], colorrange=(-1, 1))
ax.aspect = DataAspect()
hidedecorations!(ax)
hidespines!(ax)
#contour!(rbst, color=:firebrick, linewidth=0.5)
lines!(ax, POL, color=:grey20)
#scatter!(ax, presences, color=:purple, markersize=5)
#scatter!(ax, bgpoints)
current_figure() #hide
