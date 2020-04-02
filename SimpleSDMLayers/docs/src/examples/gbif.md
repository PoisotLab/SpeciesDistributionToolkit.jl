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

# We will get some more occurrences
for i in 1:9
  occurrences!(kf_occurrences)
end

filter!(GBIF.have_ok_coordinates, kf_occurrences)
@info kf_occurrences
```

We can then extract the temperature for the first occurrence:

```@example temp
temperature[kf_occurrences[1]]
```

Of course, it would be unwieldy to do this for every occurrence in our dataset,
and so we will see a way do it much faster. But first, we do not need the entire
surface of the planet to perform our analysis, and so we will instead clip the
layers:

```@example temp
temperature_clip = clip(temperature, kf_occurrences)
precipitation_clip = clip(precipitation, kf_occurrences)
```

This will make the future queries a little faster. By default, the `clip`
function will ad a 5% margin on every side. To get the values of a layer at
every occurrence in a `GBIFRecord`, we simply pass the records as a position:

```@example temp
histogram2d(temperature_clip, precipitation_clip, c=:viridis)
scatter!(temperature_clip[kf_occurrences], precipitation_clip[kf_occurrences], lab="", c=:white, msc=:orange)
```

This will return a record of all data for all geo-localized occurrences (*i.e.*
neither the latitude nor the longitude is `missing`) in a `GBIFRecords`
collection, as an array of the `eltype` of the layer.

We can also plot the records over space, using the overloads of the `latitudes`
and `longitudes` functions:

```@example temp
contour(precipitation_clip, c=:YlGnBu, title="Precipitation", frame=:box, fill=true)
scatter!(longitudes(kf_occurrences), latitudes(kf_occurrences), lab="", c=:white, msc=:orange)
```

These extensions of `SimpleSDMLayers` functions to work with the `GBIF` package
are meant to greatly simplify the expression of more complex pipelines, notably
for actual species distribution modeling.
