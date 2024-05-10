# ... mask a layer

The process of *masking* refers to turning cells on a layer's grid to *off*,
which will result in them being excluded from the analysis/display.

There are two ways to mask a layer -- using the `nodata!` approach, and using
the `mask!` approach. We use `nodata!` when working from a single layer, and
`mask!` when using data stored in a second layer. Note that both approaches have
a non-mutating version (`nodata` and `mask`, that return a modified copy of
their layer).

```@example 1
using SpeciesDistributionToolkit
using Dates, Statistics
using CairoMakie
```

We will illustrate both approaches using the CHELSA2 temperature data for the
month of September.

```@example 1
spatial_extent = (left = 8.412, bottom = 41.325, right = 9.662, top = 43.060)
temp2 =
    SDMLayer(
        RasterData(CHELSA2, AverageTemperature);
        month = Month(9),
        spatial_extent...,
    )
```

## Using `nodata!`

When using `nodata!`, we can either indicate a value to remove from the layer,
or pass a function. For example, we can mask the layer to remove all cells where
the temperature is in the upper and lower 5%:

```@example 1
m, M = Statistics.quantile(values(temp2), [0.05, 0.95])
nodata(temp2, v -> !(m <= v <= M))
```

!!! warning "A note about `nodata!`
    The function given as the second argument must returm `true` for a point that will be excluded from the layer. In other words, this behaves as the *opposite* of `filter!`.

## Using `mask!`
