# ... interpolate to a new projection?

```@example 1
using SpeciesDistributionToolkit
using CairoMakie
```

The `interpolate` method can be used to project data into another coordinate system. For example, we can get data in ESPG:4326:

```@example 1
spatial_extent = (; left = -4.87, right=9.63, bottom=41.31, top=51.14)
dataprovider = RasterData(WorldClim2, BioClim)
layer = SDMLayer(dataprovider; layer="BIO1", spatial_extent...)
```

And project them to the locally appropriate EPSG:27574:

```@example 1
ws = interpolate(layer; dest="EPSG:27574")
```

By default, this produces a layer with the same dimension as the input, and uses bilinear interpolation.