# Landcover consensus

In this example, we will create a consensus map of landcover for Corsica based
on the EarthEnv data, and measure the variation within each pixel using the
variance. The first step is to load the packages we need, and create a bounding
box:

```@example cons
using SimpleSDMLayers
using Plots

bbox = (left=8.25, right=10.0, bottom=41.2, top=43.2)
```

We will then do two things. First, get the first layer of landcover (see the
help of `landcover` for a list of the layers), and then create a datacube,
organized around dimensions of latitude, longitude, and layer value - we will
only focus on the 11 first variables, since we do not want the information on
open water (layer 12):

```@example cons
lc = SimpleSDMPredictor(EarthEnv, LandCover, 1; full=false, bbox...)
use = fill(NaN32, size(lc)..., 11)
```

At this point, we will simply fill in the first "slice" of our datacube with
values from the layer:

```@example cons
for (i,e) in enumerate(lc.grid)
    coord = (CartesianIndices(size(lc.grid))[i].I..., 1)
    if !isnothing(e)
        use[coord...] = e
    end
end
```

The next step is to repeat this process for all other layers, filling the
appropriate data cube slice:

```@example cons
for layer in 2:11
    lc = SimpleSDMpredictor(EarthEnv, LandCover, layer; full=false, bbox...)
    for (i,e) in enumerate(lc.grid)
        coord = (CartesianIndices(size(lc.grid))[i].I..., layer)
        if !isnothing(e)
            use[coord...] = e
        end
    end
end
```

To perform the actual analysis, we will define a `get_most_common_landuse` function, which will return the index of the layer with the highest score:

```@example cons
function get_most_common_landuse(f)
    f[isnan.(f)] .= 0.0
    sum(f) == 0 && return NaN
    return last(findmax(f))
end

function shannon(x)
    v = filter(!isnan, x)
    length(v) == 0 && return NaN
    v = v ./ sum(v)
    return -sum(v.*log2.(v))
end
```

```@example cons
consensus = mapslices(get_most_common_landuse, use; dims=3)[:,:,1]
entropy = mapslices(shannon, use; dims=3)[:,:,1]

consensus = SimpleSDMResponse(consensus, lc)
entropy = SimpleSDMResponse(entropy, lc)
```

```@example cons
p1 = plot(consensus, c=cgrad(:Set3_11, categorical=true), frame=:none)
p2 = plot(entropy, c=:bamako, frame=:none)

plot(p1, p2)
```
