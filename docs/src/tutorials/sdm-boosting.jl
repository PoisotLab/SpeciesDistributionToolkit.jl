# # Creating a landcover consensus map

# In this vignette, we will yada yada

using SpeciesDistributionToolkit
const SDT = SpeciesDistributionToolkit
using CairoMakie
CairoMakie.activate!(; type = "png", px_per_unit = 3) #hide
import Random #hide
Random.seed!(123451234123121); #hide

# 

POL = getpolygon(PolygonData(OpenStreetMap, Places), place="Switzerland")
presences = GBIF.download("10.15468/dl.wye52h");

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

mask!(L, POL)

# generate PA

presencelayer = mask(first(L), presences)
background = pseudoabsencemask(DistanceToEvent, presencelayer)
bgpoints = backgroundpoints(nodata(background, d -> d < 4), 2sum(presencelayer))

# train a weak learner using NBC

sdm = SDM(ZScore, BIOCLIM, L, presencelayer, bgpoints)
variables!(sdm, BackwardSelection)
train!(sdm)
variables(sdm)

# make initial prediction with this model

prd = predict(sdm, L; threshold = false)

# plot now

fg, ax, pl = heatmap(prd; colormap = :tempo)
ax.aspect = DataAspect()
hidedecorations!(ax)
hidespines!(ax)
lines!(ax, POL, color=:grey20)
scatter!(ax, presencelayer; color = :orange, markersize=4)
Colorbar(fg[1, 2], pl)
current_figure()

# now setup the boosting

bst = AdaBoost(sdm; iterations = 60)
train!(bst)

# check the number of iterations and effect on weight

scatterlines(bst.weights, color=:black)

#-

brd = predict(bst, L)

#-

fg, ax, pl = heatmap(brd; colormap = :tempo, colorrange=(0, 1))
ax.aspect = DataAspect()
hidedecorations!(ax)
hidespines!(ax)
lines!(ax, POL, color=:grey20)
scatter!(ax, presencelayer; color = :orange, markersize=5)
Colorbar(fg[1, 2], pl, height=Relative(0.6))
current_figure()

# difference of quantiles

fg, ax, pl = heatmap(quantize(brd) - quantize(prd); colormap = Reverse(:balance), colorrange=(-0.15, 0.15))
ax.aspect = DataAspect()
hidedecorations!(ax)
hidespines!(ax)
lines!(ax, POL, color=:grey20)
Colorbar(fg[1, 2], pl, height=Relative(0.6))
current_figure()

# 
v = rand(variables(sdm))
lines(partialresponse(bst, v)...)
lines!(partialresponse(sdm, v; threshold=false)...)
current_figure()

#

yhat = predict(bst; threshold=false)

T = LinRange(0.0, 1.0, 1000)
C = zeros(ConfusionMatrix, length(T))

for i in eachindex(T)
    C[i] = ConfusionMatrix(yhat, labels(bst), T[i])
end

lines(T, mcc.(C))

#-

thr = T[last(findmax(mcc.(C)))]

rbst = brd .>= thr
rsdm = predict(sdm, L)

#

fg, ax, pl = heatmap(gainloss(rsdm, rbst); colormap = [:firebrick, :tan, :black], colorrange=(-1, 1))
ax.aspect = DataAspect()
hidedecorations!(ax)
hidespines!(ax)
contour!(rbst, color=:firebrick, linewidth=0.5)
lines!(ax, POL, color=:grey20)
current_figure()
