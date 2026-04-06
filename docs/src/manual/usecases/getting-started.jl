# # Building a species distribution model

# In this tutorial, we will work on the same species and location as in , to
# show how `SpeciesDistributionToolkit` integrates prediction to the rest of the
# workflow.

using SpeciesDistributionToolkit
using Statistics

# ::: info About this tutorial
# 
# This tutorial is inspired by the [the excellent introduction to SDMs by
# Damaris Zurell](https://damariszurell.github.io/SDM-Intro/). It uses the same
# species, but a slightly different dataset.
#
# :::

# Most of the data types in `SpeciesDistributionToolkit` can be used with
# `Makie` for plotting. This is true for [layers](/manual/dataviz/layers/),
# [polygons](/manual/dataviz/polygons/), and more. These are all documented in
# the "Manual" section of the documentation, under "Data visualization". To
# benefit from this integration, we will load the `CairoMakie` backend.

using CairoMakie

# ## Getting the data

# We start by downloading a polygon that will be used to delineate our area of
# interest. For this tutorial, this will be the country of Szwitzerland.

aoi = getpolygon(PolygonData(NaturalEarth, Countries); resolution = 10)["Switzerland"]

# To ensure that we only load the raster data that are within the range of our
# problem, we will calculate the spatial extent:

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
# [CHELSA2](/datasets/CHELSA2) database.

chelsa_bioclim = RasterData(CHELSA2, BioClim)
layers(chelsa_bioclim)

# ::: info Data are saved locally
#
# Both polygons and raster data are saved locally, which means that the first
# download takes longer, but subsequent reads are much faster.
#
# :::

# The `SDMLayer` function is the main constructor for

