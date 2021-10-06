# # Variable selection with the VIF

using SimpleSDMLayers
using GLM
using Statistics

# **Justification for this case study:** A lot of predictive variables are
# auto-correlated, and therefore one might argue that maybe, we may eventually
# build better models by removing some of them. This is generally refered to as
# variable selection, and sharing one's opinion on this is the fastest way to
# start a brawl at any gathering of ecologists.

# We will illustrate variable selection with the Variance Inflation Factor using
# the bioclim data from Québec.

layers = SimpleSDMPredictor(
    WorldClim, BioClim, 1:19; left=-80.0, right=-56.0, bottom=44.0, top=62.0
)

# We will first gather everything in a matrix:

x = hcat([layer[keys(layer)] for layer in layers]...)

# Because of the spread of some values, we will center and reduce this matrix to
# give every variable a mean of 0 and unit variance:

X = (x .- mean(x; dims=1))./std(x; dims=1)

# The VIF is simply measured as 1/(1-R²) by regressing every variable against
# all others. Let's have an illustration with the first predictor:

lm(X[:,2:end], X[:,1]) |> r2 |> r -> 1/(1-r)

# The generally agreed threshold for a good VIF is 2, or 5, or 10 (so both
# "generally" and "agreed" are overstatements here), and as this one is higher,
# it suggests that we may not need all of these data.

# For this reason, we will go through an iterative process to get rid of
# variables one by one until the largest VIF is no larger than some threshold.
# Specifically, we get rid of the variable with the largest VIF first. Let's try
# this with the full sample:

vifs = zeros(Float64, length(layers))
for i in eachindex(layers)
    vifs[i] = lm(X[:,setdiff(eachindex(layers), i)], X[:,i]) |> r2 |> r -> 1/(1-r)
end
findmax(vifs)

# This is a good application for a recursive function. Let's write it this way.

function stepwisevif(layers::Vector{T}, selection=collect(1:length(layers)), threshold::Float64=5.0) where {T <: SimpleSDMLayer}
    x = hcat([layer[keys(layer)] for layer in layers[selection]]...)
    X = (x .- mean(x; dims=1))./std(x; dims=1)
    vifs = zeros(Float64, length(selection))
    for i in eachindex(selection)
        vifs[i] = lm(X[:,setdiff(eachindex(selection), i)], X[:,i]) |> r2 |> r -> 1/(1-r)
    end
    all(vifs .<= threshold) && return selection
    drop = last(findmax(vifs))
    popat!(selection, drop)
    return stepwisevif(layers, selection, threshold)
end

# This function will operate on a collection of layers, and starting from a
# selection (of indices), iterate until a subset satisfying max(VIF) < threshold
# is found. We can run this function on our entire dataset:

selected_variables_id = stepwisevif(layers)

# Finally, we can select the variables this process recommends:

layers[selected_variables_id]