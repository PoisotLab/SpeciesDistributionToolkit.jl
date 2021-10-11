# # Generating pseudo absences

using SimpleSDMLayers
using Plots
using GBIF
using StatsBase

# **Justification for this use case:** by contrast to the BIOCLIM model from the
# previous use case, many models require background knowledge about where the
# species is *not*, which is rarely available. For this reason, we often need to
# resort to generating pseudo-absences, by applying various guesses based on
# where we know species are.

# In this example, we will see how to generate pseudo-absences (according to
# [Barbet-Massin *et
# al.*](https://besjournals.onlinelibrary.wiley.com/doi/10.1111/j.2041-210X.2011.00172.x))
# using three methods: radius-based, surface range envelope, and random
# selection. To begin with, we will occurrences for the Lobster mushroom in
# Canada and the US.

sp = GBIF.taxon("Hypomyces lactifluorum")
observations = occurrences(sp, "hasCoordinate" => true, "limit" => 300, "country" => "CA", "country" => "US")
while length(observations) < size(observations)
    occurrences!(observations)
end

# In order to have a layer to start working, we will get the precipitation
# layer:

layer = clip(SimpleSDMPredictor(WorldClim, BioClim, 12), observations)

# We can visualize the results of this query:

plot(layer, c=:devon)
scatter!(longitudes(observations), latitudes(observations), lab="", msw=0.0, ms=1, c=:orange)

# The first step here is to remove the redundancy in observations: multiple
# observations in the same cell do not really convey a lot of information. For
# this reason, we can create a very sparse layer with only presences:

presences = mask(layer, observations, Bool)

# This is enough to start generating pseudo-absences. We will first use the
# `RandomSelection` method, which will pick positions anywhere on the layer
# *except* in places that are already occupied. Because our species has one
# occurrence far away in Alaska this might not be  the best method, but this is
# a simple one to grasp.

rs_pa = rand(RandomSelection, presences)

# We can plot this layer to see what it looks like:

plot(convert(Float32, rs_pa), c=:Greys, leg=false)
scatter!(longitudes(observations), latitudes(observations), lab="", msw=0.0, ms=1, c=:orange)

# This is obviously not ideal, as there are pseudo-absences very far from the
# observations. An alternative is to use the `SurfaceRangeEnvelope` method,
# which is limited to the bounding box of observations.

sre_pa = rand(SurfaceRangeEnvelope, presences)

# We can plot this layer to see what it looks like:

plot(convert(Float32, sre_pa), c=:Greys, leg=false)
scatter!(longitudes(observations), latitudes(observations), lab="", msw=0.0, ms=1, c=:orange)

# It is a little bit better, but the extreme point means that the surface range
# envelope is very large -- in addition, the species has a distribution with
# large gaps in it, so we are going to experiment with the `WithinRadius`
# method.

# This method will allow pseudo-absences to be within a set distance (expressed
# in degrees) of any given observation, excluding the grid cells for which we
# already have an observation. The default distance is 1 degree.

wr_one_pa = rand(WithinRadius, presences)

# This function can take a little longer to run, as it involves a clipping step
# based on circles around the presences; this will be optimized in the future.

# We can plot this layer to see what it looks like:

plot(convert(Float32, wr_one_pa), c=:Greys, leg=false)
scatter!(longitudes(observations), latitudes(observations), lab="", msw=0.0, ms=1, c=:orange)

# This is a much better distribution of pseudo-absences! Of course, the
# consequences of which pseudo-absence method to pick is key in the accuracy of
# the model. The `WithinRadius` method may not always perform better. In fact,
# in the Boosted Regression Tree exmaple, we will see how `SurfaceRangeEnvelope`
# gives excellent results.