# Getting temperature data

In this example, we will look at temperature data from the worldclim 2 data,
crop it for Western Europe, and then change the resolution to aggregate the
data.

```@example temp
temperature = worldclim(1)
```

```@example temp
using Plots, StatsPlots
heatmap(temperature, clim=(-50,50), c=:BrBG)
```
