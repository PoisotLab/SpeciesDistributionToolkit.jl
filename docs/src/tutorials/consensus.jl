# # Creating a landcover consensus map

# In this vignette, we will look at the different landcover classes in Corsica.
# This is an opportunity to see how we can edit, mask, and aggregate data for
# processing.

using SpeciesDistributionToolkit
using CairoMakie

#-

spatial_extent = (left = 8.412, bottom = 41.325, right = 9.662, top = 43.060)

# Defining a bounding box is important because, although we can clip any layer,
# the package will only *read* what is required. For large data (like landcover
# data), this is a significant improvement in memory footprint.

# We now define our data provider, composed of a data source (`EarthEnv`) and a
# dataset (`LandCover`).

dataprovider = RasterData(EarthEnv, LandCover)

# It is good practice to check which layers are provided:

landcover_types = layers(dataprovider)

# For more information, you can also refer to the URL of the original dataset:

SimpleSDMDatasets.url(dataprovider)

# We can download all the layers using a list comprehension. Note that the name
# (`stack`) is a little misleading, as the packages have no concept of what a
# stack of raster is.

stack = [
    SDMLayer(dataprovider; layer = layer, full = true, spatial_extent...) for
    layer in landcover_types
]

# We know that the last layer (`"Open Water"`) is a little less interesting, so we
# can create a mask for the pixels that are less than 100% open water.

open_water_idx = findfirst(isequal("Open Water"), landcover_types)
open_water_mask = nodata(stack[open_water_idx], 100.0f0)

# We can now mask all of the rasters in the stack, to remove the open water
# pixels:

for i in eachindex(stack)
    mask!(stack[i], open_water_mask)
end

# At this point, we are ready to get the most important land use category for each
# pixel, using the `mosaic` function:

consensus = mosaic(argmax, stack)

# In order to represent the output, we will define a color palette corresponding
# to the different categories in our data:

landcover_colors = [
    colorant"#117733",
    colorant"#668822",
    colorant"#99BB55",
    colorant"#55aa22",
    colorant"#ddcc66",
    colorant"#aaddcc",
    colorant"#44aa88",
    colorant"#88bbaa",
    colorant"#bb0011",
    :aqua,
    colorant"#FFEE88",
    colorant"#5566AA",
];

# We can now create our plot:

fig = Figure(; size = (900, 1000))
panel = Axis(
    fig[1, 1];
    xlabel = "Easting",
    ylabel = "Northing",
    aspect = DataAspect(),
)
heatmap!(
    panel,
    consensus;
    colormap = landcover_colors,
)
Legend(
    fig[2, 1],
    [PolyElement(; color = landcover_colors[i]) for i in eachindex(landcover_colors)],
    landcover_types;
    orientation = :horizontal,
    nbanks = 4,
)
current_figure() #hide
