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

```@example temp
density(temperature)
```

We will now clip this data, to focus on the region of interest:

```@example temp
temperature_europe = temperature[(-10.0,30.0),(30.0,70.0)]
heatmap(temperature_europe)
```

```@example temp
import Statistics
temperature_europe_coarse = coarsen(temperature_europe, Statistics.mean, (3, 3))
heatmap(temperature_europe_coarse)
```
