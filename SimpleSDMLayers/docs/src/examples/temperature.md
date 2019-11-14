# Getting temperature data

In this example, we will look at temperature data from the worldclim 2 data,
crop it for Western Europe, and then change the resolution to aggregate the
data.

```@example temp
using SimpleSDMLayers
temperature = worldclim(1)
```

```@example temp
using Plots, StatsPlots
heatmap(temperature, c=:magma, frame=:box)
xaxis!("Longitude")
yaxis!("Latitude")
```

```@example temp
density(temperature, frame=:zerolines, c=:grey, fill=(0, :grey, 0.5), leg=false)
xaxis!("Temperature", (-50,30))

```

We will now clip this data, to focus on the region of interest:

```@example temp
size(temperature_europe)
```

```@example temp
temperature_europe = temperature[(-10.0,30.0),(30.0,70.0)]
heatmap(temperature_europe)
```

```@example temp
import Statistics
temperature_europe_coarse = coarsen(temperature_europe, Statistics.mean, (3, 3))
heatmap(temperature_europe_coarse)
```
