# # Building the BIOCLIM model

# **Justification for this use case:** `SImpleSDMLayers` can be used as a
# platform to build your own species distribution models. In this example, which
# assumes that you have read the vignettes on GBIF integration and variable
# selection through VIF, we will build our own version of the BIOCLIM model, and
# apply it to the distribution of *Alces alces* in Europe.

using SimpleSDMLayers
using GBIF
using Plots
using GLM
using StatsBase
using Statistics
using GeometryBasics

# BIOCLIM is a very simple model, which only requires presence information. The
# first step is therefore to get occurrences of *Alces alces* in Europe. We will
# specifically focus on Norway, Sweden, and Finland. Because the data in GBIF is
# only as good as the original data source, sometimes searching by `continent`
# gives fewer results than searching by country.

observations = occurrences(
    GBIF.taxon("Alces alces"; strict=true),
    "hasCoordinate" => "true",
    "country" => "NO",
    "country" => "DK",
    "country" => "SE",
    "country" => "FI",
    "limit" => 300,
)

# We will now page through a few additional results (300 at a time). In a real
# world context, we may want to download the entire dataset, or keep folds of it
# for validation. But for the sake of illustration, a few thousands occurrences
# are more than we need.

while length(observations) < min(10000, size(observations))
    occurrences!(observations)
end

# At this point, we could read the whole predictor variables directly, and then
# clip them. This would be fairly wasteful, as we need a small area. For this
# reason, we will calculate the bounding box first, and then use it to only read
# the section we want.

left, right = extrema(longitudes(observations)) .+ (-5, 5)
bottom, top = extrema(latitudes(observations)) .+ (-5, 5)
boundaries = (left=left, right=right, bottom=bottom, top=top)

# With this information in hand, we can start getting our variables. In this
# example, we will take all of the BioClim data from WorldClim, at the 5 arc
# minute resolution, and add the elevation layer. Note that using the bounding
# box coordinates when calling the layers is *much* faster than clipping after
# the fact (assuming that you already have the files downloaded).

predictors =
    convert.(
        Float32, SimpleSDMPredictor(WorldClim, BioClim, 1:19; resolution=10.0, boundaries...)
    );

# We will add the elevation to the stack of variables we use -- we need to
# convert everything to `Float32` layers, because elevation is originally an
# `Int16` one and a number of operations we will make will require floating
# points

push!(
    predictors,
    convert(
        Float32, SimpleSDMPredictor(WorldClim, Elevation; resolution=10.0, boundaries...)
    ),
);

# It is not a bad idea to plot all of the predictors:

plot(plot.(predictors, grid=:none, axes=false, frame=:none, leg=false, c=:imola)...)

# Clearly, some of them show strong autocorrelation; we will therefore re-use
# our VIF code to select a subset that has uncorrelated variables. 

function vif(model)
    R² = r2(model)
    return 1 / (1-R²)
end

function stepwisevif(
    layers::Vector{T}, selection=collect(1:length(layers)), threshold::Float64=5.0
) where {T<:SimpleSDMLayer}
    x = hcat([layer[keys(layer)] for layer in layers[selection]]...)
    X = (x .- mean(x; dims=1)) ./ std(x; dims=1)
    vifs = zeros(Float64, length(selection))
    for i in eachindex(selection)
        vifs[i] = vif(lm(X[:, setdiff(eachindex(selection), i)], X[:, i]))
    end
    all(vifs .<= threshold) && return selection
    drop = last(findmax(vifs))
    popat!(selection, drop)
    @info "Variables remaining: $(selection)"
    return stepwisevif(layers, selection, threshold)
end

# We will apply this function with the default parameters:

layers_to_keep = stepwisevif(predictors)

# When this is done, we can plot  the layers again to check that they are all
# more or less unique:

plot(
    plot.(
        predictors[layers_to_keep], grid=:none, axes=false, frame=:none, leg=false, c=:imola
    )...,
)

# The point of BIOCLIM (the model, not the dataset) is that the score assigned
# to a pixel is maximal if this pixel is the *median* value for a given
# variable. Therefore, we need to measure the cumulative density function for
# every pixel in every variable, and transform it with:

_pixel_score(x) = 2.0(x > 0.5 ? 1.0 - x : x);

# The *actual* model generation is fairly straightforward, as we will need to
# get the values of the layers in the cells occupied by an observation. Because
# sampling bias is very real, we will grid the observations by transforming them
# into a boolean layer:

presences = mask(predictors[1], observations, Bool)
plot(convert(Float32, presences); c=cgrad([:lightgrey, :black]), leg=false)

# This step is very important so as not to bias the estimation of quantiles,
# which overcounting observations within the same cell would do. We can now
# define the model:

function SDM(predictor::T1, observations::T2) where {T1<:SimpleSDMLayer,T2<:SimpleSDMLayer}
    _tmp = mask(observations, predictor)
    qf = ecdf(convert(Vector{Float32}, _tmp[keys(_tmp)])) # We only want the observed values
    return (_pixel_score ∘ qf)
end

# Note that we use the ∘ (`\circ`) operator to chain the quantile estimation and
# the pixel scoring, which requires Julia 1.4. This function returns a *model*,
# *i.e.* a function that we can broadcast to a given layer, which might not be
# the same one we used for the training.

# The next step in BIOCLIM is to get the *minimum* suitability across all layers
# for every pixel. Because we have a `min` method defined for a pair of layers,
# we can call `minimum` on an array of layers:

function SDM(predictors::Vector{T}, models) where {T<:SimpleSDMLayer}
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

plot(prediction; c=:bamako, frame=:box)
xaxis!("Longitude")
yaxis!("Latitude")

# Just because we may want to visualize this result in a transformed way, *i.e.*
# by looking at the quantiles of suitability, we can call the `rescale`
# function:

prediction_quantile = rescale(prediction, collect(0.0:0.005:1.0))

# As this map now represents the quantiles of suitability, we may want to remove
# the lower 5%. For this, we need to create a boolean mask, which we can do by
# broadcasting a conditional:

cutoff = broadcast(x -> x > 0.05, prediction_quantile)

# The raw prediction, minus the 5% bottom quantiles, can the be plotted:

plot(prediction; frame=:box, c=:lightgrey)
plot!(mask(cutoff, prediction); c=:bamako)
xaxis!("Longitude")
yaxis!("Latitude")

# And there it is! A simple way to write the BIOCLIM model by building on the
# integration between SimpleSDMLayers and GBIF.