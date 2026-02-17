# # Creating a landcover consensus map

using SpeciesDistributionToolkit
using CairoMakie
using GeoMakie

# In this vignette, we will look at the different landcover classes in Iceland. This is an
# opportunity to see how we can edit, mask, and aggregate data for processing.

# To begin with, we define a bounding box around Iceland. The website
# [bboxfinder.com](http://bboxfinder.com/) is fantastic for when you need to
# rapidly define bounding boxes!

spatial_extent = (left = -24.785, right = -12.634, top = 66.878, bottom = 62.935)

# Defining a bounding box is important because, although we can clip any layer, the package
# will only *read* what is required. For large data (like landcover data), this is
# a significant improvement in memory footprint.

# We now define our data provider, composed of a data source (`EarthEnv`) and a dataset
# (`LandCover`).

dataprovider = RasterData(EarthEnv, LandCover)

# It is good practice to check which layers are provided:

landcover_types = layers(dataprovider)

# For more information, you can also refer to the URL of the original dataset:

SimpleSDMDatasets.url(dataprovider)

# We can download all the layers using a list comprehension. Note that the name (`stack`) is
# a little misleading, as the packages have no concept of what a stack of raster is.

stack = [
    SimpleSDMPredictor(dataprovider; layer = layer, full = true, spatial_extent...) for
    layer in landcover_types
]

# We know that the last layer (`"Open Water"`) is a little less interesting, so we can
# create a mask for the pixels that are less than 100% open water.

open_water_idx = findfirst(isequal("Open Water"), landcover_types)
open_water_mask = stack[open_water_idx] .< 100.0f0

# We can now mask all of the rasters in the stack, to remove the open water pixels:

stack = [mask(open_water_mask, layer) for layer in stack]

# At this point, we are ready to get the most important land use category for each pixel,
# using the `mosaic` function:

consensus = mosaic(argmax, stack)

# In order to represent the output, we will define a color palette corresponding to the
# different categories in our data:

landcover_colors = [
    :forestgreen,
    :forestgreen,
    :forestgreen,
    :forestgreen,
    :darkseagreen3,
    :goldenrod1,
    :wheat2,
    :blue,
    :red,
    :aqua,
    :grey74,
    :transparent,
];

# We can now create our plot:

fig = Figure(; resolution = (1000, 500))
panel = GeoAxis(
    fig[1, 1];
    source = "+proj=longlat +datum=WGS84",
    dest = "+proj=wintri",
    lonlims = extrema(longitudes(consensus)),
    latlims = extrema(latitudes(consensus)),
    xlabel = "Longitude",
    ylabel = "Latitude",
)
surface!(
    panel,
    consensus;
    shading = false,
    interpolate = false,
    colormap = landcover_colors,
)
Legend(
    fig[2, 1],
    [PolyElement(; color = landcover_colors[i]) for i in eachindex(landcover_colors)],
    landcover_types;
    orientation = :horizontal,
    nbanks = 4,
)
current_figure()
