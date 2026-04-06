# # Getting started: our first model

# In this tutorial, we will work on a dataset of observations of the Ring Ouzel
# (_Turdus torquatus_) in Switzerland. The purpose of the tutorial is to
# introduce most of the concepts that are important when working with
# `SpeciesDistributionToolkit`, by conducting an analysis from start to finish.
# We are very much going for breadth, not depth; in particular, this tutorial
# does not cover any of the theory about species distributions or species
# distribution models.

# At many points throughout the tutorial, there will be links to other vignettes
# in this manual. They are not meant to be read immediately when they are
# mentionned, but rather consulted later on to get access to more options and
# choices for the analyses that are presented here.

using SpeciesDistributionToolkit
using Statistics
using PrettyTables

# ::: info About this tutorial
# 
# This tutorial is inspired by the [the excellent introduction to SDMs by
# Damaris Zurell](https://damariszurell.github.io/SDM-Intro/). It uses the same
# species, but a slightly different dataset.
#
# :::

# Most of the data types in `SpeciesDistributionToolkit` can be used with
# [`Makie`](https://docs.makie.org/stable/) for plotting. This is true for
# [layers](/manual/dataviz/layers/), [polygons](/manual/dataviz/polygons/), and
# more. These are all documented in the "Manual" section of the documentation,
# under "Data visualization". To benefit from this integration, we will load the
# `CairoMakie` backend.

using CairoMakie

# As in the rest of the manual, the code to produce the figures is hidden at
# first. This is because figure code is very verbose, and not specific to the
# package. Feel free to reveal the code for the figure if you want to see
# exactly how they are produced.

# ## Getting the data

# We start by downloading a polygon that will be used to delineate our area of
# interest. For this tutorial, this will be the country of Szwitzerland.

aoi = getpolygon(PolygonData(NaturalEarth, Countries); resolution = 10)["Switzerland"]

# There are several polygon providers that come built into the package, and they
# can be accessed _via_ the "Datasets" menu in the navigation bar at the top of
# your screen. Some of these polyon providers are about administrative
# boundaries (GADM, Natural Earth, ESRI), but some others are about
# eco/bioregions.

# To ensure that we only load the raster data that are within the range of our
# problem, we will first calculate the spatial extent of the polygon we just
# downloaded. The `boundingbox` function will work on any object that has
# spatial coordinates (occurrences, models, layers, etc), and return the
# bounding box in longitude/latitude.

const SDT = SpeciesDistributionToolkit
extent = SDT.boundingbox(aoi)

# ::: tip Alias for packages
#
# Whenever the names of functions in `SpeciesDistributionToolkit` are not
# distinctive enough, the functions are not exported. In order to simplify the
# syntax, declaring a `const` with a shorted name (as we did just before) is a
# valid solution, and also introduces no performance cost. This will happen in
# almost all vignettes.
#
# :::

# We will now download the entire suite of 19 BIOCLIM data from the
# [CHELSA2](/datasets/CHELSA2) database. Before downloading, we will look at the
# first five layers.

chelsa_bioclim = RasterData(CHELSA2, BioClim)
layers(chelsa_bioclim)[1:5]

# We can also get their full-text descriptions:

[
    layerdescriptions(chelsa_bioclim)[l]
    for l in layers(chelsa_bioclim)[1:5]
]

# We have enough information to download these layers, and load them in memory.
# It is important, whenever possible, to give a spatial extent (boundingbox) to
# the function to read layers. This avoids loading pretty voluminous data into
# memory when it is not strictly needed.

# ::: info Data are saved locally
#
# Both polygons and raster data are saved locally, which means that the first
# download takes longer, but subsequent reads are much faster.
#
# :::

# The `SDMLayer` function is the main constructor for layers (and can also read
# from [STAC catalogues](/manual/retrieval/stac/) and [local
# files](/manual/usage/read-part-layer/)). When given a `RasterProvider`, it
# will download (or open) the relevant files.

L = SDMLayer{Float32}[
    SDMLayer(
        chelsa_bioclim;
        layer = v,
        extent...,
    ) for v in layers(chelsa_bioclim)
];

# ::: info Accessing raster data
#
# For more information about accessing raster data, refer to [the
# vignette](/manual/retrieval/list-raster-layers/). All datasets (and the
# complete set of keyword options) are also listed in the navigation bar at the
# top of the screen.
#
# :::

