# Landcover consensus

```@example cons
using SimpleSDMLayers
using Plots

bbox = (left=8.25, right=10.0, bottom=41.2, top=43.2)
```

```@example cons
lc = landcover(1; full=false, bbox...)
use = fill(NaN32, size(lc)..., 19)
```

```@example cons
for (i,e) in enumerate(lc.grid)
    coord = (CartesianIndices(size(lc.grid))[i].I..., 1)
    if !isnothing(e)
        use[coord...] = e
    end
end
```

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

```@example cons
function get_most_common_landuse(f)
    f[isnan.(f)] .= 0.0
    sum(f) == 0 && return NaN
    return last(findmax(f))
end

function shannon(x)
    u = unique(x)
    filter!(!isnan, u)
    length(u) == 0 && return NaN
    c = [count(x.==v) for v in u]
    p = c./sum(c)
    return -sum(p.*log2.(p))
end
```

```@example cons
consensus = mapslices(get_most_common_landuse, use; dims=3)[:,:,1]
entropy = mapslices(shannon, use; dims=3)[:,:,1]

consensus = SimpleSDMResponse(consensus, lc)
entropy = SimpleSDMResponse(entropy, lc)
```

```@example cons
p1 = plot(consensus, c=:Paired_11, frame=:grid)
p2 = plot(entropy, c=:Greys, frame=:grid, clim=(0,1))

plot(p1, p2, size=(900, 400), dpi=300)
```
