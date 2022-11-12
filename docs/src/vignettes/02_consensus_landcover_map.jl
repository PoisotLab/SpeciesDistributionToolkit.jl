# # Creating a landcover consensus map

using SpeciesDistributionToolkit
using CairoMakie
using GeoMakie

# In this vignette, we will look at the different landcover classes in Iceland. This is an
# opportunity to see how we can edit, mask, and aggregate data for processing.

# To begin with, we define a bounding box around Iceland. The website [bboxfinder.com][bbox]
# is fantastic is you need to rapidly define bounding boxes!

# [bbox]: http://bboxfinder.com/#0.000000,0.000000,0.000000,0.000000

spatial_extent = (left = -24.785, right = -12.634, top = 66.878, bottom = 62.935)

# Defining a bounding box is important because, although we can clip any layer, the package
# will only *read* what is required. For large data (like landcover data), this is
# a significant improvement in memory footprint.

# We now define our data provider, composed of a data source (`EarthEnv`) and a dataset
# (`LandCover`).

dataprovider = RasterData(EarthEnv, LandCover)

# It is good practice to check which layers are provided:

landcover_types = SimpleSDMDatasets.layers(dataprovider)

# We can download all the layers using a list comprehension. Note that the name (`stack`) is
# a little misleading, as the packages have no concept of what a stack of raster is.

stack = [
    SimpleSDMPredictor(dataprovider; layer = layer, full = true, spatial_extent...) for
    layer in landcover_types
]

# We know that the last layer (`"Open Water"`) is a little less interesting, so we can
# create a mask for the pixels that are less than 100% open water.

open_water_idx = findfirst(isequal("Open Water"), landcover_types)
open_water_mask = broadcast(v -> v < 100.0f0, stack[open_water_idx])

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

# We can now make the plot - because the area is relatively small, we will keep the `latlon`
# projection as the destination. Most of this code is really manually setting up a figure
# and a legend. The `sprinkle` function is used to transform a layer into an `x, y, z` tuple
# that can be used for plotting.

fig = Figure(; resolution = (1000, 500))
panel = GeoAxis(
    fig[1, 1];
    source = "+proj=longlat +datum=WGS84",
    dest = "+proj=longlat",
    lonlims = extrema(longitudes(consensus)),
    latlims = extrema(latitudes(consensus)),
    xlabel = "Longitude",
    ylabel = "Latitude",
)
heatmap!(
    panel,
    sprinkle(convert(Float32, consensus))...;
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
