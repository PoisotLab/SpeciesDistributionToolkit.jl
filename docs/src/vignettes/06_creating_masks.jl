# # Creating masks of layers

using SpeciesDistributionToolkit
using Dates
using CairoMakie

#

spatial_extent = (left = 104.523, bottom = -9.925, right = 128.979, top = -1.669)

# 

prec2 =
    SimpleSDMPredictor(
        RasterData(CHELSA2, Precipitation);
        month = Month(9),
        spatial_extent...,
    )

#

prec1 = SimpleSDMPredictor(
    RasterData(CHELSA1, Precipitation);
    month = Month(9),
    spatial_extent...,
)

# make a mask

masked_prec2 = mask(prec1, prec2)

# plot

heatmap(
    sprinkle(masked_prec2)...;
    colormap = :deep,
    figure = (; resolution = (800, 300)),
    axis = (; xlabel = "Longitude", ylabel = "Latitude"),
)
