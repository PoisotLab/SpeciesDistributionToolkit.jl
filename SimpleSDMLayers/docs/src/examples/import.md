# Importing and exporting your own data

It is possible to import your own rasters into a `SimpleSDMLayer` object and to
export `SimpleSDMLayer` objects to raster files. In this example, we will look at a data file
produced by the *OmniScape* package, and which represents landscape connectivity
in the Laurentians region of Québec. This example will also show how we can use
the `broadcast` operation to modify the values of a raster.

## Importing data

```@example temp
using SimpleSDMLayers
using Plots
using StatsBase
```

The file comes with the package itself, so we can read it directly - this is a
geotiff file, where values are floating point numbers representing connectivity.

```@example temp
file = joinpath(dirname(pathof(SimpleSDMLayers)), "..", "data", "connectivity.tiff")
```

To import this file as a `SimpleSDMLayer`, we need to call the `geotiff`
function, which assumes a WGS84 projection:

```@example temp
mp = geotiff(SimpleSDMPredictor, file)
```

Because this file has raw values, which are not necessarily great for plotting,
we will transform it to quantiles, using the `rescale` function.

```@example temp
qmap = rescale!(mp, collect(0.0:0.01:1.0))
```

Finally, we are ready for plotting:

```@example temp
plot(qmap, frame=:grid, c=:cork, clim=(0,1))
```

## Exporting data

 `geotiff` can also be used in the opposite way to write `SimpleSDMLayer`
objects to tiff files. For instance, we might want to keep our layer with
quantile values for later on:

```@example temp
geotiff("layer.tif", qmap)
```

Note that `geotiff` can also write multiple layers in a single file (as
different bands) as long as they have the same size and the same bounding
coordinates. We can then reimport them by specifying the band number.

```@example temp
layers = SimpleSDMPredictor(WorldClim, BioClim, 1:2)

geotiff("stack.tif", layers)
layers = [geotiff(SimpleSDMPredictor, "stack.tif", i) for i in 1:2]
```