L = SDMLayer{Float32}[
    SDMLayer(
        provider;
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
f = Figure()
ax = Axis(f[1, 1]; aspect = DataAspect())
heatmap!(ax, L[1]; colormap = :Greys)
hidespines!(ax)
hidedecorations!(ax)
current_figure() #hide

# We can mask the entire vector of layers with the polygon we use to define our
# area of interest. This operation will modify the data _in place_, so we do not
# create additional objects.

mask!(L, aoi)

#figure bio1-masked
f = Figure()
ax = Axis(f[1, 1]; aspect = DataAspect())
heatmap!(ax, L[1]; colormap = :Greys)
hidespines!(ax)
hidedecorations!(ax)
current_figure() #hide

# ::: info Masking layers
#
# [with polygons](/manual/polygons/masking-with-polygons/) and [just masking
# idk](/manual/polygons/masking-a-layer/)
#
# :::

# We will now grab a dataset from GBIF, which is a list of all observations of
# _Turdus torquatus_ in Switzerland according to *eBird*. We will also grab a
# second dataset to test the model, which is the same species and country but
# uses *iNaturalist* data. Finally, we will get a representation of the 

records = GBIF.download("10.15468/dl.wye52h")
test_records = GBIF.download("10.15468/dl.m6b3wg")
ouzel = taxon(first(entity(presences)))

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

#figure presence-data
f = Figure()
ax = Axis(f[1, 1]; aspect = DataAspect())
poly!(ax, aoi; color = :grey95)
scatter!(ax, records; color = :forestgreen, label = "Training")
scatter!(
    ax,
    test_records;
    color = :transparent,
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

# ## Pseudo-absence generation

# And after this, we prepare a layer with presence data:

presencelayer = mask(first(L), Occurrences(mask(presences, aoi)))

# The next step is to generate a pseudo-absence mask. We will sample based on
# the distance to an observation, by also preventing pseudo-absences to be less
# than 4km from an observation:

background = pseudoabsencemask(WithoutRadius, presencelayer; distance = 4.0)
bgpoints = backgroundpoints(background, 2sum(presencelayer))

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

# ## Setting up the model

# These steps are documented as part of the `SDeMo` documentation. The only
# difference here is that rather than passing a matrix of features and a vector
# of labels, we give a vector of layers (features), and the two layers for
# presences and absences:

model = SDM(PCATransform, Logistic, L, presencelayer, bgpoints)
hyperparameters!(classifier(model), :η, 1e-4);
hyperparameters!(classifier(model), :interactions, :self);
hyperparameters!(classifier(model), :epochs, 10_000);

# Note that, because we are generating the SDM from a series of layers, it is
# georeferenced. We can confirm this with:

isgeoreferenced(model)

# We will now train the model on all the training data.

train!(model)

# In order to make sure we have a robust threshold for the model, we will also
# re-estimate it on cross-validation samples. This is a slightly more reliable
# version than the thresholding done as part of `train!`.

threshold!(model)

# ## Measuring the model performance

# ## Understanding the model

# ## Making the first prediction

# We can predict using the model by giving a vector of layers as an input. This
# will return the output *as a layer* as well:

prd = predict(model, L; threshold = false)

# Because this prediction is a layer, we can plot it directly:

#figure initial-map
f = Figure(; size = (600, 300))
ax = Axis(f[1, 1]; aspect = DataAspect())
hm = heatmap!(ax, prd; colormap = Reverse(:batlowW), colorrange = (0, 1))
contour!(ax, predict(model, L); color = :black, linewidth = 0.5)
Colorbar(f[1, 2], hm)
lines!(ax, aoi; color = :black)
bbox = SpeciesDistributionToolkit.boundingbox(aoi)
hidedecorations!(ax)
hidespines!(ax)
current_figure() #hide

# As a rule, most relevant function in `SDeMo` will, when given layers as an
# argument, return the output as layers:

partial1 = explainmodel(PartialResponse, model, 1, L; threshold = false)

# The output can be visualised as well. Partial responses are given in the same
# units as the prediction.

#figure partial-resp
f = Figure(; size = (600, 300))
ax = Axis(f[1, 1]; aspect = DataAspect())
hm = heatmap!(ax, partial1; colormap = Reverse(:batlowW), colorrange = (0, 1))
contour!(ax, predict(model, L); color = :black, linewidth = 0.5)
Colorbar(f[1, 2], hm)
lines!(ax, aoi; color = :black)
hidedecorations!(ax)
hidespines!(ax)
current_figure() #hide

# This, naturally, is also true for Shapley values:

shapley1 = explainmodel(ShapleyMC, model, 1, L; threshold = false)

# Note that the Shapley values are expressed as a deviation from the average
# prediction, and so positive values correspond to the presence class being more
# likely.

# Both the `explain` and `partialresponse` functions can accept keywords that
# are passed to `predict` - in this tutorial, we use `threshold=false` to
# provide an explanation on the score returned by the model, but we can also
# request an explanation of the binary response (this is usually less
# informative).

#figure shapley-resp
col_lims = maximum(abs.(quantile(shapley1, [0.1, 0.9]))) .* (-1, 1)
f = Figure(; size = (600, 300))
ax = Axis(f[1, 1]; aspect = DataAspect())
hm = heatmap!(ax, shapley1; colormap = :managua, colorrange = col_lims)
contour!(ax, predict(model, L); color = :black, linewidth = 0.5)
Colorbar(f[1, 2], hm)
lines!(ax, aoi; color = :black)
hidedecorations!(ax)
hidespines!(ax)
current_figure() #hide

# When given a vector of layers, the `explain` function will return a layer with
# the explanation for each input variable:

S = explainmodel(ShapleyMC, model, L; threshold = false)

# We can then put this object into the `mosaic` function to get the index of
# which variable is the most important for each pixel:

#figure model-mosaicplot
f = Figure(; size = (600, 300))
mostimp = mosaic(argmax, map(x -> abs.(x), S))
colmap = [
    colorant"#E69F00",
    colorant"#56B4E9",
    colorant"#009E73",
    colorant"#D55E00",
    colorant"#CC79A7",
]
ax = Axis(f[1, 1]; aspect = DataAspect())
heatmap!(ax, mostimp; colormap = colmap)
contour!(
    ax,
    predict(model, L);
    color = :black,
    linewidth = 0.5,
)
lines!(ax, aoi; color = :black)
hidedecorations!(ax)
hidespines!(ax)
Legend(
    f[2, 1],
    [PolyElement(; color = colmap[i]) for i in 1:length(bio_vars)],
    ["BIO$(b)" for b in bio_vars];
    orientation = :horizontal,
    nbanks = 1,
    framevisible = false,
    vertical = false,
)
current_figure() #hide
