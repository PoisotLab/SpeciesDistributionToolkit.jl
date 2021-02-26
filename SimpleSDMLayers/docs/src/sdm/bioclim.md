# Writing BIOCLIM from scratch

In this example, we will write the BIOCLIM species distribution model using
`SimpleSDMLayers.jl` and `GBIF.jl`.

```@example bioclim
using SimpleSDMLayers
using GBIF
using Plots
using StatsBase
```

We can get some occurrences for the taxon of interest:

```@example bioclim
serval = GBIF.taxon("Leptailurus serval", strict=true)
obs = occurrences(serval, "hasCoordinate" => "true", "continent" => :AFRICA)
[occurrences!(obs) for page in 1:9]
```

Before we get the layers, we will figure out the bounding box for the
observations:

```@example bioclim
left, right = extrema([o.longitude for o in obs]) .+ (-2,2)
bottom, top = extrema([o.latitude for o in obs]) .+ (-2,2)
```

With this information in hand, we can start getting our variables.