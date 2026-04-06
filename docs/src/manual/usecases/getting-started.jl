# # Building a species distribution model

# In this tutorial, we will work on the same species and location as in [the
# excellent tutorial on SDMs by Damaris
# Zurell](https://damariszurell.github.io/SDM-Intro/), to show how
# `SpeciesDistributionToolkit` integrates prediction to the rest of the
# workflow.

using SpeciesDistributionToolkit
using Statistics
using CairoMakie

# Note that there are several sections about the `SDeMo` package in the "How-to"
# section of the manual.

# ## Getting the data

aoi = getpolygon(PolygonData(NaturalEarth, Countries))["Switzerland"]

# In order to simplify the code, we will start from a list of bioclim variables
# that have been picked to optimize the model - `SDeMo` offers many functions
# for variable selection.

bio_vars = [1, 11, 5, 8, 6]

# We get the data on these variables from aoiLSA2:

provider = RasterData(aoiLSA2, BioClim)
L = SDMLayer{Float32}[
    SDMLayer(
        provider;
        layer = x,
        SpeciesDistributionToolkit.boundingbox(aoi)...,
    ) for x in bio_vars
];

# And we then clip and trim to the polygon describing Switzerland:

mask!(L, aoi)

# The next step is to get the data, using the *eBird* dataset:

presences = GBIF.download("10.15468/dl.wye52h")
ouzel = taxon(first(entity(presences)))

# ask on thje [Phylopic](https://www.phylopic.org/) database for a silhoutte,
# note that it may not be the exact species

sp_uuid = Phylopic.imagesof(ouzel; items = 1)

# ::: info Illustration credit
# 
Phylopic.attribution(sp_uuid) #hide
#
# :::

# And after this, we prepare a layer with presence data:

presencelayer = mask(first(L), Occurrences(mask(presences, aoi)))

# The next step is to generate a pseudo-absence mask. We will sample based on
# the distance to an observation, by also preventing pseudo-absences to be less
# than 4km from an observation:

background = pseudoabsencemask(WithoutRadius, presencelayer; distance=4.0)
bgpoints = backgroundpoints(background, 2sum(presencelayer))

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
silhouetteplot!(
    ax,
    bbox.left + 0.3,
    bbox.top - 0.2,
    Phylopic.imagesof(ouzel; items = 1);
    markersize = 70,
)
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
