# Getting landcover data

In this example, we will look at landcover data for the proportion of
urban/built area in Europe; this dataset is very large to fit in memory, so we
will take advantage of the ability to only load the part that matters by passing
the limits of a bounding box.

```@example urban
using SimpleSDMLayers
urban = landcover(1; left=-11.0, right=31.1, bottom=29.0, top=71.1)
```

This dataset is returning data as `UInt8` (as it represents a proportion of the
pixel), but this is not something that can be plotted efficiently. So in the
next step, we will manipulate this object a little bit to have something more
workable.

Let's start by preparing a new grid, with the same dimensions, but a friendlier
type, and then we can then fill these values using a simple rule:

```@example urban
n_urban_grid = zeros(Float32, size(urban));
for (i,e) in enumerate(urban.grid)
  n_urban_grid[i] = isnothing(e) ? NaN : Float32(e)
end
```

And now we can rewrite our `urban` object as

```@example urban
urban = SimpleSDMPredictor(n_urban_grid, urban)
```

Note that this uses a shortcut where the bounding box from a new
`SimpleSDMLayer` is drawn from the bounding box for a previous one.

```@example urban
using Plots
heatmap(urban)
```
