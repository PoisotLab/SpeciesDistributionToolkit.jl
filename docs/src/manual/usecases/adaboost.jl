# # Boosting and calibrating a probabilistic classifier

# In this vignette, we will see how we can use AdaBoost to turn a mediocre model
# into a less mediocre one.

using SpeciesDistributionToolkit
const SDT = SpeciesDistributionToolkit
using CairoMakie

# ## Data preparation

# We will use the demonstration data, and setup a simple decision tree. We will
# refine its hyper-parameters later on.

aoi = getpolygon(PolygonData(OpenStreetMap, Places); place = "Corse")
provider = RasterData(CHELSA2, BioClim)
L = SDMLayer{Float32}[
    SDMLayer(
        provider;
        layer = x,
        SDT.boundingbox(aoi)...,
    ) for x in 1:19
];
mask!(L, aoi)

# ::: info Fundamental of model use
#
# There is a vignette on [declaring, training, and using
# models](/manual/sdm/pipeline/), which covers a lot of ground that will help
# make sense of the syntax.
#
# :::

model = SDM(RawData, DecisionTree, SDeMo.__demodata()...)

# This is the dataset we start from:

#figure data-position
fig = Figure()
ax = Axis(fig[1, 1]; aspect = DataAspect())
poly!(ax, aoi; color = :grey90, strokewidth = 1, strokecolor = :grey20)
scatter!(ax, presences(model); color = :black, markersize = 6)
scatter!(ax, absences(model); color = :grey50, markersize = 4)
hidedecorations!(ax)
hidespines!(ax)
current_figure() #hide

# ## Initial model

# Before building the boosting model, we need to construct a weak learner.

# The BIOCLIM model [booth2014bioclim](@cite) is one of the first SDM that was
# ever published. Because it is a climate envelope model (locations within the
# extrema of environmental variables for observed presences are assumed
# suitable, more or less), it does not usually give really good predictions.
# BIOCLIM underfits, and for this reason it is also a good candidate for
# boosting. Naive Bayes classifiers are similarly suitable for AdaBoost: they
# tend to achieve a good enough performance in aggregate, but due to the way
# they learn from the data, they rarely excel at any single prediction.

# The traditional lore is that AdaBoost should be used only with really weak
# classifiers, but [wyner2017explaining](@citet) have convincing arguments in
# favor of treating it more like a random forest, by showing that it also works
# with comparatively stronger learners. In keeping with this idea, we will train
# a moderately deep tree as our base classifier.

hyperparameters!(classifier(model), :maxdepth, 4)
hyperparameters!(classifier(model), :maxnodes, 4)

# ::: tip Decision stumps
#
# using a maximum depth of 1 and a maximum nodes of 2 would turn this model into
# a decision stump, which is a very interesting type of classifier that relies
# on stacking many mediocre predictions into an often surprisingly good one.
#
# :::

# This tree is not quite a decision stump (a one-node tree), but they are
# relatively small, so a single one of them is unlikely to give a good
# prediction. We can train the model and generate the initial prediction:

train!(model)
prd = predict(model, L; threshold = false)

# As expected, although it roughly identifies the range of the species, it is
# not doing a spectacular job at it. This model is a good candidate for
# boosting.

#figure bioclim-output
f = Figure()
ax = Axis(f[1,1]; aspect=DataAspect())
hm = heatmap!(ax, prd; colormap = :tempo, colorrange = (0, 1))
lines!(ax, aoi; color = :grey20)
hidedecorations!(ax)
hidespines!(ax)
Colorbar(f[1, 2], hm; height = Relative(0.6))
current_figure() #hide

# ## Boosting

# To train this model using the AdaBoost algorithm, we wrap it into an
# `AdaBoost` object, and specify the number of iterations (how many learners we
# want to train). The default is 50.

bst = AdaBoost(model; iterations = 60)

# We will decrease the learning rate of this model a little bit:

hyperparameters!(bst, :η, 0.9)

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

#figure weights-iterative
scatterlines(bst.weights; color = :black)
current_figure() #hide

# Models with a weight of 0 are not contributing new information to the boosted
# model. These are expected to become increasingly common at later iterations,
# so it is a good idea to examine the cumulative weights to see whether we get
# close to a plateau.

#figure weights-cumsum
scatterlines(cumsum(bst.weights); color = :black)
current_figure() #hide

# This is close enough. We can now apply this model to the bioclimatic
# variables:

brd = predict(bst, L; threshold = false)

# This gives the following map:

#figure boosted-map
f = Figure()
ax = Axis(f[1,1]; aspect=DataAspect())
hm = heatmap!(ax, brd; colormap = :tempo, colorrange = (0, 1))
lines!(ax, aoi; color = :grey20)
hidedecorations!(ax)
hidespines!(ax)
Colorbar(f[1, 2], hm; height = Relative(0.6))
current_figure() #hide

# ## Calibration

# The scores returned by the boosted model are not calibrated probabilities, so
# they are centered on 0.5, but have typically low variance. This can be
# explained by the fact that each component models tends to make one-sided
# errors near 0 and 1, wich accumulate with more models over time. This problem
# is typically more serious when adding multiple classifiers together, as with
# bagging and boosting. Some classifiers tend to exagerate the proportion of
# extreme values (Naive Bayes classifiers, for example), some others tend to
# create peaks near values slightly above 0 and below 1 (tree-based methods),
# while methods like logistic regression typically do a fair job at predicting
# probabilities.

