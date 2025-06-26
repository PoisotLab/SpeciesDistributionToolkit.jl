# # Boosting and calibrating a probabilistic classifier

# In this vignette, we will see how we can use AdaBoost to turn a mediocre model
# into a less mediocre one.

using SpeciesDistributionToolkit
const SDT = SpeciesDistributionToolkit
using CairoMakie
CairoMakie.activate!(; type = "png", px_per_unit = 3) #hide
import Random #hide
Random.seed!(123451234123121); #hide

# We work on the same data as for the previous SDM tutorials:

POL = getpolygon(PolygonData(OpenStreetMap, Places), place="Switzerland")
presences = GBIF.download("10.15468/dl.wye52h")
provider = RasterData(CHELSA2, BioClim)
L = SDMLayer{Float32}[
    SDMLayer(
        provider;
        layer = x,
        SDT.boundingbox(POL; padding=0.0)...,
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
ax = Axis(fig[1,1], aspect=DataAspect())
poly!(ax, POL, color=:grey90, strokewidth=1, strokecolor=:grey20)
scatter!(ax, presences, color=:black, markersize=6)
scatter!(ax, bgpoints, color=:grey50, markersize=4)
hidedecorations!(ax)
hidespines!(ax)
current_figure() #hide

# Before building the boosting model, we need to construct a weak learner.

# The BIOCLIM model [Booth2014](@cite) is one of the first SDM that was ever
# published. Because it is a climate envelope model (locations within the
# extrema of environmental variables for observed presences are assumed
# suitable, more or less), it does not usually give really good predictions.
# BIOCLIM underfits, and for this reason it is also a good candidate for
# boosting. Naive Bayes classifiers are similarly suitable for AdaBoost: they
# tend to achieve a good enough performance in aggregate, but due to the way
# they learn from the data, they rarely excel at any single prediction.

# The traditional lore is that AdaBoost should be used only with really weak
# classifiers, but [Wyner2017](@citet) have convincing arguments in favor of
# treating it more like a random forest, by showing that it also works with
# comparatively stronger learners. In keeping with this idea, we will train a
# moderately deep tree as our base classifier.

sdm = SDM(RawData, DecisionTree, L, presencelayer, bgpoints)
hyperparameters!(classifier(sdm), :maxdepth, 4)
hyperparameters!(classifier(sdm), :maxnodes, 4)

# This tree is not quite a decision stump (a one-node tree), but they are
# relatively small, so a single one of them is unlikely to give a good
# prediction. We can train the model and generate the initial prediction:

train!(sdm)
prd = predict(sdm, L; threshold = false)

# As expected, although it roughly identifies the range of the species, it is
# not doing a spectacular job at it. This model is a good candidate for
# boosting.

# fig-bioclim-output
fg, ax, pl = heatmap(prd; colormap = :tempo, colorrange=(0,1))
ax.aspect = DataAspect()
hidedecorations!(ax)
hidespines!(ax)
lines!(ax, POL, color=:grey20)
Colorbar(fg[1, 2], pl, height=Relative(0.6))
current_figure() #hide

# To train this model using the AdaBoost algorithm, we wrap it into an
# `AdaBoost` object, and specify the number of iterations (how many learners we
# want to train). The default is 50.

bst = AdaBoost(sdm; iterations=60)

# Training the model is done in the exact same way as other `SDeMo` models, with
# one important exception. AdaBoost uses the predicted class (presence/absence)
# internally, so we will always train learners to return a thresholded
# prediction. For this reason, even it the `threshold` argument is used, it will
# be ignored during training.

train!(bst)

# We can look at the weight (*i.e.* how much a weak learner is trusted during
# the final prediction) over time. It should decrease, and more than that, it
# should ideally decrease fast (exponentially). Some learners may have a
# negative weight, which means that they are consistently wrong. These are
# counted by flipping their prediction in the final recommendation.

# fig-weights-iterative
scatterlines(bst.weights, color=:black)
current_figure() #hide

# Models with a weight of 0 are not contributing new information to the model.
# These are expecteed to become increasingly common at later iterations, so it
# is a good idea to examine the cumulative weights to see whether we get close
# to a plateau.

# fig-weights-cumsum
scatterlines(cumsum(bst.weights), color=:black)
current_figure() #hide

# This is close enough. We can now apply this model to the bioclimatic
# variables:

brd = predict(bst, L; threshold=false)

# This gives the following map:

# fig-boosted-map
fg, ax, pl = heatmap(brd; colormap = :tempo, colorrange=(0, 1))
ax.aspect = DataAspect()
hidedecorations!(ax)
hidespines!(ax)
lines!(ax, POL, color=:grey20)
Colorbar(fg[1, 2], pl, height=Relative(0.6))
current_figure() #hide

# The scores returned by the boosted model are not calibrated probabilities, so
# they are centered on 0.5, but have typically low variance. This can be
# explained by the fact that each component models tends to make one-sided
# errors near 0 and 1, wich accumulate with more models over time. This is
# pretty obvious from lookin at the histogram of the results:

# fig-hist-boostpred
hist(brd, color=:grey)
hideydecorations!()
hidexdecorations!(current_axis(); ticks=false, ticklabels=false)
hidespines!(current_axis(), :l)
hidespines!(current_axis(), :r)
hidespines!(current_axis(), :t)
xlims!(0, 1)
tightlimits!(current_axis())
current_figure() #hide

# We can also look at the reliability curve for this model:

# fig-reliability-part-one
f = Figure()
ax = Axis(f[1,1], aspect=1, xlabel="Average prediction", ylabel="Average empirical probability")
lines!(ax, [0,1], [0,1], color=:grey, linestyle=:dash)
xlims!(ax, 0, 1)
ylims!(ax, 0, 1)
scatterlines!(ax, SDeMo.reliability(predict(bst; threshold=false), labels(sdm))..., color=:black)
current_figure() #hide

# In order to turn this score into a value that is closer to a probability, we
# can estimate a calibration function for this model:

cal = SDeMo.calibration(bst);

# This step uses the [Platt1999](@citet) scaling approach, where the outputs
# from the model are regressed against the true class probabilities, to attempt
# to bring the model prediction more in line with true probabilities
# [Niculescu-Mizil2005](@cite). Internally, the package uses the fast and robust
# algorithm of [Lin2007](@citet).

# ::: warning Experimental API
# 
# The `reliability` and `calibration` methods are currently not exported, which
# means that they are very likely to change in the future, and are not
# guaranteed to be stable.
# 
# :::

# It is a good idea to check that the calibration function is indeed bringing us
# closer to the 1:1 line, which is to say that it provides us with a score that
# is closer to a true probability.

# fig-reliability-part-two
scatterlines!(ax, SDeMo.reliability(cal(predict(bst; threshold=false)), labels(sdm))..., color=:red)
current_figure() #hide

# Of course the calibration function can be applied to a layer, so we can now
# use AdaBoost to estimate the probability of species presence.
# [Dormann2020](@citet) has several strong arguments in favor of this approach.

# fig-boosted-proba
fg, ax, pl = heatmap(cal(brd); colormap = :tempo, colorrange=(0, 1))
ax.aspect = DataAspect()
hidedecorations!(ax)
hidespines!(ax)
lines!(ax, POL, color=:grey20)
Colorbar(fg[1, 2], pl, height=Relative(0.6))
current_figure() #hide

# Note that the calibration is not required to obtain a binary map, as the
# transformation applied to the scores is monotonous. For this reason, the
# AdaBoost function will internally work on the raw scores, and turn them into
# binary predictions using thresholding.

# The default threshold for `AdaBoost` is 0.5, which is explained by the fact
# that the final decision step is a weighted voting based on the sum of all weak
# learners. We can get the predicted range under both models:

sdm_range = predict(sdm, L)
bst_range = predict(bst, L)

# We now plot the difference, where the areas gained by boosting are in red, and
# the areas lost by boosting are in light grey. The part of the range that is
# conserved is in black.

# fig-gainloss-boosting
fg, ax, pl = heatmap(gainloss(sdm_range, bst_range); colormap = [:firebrick, :grey10, :grey75], colorrange=(-1, 1))
ax.aspect = DataAspect()
hidedecorations!(ax)
hidespines!(ax)
lines!(ax, POL, color=:grey20)
current_figure() #hide

# ## References

# ```@bibliography
# Pages = [@__FILE__]
# Style = :authoryear
# ```