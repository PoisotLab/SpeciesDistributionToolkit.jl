# ... split a layer in tiles?

This document illustrates the use of the `tiles` function, to rapidly split a
layer into multiple layers. This is useful if you want to perform operations on
raster that can easily be made parallel, and do not require the full raster.

```@example 1
using SpeciesDistributionToolkit
using CairoMakie
```

To illustrate the tiling, we will grab the tree cover as given in the *EarthEnv*
dataset, for a small spatial extent.

```@example 1
dataprovider = RasterData(EarthEnv, LandCover)
spatial_extent = (left = 8.412, bottom = 41.325, right = 9.662, top = 43.060)
trees = sum([
    SDMLayer(dataprovider; layer = i, full = true, spatial_extent...) for
    i in 1:4
])
```

Splitting the data into tiles can be done by calling the `tiles` function.

This will return a matrix with the same type as the layer given as its first
argument. The second argument (the size of the matrix) can be omitted, and will
default to `(5, 5)`.

```@example 1
tree = tiles(trees, (2, 2))
```

This can now be plotted:

```@example 1
tile_plot = heatmap(
    rand(tree);
    colormap = :Greens,
    figure = (; size = (800, 350)),
    axis = (;
        aspect = DataAspect(),
        xlabel = "Latitude",
        ylabel = "Longitude",
        title = "Relative tree cover",
    ),
)
Colorbar(tile_plot.figure[:, end + 1], tile_plot.plot; height = Relative(0.5))
save("tile-tree-cover.png", current_figure()); nothing # hide
```

![Tile for tree cover](tile-tree-cover.png)

This construct is very useful when your problem lends itself to naive
parallelism.