# When these layers are first downloaded, they will cover the entire extent of
# the bounding box:

#figure bio1-full
f = Figure(; size = (600, 300))
ax = Axis(f[1, 1]; aspect = DataAspect())
heatmap!(ax, L[1]; colormap = :Greys)
hidespines!(ax)
hidedecorations!(ax)
current_figure() #hide

# We can mask the entire vector of layers with the polygon we use to define our
# area of interest. This operation will modify the data _in place_, so we do not
# create additional objects.

mask!(L, aoi);

#figure bio1-masked
f = Figure(; size = (600, 300))
ax = Axis(f[1, 1]; aspect = DataAspect())
heatmap!(ax, L[1]; colormap = :Greys)
hidespines!(ax)
hidedecorations!(ax)
current_figure() #hide

# There is also a `trim` function, which will return a copy of the layers that
# are re-scaled so that they do not have empty rows/columns on either end. This
# is not required here, but may come in handy when doing more complex masking
# operations.

# ::: info Masking layers
#
# Many objects can be masked [with
# polygons](/manual/polygons/masking-with-polygons/), and there are additional
# methods to [mask layers](/manual/polygons/masking-a-layer/) as well. Both are
# documented in their vignettes.
#
# :::

# We will now grab a dataset from GBIF, which is a list of all observations of
# _Turdus torquatus_ in Switzerland according to *eBird*. We will also grab a
# second dataset to test the model, which is the same species and country but
# uses *iNaturalist* data. Finally, we will get a representation of the 

records = GBIF.download("10.15468/dl.wye52h")
test_records = GBIF.download("10.15468/dl.m6b3wg")
ouzel = taxon(first(entity(records)))

# ::: info GBIF data
#
# There are additional vignettes about retrieving data from the [GBIF
# API](/manual/retrieval/gbif-api/), from [GBIF
# downloads](/manual/retrieval/gbif-download/), or from [local GBIF
# archives](/manual/retrieval/gbif-local/).
#
# :::

# Getting the species as its own variable will allow us, among other things, to
# retrieve a silhouette from the [Phylopic](https://www.phylopic.org/) database.
# Note that it may not be the _exact_ species, but Phylopic curates a taxonomy
# to return the closest matching organism. If your species is not in the
# Phylopic database, consider drawing the silhouette and contributing!

silhouette = Phylopic.imagesof(ouzel; items = 1)
Phylopic.attribution(silhouette)

# We can see the result of our data collection work thus far, by plotting the
# training and testing records on the region of interest, and adding a
# silhouette of the species alongside this map.

#figure presence-data-train-test
f = Figure(; size = (600, 300))
ax = Axis(f[1, 1]; aspect = DataAspect())
poly!(ax, aoi; color = :grey95)
scatter!(ax, records; color = :forestgreen, label = "Training")
scatter!(
    ax,
    test_records;
    color = (:purple, 0.4),
    strokecolor = :purple,
    strokewidth = 1,
    marker = :rect,
    markersize = 9,
    label = "Testing",
)
hidedecorations!(ax)
hidespines!(ax)
lines!(ax, aoi; color = :grey10)
axislegend(ax; position = :rt, framevisible = false)
silhouetteplot!(
    ax,
    extent.left + 0.3,
    extent.top - 0.2,
    silhouette;
    markersize = 70,
    color = :black,
)
current_figure() #hide

# At this point, we have collected all of the _actual_ data we can, and it is
# time to generate pseudo-absences in order to have all of the material to train
# our model.

# ## Pseudo-absence generation

# We start by preparing a layer with presence data. This operation will ensure
# that all of the observations that share a raster cell will only be counted
# once. Note that for now, we will only work on the training records (from
# *eBird*).

presencelayer = mask(first(L), Occurrences(mask(records, aoi)))

# The next step is to generate a pseudo-absence mask. We will sample according
# to the distance away from a known observation, but never sample a
# pseudo-absence less than 4km away from an observation.

background = pseudoabsencemask(DistanceToEvent, presencelayer)

# Within this layer of possible location of absences, we will sample at random
# twice as many pseudo-absences cells as we have presence cells in the presence
# layer:

