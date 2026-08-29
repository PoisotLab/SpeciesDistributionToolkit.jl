# # Creating masks of layers

# In this vignette, we will see a way to use information in a layer to mask another layer.
# This has a very practical application: the CHELSA2 data also cover open water, which is
# usually not something we want for most SDM applications. Thankfully, they share a grid
# with CHELSA1 data, and so we have a quick and dirty (we prefer "clever") way to mask the
# CHELSA2 layers.

using SpeciesDistributionToolkit
using Dates
using CairoMakie

# We will focus on Corsica:

spatial_extent = (left = 8.412, bottom = 41.325, right = 9.662, top = 43.060)

# Getting the precipitation layer for september in the CHELSA2 dataset is simply:

prec2 =
    SimpleSDMPredictor(
        RasterData(CHELSA2, Precipitation);
        month = Month(9),
        spatial_extent...,
    )

# The same layer can be queried from CHELSA1. Note that we are specifying the same layer and
# month here, which is not strictly speaking required (if we had multiple CHELSA2 layers, we
# would only want a single CHELSA1 layer to mask them anyways) but is done in for the sake
# of clarity:

prec1 = SimpleSDMPredictor(
    RasterData(CHELSA1, Precipitation);
    month = Month(9),
    spatial_extent...,
)

# The simplest way to make a mask is to use a layer to mask the other (the first argument is
# used as a template, the second is being masked):

masked_prec2 = mask(prec1, prec2)

# We can confirm that the number or filled cells has decreased, and visual inspection of the
# result will further show that we have accomplished our goal;

heatmap(
    masked_prec2;
    colormap = :deep,
    figure = (; resolution = (800, 300)),
    axis = (; xlabel = "Longitude", ylabel = "Latitude"),
)
current_figure()
