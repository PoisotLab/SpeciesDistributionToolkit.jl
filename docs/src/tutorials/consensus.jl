# # Creating a landcover consensus map

# In this vignette, we will look at the different landcover classes in the Alps
# mountain range. This is an opportunity to see how we can edit, mask, and
# aggregate data for processing.

using SpeciesDistributionToolkit
using CairoMakie
CairoMakie.activate!(; type = "png", px_per_unit = 2) #hide

#-

POL = getpolygon(PolygonData(OpenStreetMap, Places), place="Alps")
spatial_extent = SpeciesDistributionToolkit.boundingbox(POL)

# Defining a bounding box is important because, although we can clip any layer,
# the package will only *read* what is required. For large data (like landcover
# data), this is a significant improvement in memory footprint.

# We now define our data provider [Tuanmu2014](@citet), composed of a data
# source (`EarthEnv`) and a dataset (`LandCover`).

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
];

# We then mask the layers using the polygon we are interested in:

mask!(stack, POL)

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

# We can check which categories are actually represented in the consensus map:

repr = sort(unique(values(consensus)))

# We can now create our plot:

# fig-consensus-heatmap
fig = Figure(; size = (900, 700))
panel = Axis(
    fig[1, 1];
    xlabel = "Easting",
    ylabel = "Northing",
    aspect = DataAspect(),
)
hidedecorations!(panel)
hidespines!(panel)
heatmap!(
    panel,
    consensus;
    colormap = landcover_colors[repr],
)
lines!(panel, POL, color=:black)
Legend(
    fig[2, 1],
    [PolyElement(; color = landcover_colors[repr][i]) for i in eachindex(landcover_colors[repr])],
    landcover_types[repr];
    orientation = :horizontal,
    nbanks = 4,
)
current_figure() #hide

# ## References

# ```@bibliography
# Pages = [@__FILE__]
# Style = :authoryear
# ```