# Importing your own data

It is possible to import your own rasters into a `SimpleSDMLayer` object. This
requires defining a new type and two "helper" functions, which might seem a
little bit convoluted, but helps *immensely* underneath in case you want to also
*download* rasters from the web with different arguments. In this example, we
will look at a data file produced by the *OmniScape* package, and which
represents landscape connectivity in the Laurentians region of Québec. This
example will also show how we can use the `broadcast` operation to modify the
values of a raster.

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
