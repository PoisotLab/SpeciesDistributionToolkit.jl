# # Splitting layers in tiles

# In this vignette, we will illustrate the use of the `tile` function, to
# rapidly split a layer into multiple layers that can be stitched back together
# using `hcat` and `vcat`. This is useful if you want to perform operations on
# raster that can easily be made parallel, and do not require the full raster.

using SpeciesDistributionToolkit
using CairoMakie

# To illustrate the tiling, we will grab the tree cover as given in the
# *EarthEnv* dataset, for a small spatial extent.

dataprovider = RasterData(EarthEnv, LandCover)
spatial_extent = (left = -80.00, bottom = 43.19, right = -70.94, top = 46.93)
trees = sum([
    SimpleSDMPredictor(dataprovider; layer = i, full = true, spatial_extent...) for
    i in 1:4
])

# Splitting the data into tiles can be done by calling the `tile` function (or
# `tile!`, if you want to overwrite an existing matrix of layers). This will
# return a matrix with the same type as the layer given as its first argument.
# The second argument (the size of the matrix) can be omitted, and will default
# to `(5, 5)`.

tiles = tile(trees, (8, 8))

# This can now be plotted:

tile_plot = heatmap(
    tiles[1, 2];
    colormap = :Greens,
    figure = (; resolution = (800, 350)),
    axis = (;
        aspect = DataAspect(),
        xlabel = "Latitude",
        ylabel = "Longitude",
        title = "Relative tree cover",
    ),
)
Colorbar(tile_plot.figure[:, end + 1], tile_plot.plot; height = Relative(0.5))
current_figure()

# The inverse operation to `tile` is `stitch`, which (assuming you have not
# moved tiles around!) will reconstruct a layer. For example, let's say we want
# to double the quantity of trees, but we want to do so using `map`.

more_trees  = stitch(map(x -> 2x, tiles))