# Getting temperature data

In this example, we will look at temperature data from the worldclim 2 data,
crop it for Western Europe, and then change the resolution to aggregate the
data. The first step is to get the worldclim layer for temperature (the codes
for each layers are in the function documentation):

```@example temp
using SimpleSDMLayers
temperature = worldclim(1)
```

Thanks to the integration with Plots and StatsPlots, we can very rapidly
visualize these data:

```@example temp
using Plots, StatsPlots
heatmap(temperature, c=:magma, frame=:box)
xaxis!("Longitude")
yaxis!("Latitude")
```

Let's also have a look at the density while we're at it:

```@example temp
density(temperature, frame=:zerolines, c=:grey, fill=(0, :grey, 0.5), leg=false)
xaxis!("Temperature", (-50,30))

```

The next step is to clip the data to the region of interest. This requires a the
coordinates of the bounding box as two tuples (for longitude and latitude) -- we
can also make a quick heatmap to see what the region looks like:

```@example temp
temperature_europe = temperature[(-10.0,30.0),(30.0,70.0)]
heatmap(temperature_europe, c=:magma)
```

The next step will be to coarsen these data, which requires to give the number
of cells to merge alongside each dimension. This number of cells must be a
divider of the grid size, which we can view with:

```@example temp
size(temperature_europe)
```

In an ideal world, we could want to find a number of cells that is the same both
for latitude and longitude, and one approach is to finagle our way into a
correct grid by changing the clipping region.

```@example temp
import Statistics
temperature_europe_coarse = coarsen(temperature_europe, Statistics.mean, (3, 3))
heatmap(temperature_europe_coarse)
```
