# Working with GBIF data

In this example, we will see how we can make the packages `SimpleSDMLayers` and
[the `GBIF.jl` package](https://ecojulia.github.io/GBIF.jl/dev/) interact. We
will specifically plot the relationship between temperature and precipitation
for a few occurrences of the kingfisher *Megaceryle alcyon*.

```@example temp
using SimpleSDMLayers
using GBIF
using Plots
using StatsPlots
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
ad a 5% margin on every side. We can now loop through the occurrences and
extract the data at every point, for example with `[temperature_clip[occ] for
occ in kf_occurrences]`, but this is a little bit tedious. We will instead rely
on the following notation:

```@example temp
temp = temperature_clip[kf_occurrences]
prec = precipitation_clip[kf_occurrences]

histogram2d(temperature_clip, precipitation_clip)
scatter!(temp, prec, lab="")
```

This will return a record of all data for all geo-localized occurrences in a
`GBIFRecords` collection.

We can also plot the records over space, using the overloads of the `latitudes`
and `longitudes` functions:

```@example temp
contour(precipitation_clip, c=:YlGnBu, title="Precipitation", frame=:box, fill=true)
scatter!(longitudes(kf_occurrences), latitudes(kf_occurrences))
```
