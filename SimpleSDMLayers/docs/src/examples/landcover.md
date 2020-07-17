# Getting landcover data

In this example, we will look at landcover data, specifically the proportion of
urban/built area in Europe; the entire dataset is very large to fit in memory,
as it has a resolution of about 1 kilometre squared. Therefore, we will take
advantage of the ability to only load the part that matters by passing the
limits of a bounding box.

```@example urban
using SimpleSDMLayers
urban = landcover(9; left=-11.0, right=31.1, bottom=29.0, top=71.1)
```

This dataset is returning data as `UInt8` (as it represents a proportion of the
pixel occupied by the type), but this is not something that can be plotted efficiently. So in the
next step, we will manipulate this object a little bit to have something more
workable.

Let's start by preparing a new grid, with the same dimensions, but a friendlier
type, and then we can then fill these values using a simple rule of using either
`NaN` or the converted value:

```@example urban
n_urban_grid = zeros(Float32, size(urban));
for (i,e) in enumerate(urban.grid)
  n_urban_grid[i] = isnothing(e) ? NaN : Float32(e)
end
```

We can now overwrite our `urban` object as a layer:

```@example urban
urban = SimpleSDMPredictor(n_urban_grid, urban)
```

Note that the previous instruction uses a shortcut where the bounding box from a
new `SimpleSDMLayer` is drawn from the bounding box for an existing layer. With
this done, we can show the results:

```@example urban
using Plots
heatmap(urban, c=:terrain)
```
