# # Building the BIOCLIM model

# In this example, we will write the BIOCLIM species distribution model using
# `SimpleSDMLayers.jl` and `GBIF.jl`.

using SimpleSDMLayers
using GBIF
using Plots
using StatsBase
using Statistics
using GeometryBasics

# We will focus on the distribution of *Alces alces* in Europe, which has a high
# enough number of occurrences.

obs = occurrences(
    GBIF.taxon("Alces alces", strict=true),
    "hasCoordinate" => "true",
    "continent" => "EUROPE",
    "limit" => 300
)

# We will now page through a few additional results (300 at a time):

while length(obs) < min(5000, size(obs))
    occurrences!(obs)
end

# This query uses the `continent` parameter from GBIF, and in order to make sure
# that we get a relatively small region around the observations, we might define
# our own bounding box. Just to make sure that the bounding box is large enough,
# we will add a 5 degrees padding around it:

left, right = extrema([o.longitude for o in obs]) .+ (-5,5)
bottom, top = extrema([o.latitude for o in obs]) .+ (-5,5)

# With this information in hand, we can start getting our variables. In this
# example, we will take all of the BioClim data from WorldClim, at the 5 arc
# minute resolution, and add the elevation layer. Note that using the bounding
# box coordinates when calling the layers is *much* faster than clipping after
# the fact (assuming that you arleady have the files downloaded).

predictors = convert.(Float32, SimpleSDMPredictor(WorldClim, BioClim, 1:19; resolution=5.0, left=left, right=right, bottom=bottom, top=top));
push!(predictors, convert(Float32, SimpleSDMPredictor(WorldClim, Elevation; resolution=5.0, left=left, right=right, bottom=bottom, top=top)));

# The point of BIOCLIM (the model, not the dataset) is that the score assigned
# to a pixel is maximal if this pixel is the *median* value for a given
# variable. Therefore, we need to measure the cumulative density function for
# every pixel in every variable, and transform it with:

_pixel_score(x) = 2.0(x > 0.5 ? 1.0-x : x)

# The *actual* model generation is fairly straightforward, as we will need to
# get the values of the layers in the cells occupied by an observation. Because
# sampling bias is very real, we will grid the observations by transforming them
# into a boolean layer:

presences = mask(predictors[1], obs, Bool)

# This step is very important so as not to bias the estimation of quantiles,
# which overcounting observations within the same cell would do. We can now
# define the model:

function SDM(predictor::T1, observations::T2) where {T1 <: SimpleSDMLayer, T2 <: SimpleSDMLayer}
    _tmp = mask(observations, predictor)
    qf = ecdf(convert(Vector{Float32}, _tmp[keys(_tmp)])) # We only want the observed values
    return (_pixel_score∘qf)
end

# Note that we use the ∘ (`\circ`) operator to chain the quantile estimation and
# the pixel scoring, which requires Julia 1.4. This function returns a *model*,
# *i.e.* a function that we can broadcast to a given layer, which might not be
# the same one we used for the training.

# The next step in BIOCLIM is to get the *minimum* suitability across all layers
# for every pixel. Because we have a `min` method defined for a pair of layers,
# we can call `minimum` on an array of layers:

function SDM(predictors::Vector{T}, models) where {T <: SimpleSDMLayer}
    @assert length(models) == length(predictors)
    return minimum([broadcast(models[i], predictors[i]) for i in 1:length(predictors)])
end

# The advantage of this approach is that we can call the `SDM` method for
# prediction on a smaller layer, or a different layer. This can allow us to do
# thing like stitching layers together with `hcat` and `vcat` to use
# multi-threading, or use a different resolution for the prediction than we did
# for the training.

models = [SDM(predictor, presences) for predictor in predictors];

# We now get the prediction:

prediction = SDM(predictors, models)

# It's not a bad idea to look at this prediction, to get a sense of where the
# hotspots of presence would be:

plot(prediction, c=:viridis, frame=:box)
xaxis!("Longitude")
yaxis!("Latitude")

# Just because we may want to visualize this result in a transformed way, *i.e.*
# by looking at the quantiles of suitability, we can call the `rescale!`
# function:

rescale!(prediction, collect(0.0:0.005:1.0))

# As this map now represents the quantiles of suitability, we may want to remove
# the lower 5%. For this, we need to create a boolean mask, which we can do by
# broadcasting a conditional:

cutoff = broadcast(x -> x > 0.05, prediction)

# This map can be plotted as we would normally do:

plot(prediction, frame=:box, c=:lightgrey) # Plot a uniform background
plot!(mask(cutoff, prediction), clim=(0,1), c=:bamako)
xaxis!("Longitude")
yaxis!("Latitude")

# And there it is! A simple way to write the BIOCLIM model by building on the
# integration between SimpleSDMLayers and GBIF.