# # Working with GBIF data

# **Justification for this use case:** building species distribution models
# requires information of where species are. In this document, we will see how
# the `SimpleSDMLayers` and `GBIF` packages interact, as a first step to get in
# a usable state. Specifically, we will work on the occurences of the
# relationship between temperature and precipitation for a few occurrences of
# the fungus *Hypomyces lactifluorum*, which will be the taxon used for all
# SDM-related vignettes.

using SimpleSDMLayers
using GBIF
using Plots
using Statistics

# We will focus on showing where on the temperature/precipitation space the
# occurrences are, so we will download these layers:

temperature, precipitation = SimpleSDMPredictor(WorldClim, BioClim, [1, 12])

# And now, we can follow the GBIF documentation to get some occurrences

observations = occurrences(
    GBIF.taxon("Hypomyces lactifluorum"; strict=true),
    "hasCoordinate" => "true",
    "country" => "CA",
    "country" => "US",
    "limit" => 300,
)
while length(observations) < size(observations)
    occurrences!(observations)
end

@info observations

# We can then extract the temperature for the first occurrence:

temperature[observations[1]]

# Of course, it would be unwieldy to do this for every occurrence in our dataset,
# and so we will see a way do it much faster. But first, we do not need the entire
# surface of the planet to perform our analysis, and so we will instead clip the
# layers:

temperature = clip(temperature, observations)
precipitation = clip(precipitation, observations)

# This will make the future queries a little faster. By default, the `clip`
# function will ad a 5% margin on every side. To get the values of a layer at
# every occurrence in a `GBIFRecord`, we simply pass the records as a position:

histogram2d(temperature, precipitation; c=:devon, frame=:zerolines, leg=false, lab="")
scatter!(
    temperature[observations],
    precipitation[observations];
    lab="",
    c=:white,
    msc=:orange,
    alpha=0.2,
)
xaxis!("Temperature (°C)")
yaxis!("Precipitation (mm)")

# This will return a record of all data for all geo-localized occurrences
# (*i.e.* neither the latitude nor the longitude is `missing`) in a
# `GBIFRecords` collection, as an array of the `eltype` of the layer. Note that
# the layer values can be `nothing`, in which case you might need to run
# `filter(!isnothing, temperature_clip[kf_occurrences]` for it to work with the
# plotting functions.

# We can also plot the records over space, using the overloads of the `latitudes`
# and `longitudes` functions:

contour(temperature; c=:cork, frame=:box, fill=true, clim=(-20, 20), levels=6)
scatter!(
    longitudes(observations), latitudes(observations); lab="", c=:white, msc=:orange, ms=2
)

# We can finally make a layer with the number of observations per cells:

presabs = mask(temperature, observations, Float32)
plot(log1p(presabs); c=:tokyo)

# Because the cells are rather small, and there are few observations, this is not
# necessarily going to be very informative - to get a better sense of the
# distribution of observations, we can get the average number of observations in a
# radius of 100km around each cell (we will do so for a zoomed-in part of the map
# to save time):

zoom = clip(presabs; left=-80.0, right=-65.0, top=50.0, bottom=40.0)
buffered = slidingwindow(zoom, Statistics.mean, 100.0)
plot(buffered; c=:tokyo, frame=:box)
scatter!(
    longitudes(observations),
    latitudes(observations);
    lab="",
    c=:white,
    msc=:orange,
    ms=2,
    alpha=0.5,
)
