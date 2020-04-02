# Working with GBIF data

In this example, we will see how we can make the packages `SimpleSDMLayers` and
[the `GBIF.jl` package][gbif] interact. We will specifically plot the
relationship between temperature and precipitation for a few occurrences of the
kingfisher *Megaceryle alcyon*.

[gbif]: https://ecojulia.github.io/GBIF.jl/dev/

```@example temp
using SimpleSDMLayers
using GBIF
temperature = worldclim(1)
precipitation = worldclim(12)
```

```@example temp
maximum(temperature)
minimum(temperature)
```

We can get some occurrences for the taxon of interest:

```@example temp
kingfisher = GBIF.taxon("Megaceryle alcyon", strict=true)
kf_occurrences = occurrences(kingfisher)
occurrences!(kf_occurrences)
occurrences!(kf_occurrences)
filter!(GBIF.have_ok_coordinates, kf_occurrences)
@info kf_occurrences
```

We can then extract the temperature for the first occurrence:

```@example temp
temperature[kf_occurrences[1]]
```

Because we will hardly need all of the surface in the `temperature` and
`precipitation` objects, we can clip them by the `GBIFRecords` object:

```@example temp
temperature_clip = clip(temperature, kf_occurrences)
precipitation_clip = clip(precipitation, kf_occurrences)
```

This will make the future queries faster. By default, the `clip` function will
ad a 5% margin on every side.

```@example temp
using Plots
using StatsPlots

temp = [temperature_clip[occ] for occ in kf_occurrences]
prec = [precipitation_clip[occ] for occ in kf_occurrences]

scatter(temp, prec)
```
