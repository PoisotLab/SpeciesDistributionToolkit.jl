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

POL = getpolygon(PolygonData(OpenStreetMap, Places), place="Paraguay")
presences = GBIF.download("10.15468/dl.d3cxpr")

# get the spatial data

bio_vars = 1:19
provider = RasterData(CHELSA2, BioClim)
L = SDMLayer{Float32}[
    SDMLayer(
        provider;
        layer = x,
        SDT.boundingbox(POL; padding=0.0)...,
    ) for x in bio_vars
];

# mask 

mask!(L, POL);

# generate PA

presencelayer = mask(first(L), presences)
background = pseudoabsencemask(DistanceToEvent, presencelayer)
bgpoints = backgroundpoints(nodata(background, d -> (d < 20)|(d > 300)), 2sum(presencelayer))

# train a weak learner (bioclim)

# The BIOCLIM model [Booth2014](@cite) is one of the first SDM that was ever
# published. Because it is a climate envelope model (locations within the
# extrema of environmental variables for observed presences are assumed
# suitable, more or less), it does not usually give really good predictions.
# BIOCLIM underfits, and for this reason it is a good instance of a weak learner
# that we will attempt to improve through boosting.

sdm = SDM(RawData, NaiveBayes, L, presencelayer, bgpoints)
variables!(sdm, BackwardSelection)

# make initial prediction with this model

prd = predict(sdm, L; threshold = false)

# plot now

# fig-bioclim-output
fg, ax, pl = heatmap(prd; colormap = :tempo)
ax.aspect = DataAspect()
hidedecorations!(ax)
hidespines!(ax)
lines!(ax, POL, color=:grey20)
scatter!(ax, presencelayer; color = :orange, markersize=4)
Colorbar(fg[1, 2], pl)
current_figure() #hide

# now setup the boosting

bst = AdaBoost(sdm; iterations = 40)
train!(bst)

# check the number of iterations and effect on weight

scatterlines(bst.weights, color=:black)

#-

brd = predict(bst, L)

#-

# fig-boosted-map
fg, ax, pl = heatmap(brd; colormap = :tempo, colorrange=(0, 1))
ax.aspect = DataAspect()
hidedecorations!(ax)
hidespines!(ax)
lines!(ax, POL, color=:grey20)
scatter!(ax, presencelayer; color = :orange, markersize=5)
Colorbar(fg[1, 2], pl, height=Relative(0.6))
current_figure() #hide

# difference of quantiles

# fig-quantile-diff
fg, ax, pl = heatmap(quantize(brd) - quantize(prd); colormap = Reverse(:balance), colorrange=(-0.15, 0.15))
ax.aspect = DataAspect()
hidedecorations!(ax)
hidespines!(ax)
lines!(ax, POL, color=:grey20)
Colorbar(fg[1, 2], pl, height=Relative(0.6))
current_figure() #hide

#-

v = rand(variables(sdm))

#-

# fig-response-boosted
lines(partialresponse(bst, v)...)
lines!(partialresponse(sdm, v; threshold=false)...)
current_figure() #hide
#

yhat = predict(bst; threshold=false)

T = LinRange(0.0, 1.0, 1000)
C = zeros(ConfusionMatrix, length(T))

for i in eachindex(T)
    C[i] = ConfusionMatrix(yhat, labels(bst), T[i])
end

# fig-response-curve
lines(T, mcc.(C))
current_figure() #hide

#-

thr = T[last(findmax(mcc.(C)))]

rbst = brd .>= thr
rsdm = predict(sdm, L)

#

# fig-gainloss-boosting
fg, ax, pl = heatmap(gainloss(rsdm, rbst); colormap = [:firebrick, :tan, :black], colorrange=(-1, 1))
ax.aspect = DataAspect()
hidedecorations!(ax)
hidespines!(ax)
contour!(rbst, color=:firebrick, linewidth=0.5)
lines!(ax, POL, color=:grey20)
scatter!(ax, presences)
scatter!(ax, bgpoints)
current_figure() #hide
