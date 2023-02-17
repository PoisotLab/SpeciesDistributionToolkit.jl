# # Splitting layers in tiles

using SpeciesDistributionToolkit
using CairoMakie

# Get some data

dataprovider = RasterData(EarthEnv, LandCover)
spatial_extent = (left = -80.00, bottom = 43.19, right = -70.94, top = 46.93)
trees = sum([
    SimpleSDMPredictor(dataprovider; layer = i, full = true, spatial_extent...) for
    i in 1:4
])

# split into tiles

tiles = tile(trees, (4, 5))

# plot

tile_plot = heatmap(
    tiles[1,2];
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

# 