bgpoints = backgroundpoints(nodata(background, x -> x <= 4.), 2sum(presencelayer))

# ::: info More on pseudo-absences
#
# There is a vignette with all the [pseudo-absence generation
# methods](/manual/generation/pseudoabsences/). A lot of them are built into the
# package, and adding custom ones is not very difficult!
#
# :::

# We can take a minute to visualize the dataset, as well as the location of
# presences and pseudo-absences:

#figure pseudoabsences
f = Figure(; size = (600, 300))
ax = Axis(f[1, 1]; aspect = DataAspect())
poly!(ax, aoi; color = :grey90, strokecolor = :black, strokewidth = 1)
scatter!(ax, presencelayer; color = :black)
scatter!(ax, bgpoints; color = :red, markersize = 4)
hidedecorations!(ax)
hidespines!(ax)
current_figure() #hide

# We now have enough information to set-up the actual species distribution
# model!

# ## Setting up the model

# We will use a model with a PCA for variable transformation, and then use
# logistic regression with all interactions between variables (_i.e._ both xᵢ²
# and xᵢxⱼ) to make the actual prediction. Note that we build this model by
# passing first the data transformation and the classifier, and then the vector
# of covariates, the layer with the presences, and the layer with the absences.

model = SDM(PCATransform, Logistic, L, presencelayer, bgpoints)


# ::: info More on models
#
# There is a vignette on [model training](/manual/sdm/pipeline/) that covers all
# of the options, as well as the method to generate ensemble and boosted models.
# It is is _strongly advised_ to read it after this one!
#
# :::

# We can tweak the hyperparameters of this model. We will can check the default
# values:

hyperparameters(classifier(model))

# ::: info Hyper-parameters
#
# There is a [vignette on hyper-parameters](/manual/sdm/hyperparameters/) that
# covers all of the functions to get and modify the hyper-parameters of a model.
#
# :::

# We will set different hyper-parameters, to ensure that the learning rate is
# slower, the regularization is higher, and we do more training epochs:

hyperparameters!(classifier(model), :η, 1e-4);
hyperparameters!(classifier(model), :λ, 2e-1);
hyperparameters!(classifier(model), :epochs, 10_000);

# Note that, because we are generating the SDM from a series of layers, it is
# georeferenced. We can confirm this with:

isgeoreferenced(model)

# Our model is now ready to be trained. Before we train it, we will perform
# cross-validation and variable selection.

# ## Variable selection

# In this section, we will use cross-validation to identify the optimal set of
# variables for the model. The optimal set of variables is defined as the one
# that gives the best performance on average over the _validation_ sets.

# ::: info More on cross-validation
#
# Both [cross-validation](/manual/sdm/crossvalidation/) and [feature
# selection](/manual/sdm/variableselection/) are covered in their own vignettes.
#
# :::

# We start by splitting the dataset into training and validation data. We will
# use _k_-fold cross-validation with a default of ten splits. By default, the
# splits are _always_ balanced, so that the training and validation data have
# the same prevalence of presences.

folds = kfold(model)

# We will perform variable selection by adding variables one at a time, but we
# will constrain the model to start with BIO1. 

variables!(model, ForwardSelection, folds; included=[1])

# After this step, we can check that the model is trained:

istrained(model)

# And we can also inspect the list of selected variables:

variables(model)

# ## Measuring the model performance

# Now that we have identified the optimal set of variables, it is important to
# report the expected performance of this model. This is done internally when
# selecting the variables, but it is important to report on multiple measures of
# model performance.

cval, ctrn = crossvalidate(model)

# We can look at the average MCC for the training data:

mcc(ctrn)

# ::: info PR and ROC curves
#
# If you want to visualize these curves, there is [a vignette on how to measure
# them](/manual/sdm/pr-roc/). 
#
# :::

# We will do a summary table with several

ms = [mcc, ppv, npv, f1, balancedaccuracy]
M = permutedims([
    m(c) for m in ms, c in [cval, ctrn]
]);
M = hcat(["Training", "Validation"], M);
pretty_table(
    M;
    alignment = [:l, :c, :c, :c, :c, :c],
    backend = :markdown,
    column_labels = ["Dataset"; string.(ms)],
    formatters = [fmt__printf("%5.3f", [2, 3, 4, 5, 6])],
)