# The type of bias that a classifier accumulates is usually pretty obvious from
# looking at the histogram of the results:

#figure hist-boostpred
f = Figure(; size = (600, 300))
ax = Axis(f[1, 1]; xlabel = "Predicted score")
hist!(ax, brd; color = :lightgrey, bins = 30)
hideydecorations!(ax)
hidexdecorations!(ax; ticks = false, ticklabels = false)
hidespines!(ax, :l)
hidespines!(ax, :r)
hidespines!(ax, :t)
xlims!(ax, 0, 1)
tightlimits!(ax)
current_figure() #hide

# Here, we see that the predictions are starting to cluster away from 0 and 1,
# and converge onto about one half. This is not a problem when thinking about
# the species _range_, because the thresholding will account for this; but it is
# a problem when thinking about the predicted score.

# We can also look at the reliability curve for this model. The reliability
# curve divides the predictions into bins, and compares the average score on the
# training data to the proportion of events in the training data. When these two
# quantities are almost equal, the score outputed by the model is a good
# prediction of the probability of the event.

#figure reliability-part-one
f = Figure()
ax = Axis(
    f[1, 1];
    aspect = 1,
    xlabel = "Average predicted probability",
    ylabel = "Average empirical probability",
)
lines!(ax, [0, 1], [0, 1]; color = :grey, linestyle = :dash)
xlims!(ax, 0, 1)
ylims!(ax, 0, 1)
scatterlines!(ax, SDeMo.reliability(bst)...; color = :black, label = "Raw scores")
current_figure() #hide

# Based on the reliability curve, it is clear that the model outputs are not
# probabilities; otherwise, they would lay on the 1:1 line. In order to turn
# these scores into a value that are closer to probabilities, we can estimate
# calibration parameters for this model:

C = calibrate(bst)

# This step uses the [platt1999probabilistic](@citet) scaling approach, where
# the outputs from the model are regressed against the true class probabilities,
# to attempt to bring the model prediction more in line with true probabilities
# [niculescu-mizil2005obtaining](@cite). Internally, the package uses the fast
# and robust algorithm of [lin2007note](@citet).

# These parameters can be turned into a correction function:

f = correct(C)

# It is a good idea to check that the calibration function is indeed bringing us
# closer to the 1:1 line, which is to say that it provides us with a score that
# is closer to a true probability.

#figure reliability-part-two
scatterlines!(
    ax,
    SDeMo.reliability(bst; link = f)...;
    color = :blue,
    marker = :rect,
    label = "Calibrated (Platt)",
)
axislegend(ax; position = :lt)
current_figure() #hide

# This calibration function is not quite right for this problem, so we
# can switch to the more flexible method of isotonic calibration:

C = calibrate(IsotonicCalibration, bst)
calfunc = correct(C)

#figure reliability-part-three
scatterlines!(
    ax,
    SDeMo.reliability(bst; link = calfunc)...;
    color = :orange,
    marker = :rect,
    label = "Calibrated (isotonic)",
)
axislegend(ax; position = :lt)
current_figure() #hide

# This gives a much better result, and so we will use this calibration function
# to return the probability prediction.

# ## Predicting probabilities

# Of course the calibration function can (like any other function) be applied to
# a layer, so we can now use AdaBoost to estimate the probability of species
# presence. [dormann2020calibration](@citet) has several strong arguments in
# favor of this approach.

#figure boosted-proba
f = Figure()
ax = Axis(f[1,1]; aspect=DataAspect())
hm = heatmap!(ax, calfunc.(brd); colormap = :tempo, colorrange = (0, 1))
lines!(ax, aoi; color = :grey20)
hidedecorations!(ax)
hidespines!(ax)
Colorbar(f[1, 2], hm; height = Relative(0.6))
current_figure() #hide

# Note that the calibration is not required to obtain a binary map, as the
# transformation applied to the scores is monotonous. For this reason, the
# AdaBoost function will internally work on the raw scores, and turn them into
# binary predictions using thresholding.

# The default threshold for `AdaBoost` is 0.5, which is explained by the fact
# that the final decision step is a weighted voting based on the sum of all weak
# learners. We can get the predicted range under both models:

sdm_range = predict(model, L)
bst_range = predict(bst, L)

# We now plot the difference, where the areas gained by boosting are in green,
# and the areas lost by boosting are in light grey. The part of the range that
# is conserved is in black.

#figure gainloss-boosting
fg, ax, pl = heatmap(
    gainloss(sdm_range, bst_range);
    colormap = [:forestgreen, :grey10, :grey75],
    colorrange = (-1, 1),
)
ax.aspect = DataAspect()
hidedecorations!(ax)
hidespines!(ax)
lines!(ax, aoi; color = :grey20)
current_figure() #hide

# ## Related documentation

# ```@meta
# CollapsedDocStrings = true
# ```

# ```@docs; canonical=false
# AdaBoost
# calibrate
# correct
# SDeMo.reliability
# ```

# ## References

# ```@bibliography
# Pages = [@__FILE__]
# Style = :authoryear
# ```