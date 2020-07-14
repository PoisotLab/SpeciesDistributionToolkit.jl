# Landcover consensus

In this example, we will create a consensus map of landcover for Corsica based
on the EarthEnv data, and measure the variation within each pixel using the
variance. The first step is to load the packages we need, and create a bounding
box:

```@example cons
using SimpleSDMLayers
using Plots
using Statistics

bbox = (left=8.25, right=10.0, bottom=41.2, top=43.2)
```

We will then do two things. First, get the first layer of landcover (see the
help of `landcover` for a list of the layers), and then create a datacube,
organized around dimensions of latitude, longitude, and layer value - we will
only focus on the 11 first variables, since we do not want the information on
open water (layer 12):

```@example cons
lc = landcover(1; full=false, bbox...)
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
    lc = landcover(layer; full=false, bbox...)
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

function nonan_variance(x)
    v = filter(!isnan, x)
    length(v) == 0 && return NaN
    return Statistics.var(v)

```

```@example cons
consensus = mapslices(get_most_common_landuse, use; dims=3)[:,:,1]
variance = mapslices(nonan_variance, use; dims=3)[:,:,1]

consensus = SimpleSDMResponse(consensus, lc)
variance = SimpleSDMResponse(variance, lc)
```

```@example cons
p1 = plot(consensus, c=:Paired_11, frame=:grid)
p2 = plot(variance, c=:Greys, frame=:grid)

plot(p1, p2, size=(900, 400))
```