# ## Prediction on the testing data

# Back at the data collection step, we had also downloaded some testing data. We
# we will use them to make predictions on the environmental conditions
# associated to these observations:

Xₜ = permutedims(hcat([l[test_records] for l in L]...))

# The model predicts the following outcomes here:

yₜ = predict(model, Xₜ)

# We can calculate the accuracy of this prediction (which is fine to do since
# the testing data are presence-only):

accuracy(yₜ, ones(Bool, length(yₜ)))

# This indicates the proportion of presences that our model has correctly
# predicted.

# ## Understanding the model

# Before moving on to making spatial predictions, it is important to understand
# what the model is doing to move from a value of the covariates to a
# prediction. For this, we can realy on functions that perform model
# explanations.

# ::: info Model interpretability
#
# Both [model interpretability](/manual/sdm/interpretability/) and [feature
# importance](/manual/sdm/featureimportance/) have their own vignettes, which
# cover the essential options. There are additional techniques for model
# explanation that are not covered in this vignette.
#
# :::

# We will estimate the importance of variables through the `PartialDependence`
# measure, which captures the variable that, on average across all training
# data, has the most different effect on prediction when its value is varied.

vimp = [featureimportance(PartialDependence, model, v) for v in variables(model)]
vimp ./= sum(vimp)

#figure variable-importance
f = Figure()
ax = Axis(f[1,1], ylabel="Relative feature importance")
lines!(ax, 1:length(vimp), sort(vimp, rev=true), color=:black, linestyle=:dash)
textlabel!(ax, sortperm(vimp, rev=true), vimp, "BIO".*string.(variables(model)))
ylims!(ax, low=0.0)
hidexdecorations!(ax)
xlims!(ax, 0.5, length(variables(model)) + 0.5)
current_figure() #hide

# We will limit our analysis to the two most important variables:

mostimp = partialsortperm(vimp, 1:2, rev=true)
v1, v2 = variables(model)[mostimp]

# If we want to get more information about which these two are, we can use the
# `layerdescriptions` function to get plain-text information:

varnames = [
    layerdescriptions(chelsa_bioclim)[l]
    for l in layers(chelsa_bioclim)[variables(model)[mostimp]]
]

# To start with, we can look at the partial response of the model to the most
# important variables (the rugplots for the presences is at the bottom, and the
# one for the pseudo-absences at the top).

# figure partial-response-figure
f = Figure()
ax = Axis(f[1, 1]; xlabel=varnames[1], ylabel="Model response")
lines!(ax, explainmodel(PartialResponse, model, v1, 100; threshold=false)..., color=:black)
vlines!(ax, features(model, v1)[findall(labels(model))], ymax=0.025, color=:grey70)
vlines!(ax, features(model, v1)[findall(.!labels(model))], ymin=1-0.025, color=:red)
ylims!(ax, 0, 1)
tightlimits!(ax)
current_figure() #hide

# ::: warning Index of variables
#
# Models can be reset at any time, which means that dropped variables can be
# re-included. Therefore, the index of a variable in a model _nevers_ refers to
# the list of included variables, but to the entire pool of variables that the
# model had access to when it was created.
#
# :::

# We can also look at the combination of the two most important variables:

#figure partial-two-most
f = Figure()
ax = Axis(f[1,1], xlabel=varnames[1], ylabel=varnames[2])
hm = heatmap!(ax,
explainmodel(PartialResponse, model, (v1, v2), 25; threshold=false)...,
colormap=Reverse(:batlowW), colorrange=(0, 1)
)
Colorbar(f[1,2], hm, label="Model response")
current_figure() #hide

# For now, this is enough model explanation, and we will move on to making the
# first spatial prediction.

# ## Spatial predictions

# We can predict using the model by giving a vector of layers as an input. This
# will return the output _as a layer_ as well:

P = predict(model, L; threshold = false)

#figure model-output-map
f = Figure(; size = (600, 300))
ax = Axis(f[1, 1]; aspect = DataAspect())
hm = heatmap!(ax, P; colormap = Reverse(:batlowW), colorrange = (0, 1))
Colorbar(f[1, 2], hm)
lines!(ax, aoi; color = :grey10)
hidedecorations!(ax)
hidespines!(ax)
current_figure() #hide

