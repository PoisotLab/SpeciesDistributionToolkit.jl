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

To import this file as a `SimpleSDMLayer`, we need to create a type
(`MyConnectivityMap`), and declare a method for `latitudes` and `longitudes` for
this type, where the output is the range of latitudes and longitudes. This might
seem cumbersome, but remember: it can be automated, and if you do not declare a
`latitude` and `longitude` method, it will be assumed that the raster covers the
entire globe. From a end-user perspective, it also removes the need to pass the
bounding box of your layer as an argument, and to focus instead of the region of
interest.

```@example temp
struct MyConnectivityMap <: SimpleSDMLayers.SimpleSDMSource end
SimpleSDMLayers.latitudes(::Type{MyConnectivityMap}) = (45.34523, 47.38457)
SimpleSDMLayers.longitudes(::Type{MyConnectivityMap}) = (-75.17734,-72.36486)
```

Now that this is done, we can read this file as a `SimpleSDMResponse` using the
`raster` function:

```@example temp
mp = SimpleSDMLayers.raster(SimpleSDMResponse, MyConnectivityMap(), file)
```

Because this file has raw values, which are not necessarily great for plotting,
we will transform it to quantiles, using the `StatsBase.ecdf` function.

```@example temp
qfunc = ecdf(convert(Vector{Float64}, filter(!isnothing, mp.grid)))
```

And we can now broadcast this function to the layer:

```@example temp
qmap = broadcast(qfunc, mp)
```

Finally, we are ready for plotting:

```@example temp
plot(qmap, frame=:grid, c=:YlGnBu)
```
