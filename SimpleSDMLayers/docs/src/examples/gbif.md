# Working with GBIF data

In this example, we will see how we can make the packages `SimpleSDMLayers` and
[the `GBIF.jl` package](https://ecojulia.github.io/GBIF.jl/dev/) interact. We
will specifically plot the relationship between temperature and precipitation
for a few occurrences of the kingfisher *Megaceryle alcyon*.

```@example temp
using SimpleSDMLayers
using GBIF
using Plots
using Statistics
temperature, precipitation = worldclim([1,12])
```

We can get some occurrences for the taxon of interest:

```@example temp
kingfisher = GBIF.taxon("Megaceryle alcyon", strict=true)
kf_occurrences = occurrences(kingfisher, "hasCoordinate" => "true", "decimalLatitude" => (0.0, 65.0), "decimalLongitude" => (-180.0, -50.0), "limit" => 200)

for i in 1:4
  occurrences!(kf_occurrences)
end

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
Note that the layer values can be `nothing`, in which case you might need to
run `filter(!isnothing, temperature_clip[kf_occurrences]` for it to work with 
the plotting functions.

We can also plot the records over space, using the overloads of the `latitudes`
and `longitudes` functions:

```@example temp
contour(temperature_clip, c=:alpine, title="Precipitation", frame=:box, fill=true)
scatter!(longitudes(kf_occurrences), latitudes(kf_occurrences), lab="", c=:white, msc=:orange, ms=2)
```

These extensions of `SimpleSDMLayers` functions to work with the `GBIF` package
are meant to greatly simplify the expression of more complex pipelines, notably
for actual species distribution modeling.

We can finally make a layer with the number of observations per cells:

```@example temp
presabs = mask(precipitation_clip, kf_occurrences, Float32)
```

Because the cells are rather small, and there are few observations, this is not
necessarily going to be very informative - to get a better sense of the
distribution of observations, we can get the average number of observations in a
radius of 100km around each cell (we will do so for a zoomed-in part of the map
to save time):

```@example temp
zoom = presabs[left=-100., right=-75.0, top=43.0, bottom=20.0]
buffered = slidingwindow(zoom, Statistics.mean, 100.0)
plot(buffered, c=:lapaz, legend=false, frame=:box)
scatter!(longitudes(kf_occurrences), latitudes(kf_occurrences), lab="", c=:white, msc=:orange, ms=2, alpha=0.5)
```