# In the above prediction, we have requested the model _score_, as opposed to
# the predicted presence. We can get the presence by not changing the
# `threshold` argument:

R = predict(model, L)

#figure model-range-map-with-presences
f = Figure(; size = (600, 300))
ax = Axis(f[1, 1]; aspect = DataAspect())
poly!(ax, aoi; color = :grey95)
heatmap!(ax, R; colormap = [:transparent, :forestgreen])
scatter!(ax, records, color=:black, markersize=4)
lines!(ax, aoi; color = :grey10)
hidedecorations!(ax)
hidespines!(ax)
current_figure() #hide

# ## Spatial explanations

# When called with a vector of layers as additional arguments, the methods for
# model explanation will return a spatial version of the model response. For
# example, we can look at the effect of the most important variable on the
# prediction:

partial1 = explainmodel(PartialResponse, model, v1, L; threshold = false)

#figure partial-response-in-space
f = Figure(; size = (600, 300))
ax = Axis(f[1, 1]; aspect = DataAspect())
hm = heatmap!(ax, partial1; colormap = Reverse(:batlowW), colorrange = (0, 1))
Colorbar(f[1, 2], hm, label="Effect of BIO$(v1)")
lines!(ax, aoi; color = :grey10)
hidedecorations!(ax)
hidespines!(ax)
current_figure() #hide

# This is particularly important to look at the _local_ effect of the variables
# on each prediction, for example using Shapley values:

shapley1 = explainmodel(ShapleyMC, model, v1, L; threshold = false)

# Note that the Shapley values are expressed as a deviation from the average
# prediction, and so positive values correspond to the presence class being more
# likely compared to the baseline.

# Both the `explain` and `partialresponse` functions can accept keywords that
# are passed to `predict` - in this tutorial, we use `threshold=false` to
# provide an explanation on the score returned by the model, but we can also
# request an explanation of the binary response (this is usually less
# informative).

#figure shapley-response-in-space
col_lims = maximum(abs.(quantile(shapley1, [0.1, 0.9]))) .* (-1, 1)
f = Figure(; size = (600, 300))
ax = Axis(f[1, 1]; aspect = DataAspect())
hm = heatmap!(ax, shapley1; colormap = :managua, colorrange = col_lims)
Colorbar(f[1, 2], hm, label="Effect of BIO$(v1)")
lines!(ax, aoi; color = :black)
hidedecorations!(ax)
hidespines!(ax)
current_figure() #hide

# We will now identify which of these variables is the most locally important to
# make the final prediction:

S = explainmodel(ShapleyMC, model, L; threshold = false)

# We can rely on the `mosaic` function to find the variable that has the largest
# absolute contribution to moving the prediction away from the average. This
# serves as a way to identify the most locally important variable:

keyvariable = mosaic(argmax, map(x -> abs.(x), S))

# It is important to notice that, even though our model relies on a PCA to
# transform the variables, we are looking at the importance of the variables
# _before_ the transformation. We can, therefore, think biologically about the
# result of this analysis.

# Because this too is a layer, it can be mapped as well (after a little bit of
# mischief with the color palette):

#figure model-mosaicplot
f = Figure(; size = (600, 300))
colors = Makie.wong_colors()
n_var = length(variables(model))
n_col = length(colors)
if n_var > n_col
    append!(colors, fill(colorant"#ececec", n_var - n_col))
end
palette = cgrad(colors[1:n_var], n_var, categorical=true)
ax = Axis(f[1, 1]; aspect = DataAspect())
heatmap!(ax, keyvariable; colormap = palette)
lines!(ax, aoi; color = :grey10)
hidedecorations!(ax)
hidespines!(ax)
Legend(
    f[2, 1],
    [PolyElement(; color = colors[i]) for i in 1:length(variables(model))],
    ["BIO$(b)" for b in variables(model)];
    orientation = :horizontal,
    nbanks = 1,
    framevisible = false,
    vertical = false,
)
current_figure() #hide


# ## Related documentation

# ```@meta
# CollapsedDocStrings = true
# ```

# ```@docs; canonical=false
# crossvalidate
# explainmodel
# featureimportance
# pseudoabsencemask
# backgroundpoints
# taxon
# mosaic
# hyperparameters
# hyperparameters!
# SDMLayer
# Occurrences
# ```

