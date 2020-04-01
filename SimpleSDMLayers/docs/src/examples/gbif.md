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

We can get some occurrences for the taxon of interest:

```@example temp
kingfisher = GBIF.taxon("Megaceryle alcyon", strict=true)
kf_occurrences = occurrences(kingfisher)
occurrences!(kf_occurrences)
occurrences!(kf_occurrences)
filter!(GBIF.have_ok_coordinates, kf_occurrences)
```

We can then extract the temperature for the first occurrence:

```@example temp
temperature[kf_occurrences[1]]
```
