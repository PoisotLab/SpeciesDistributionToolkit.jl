# # BRTs for species distribution forecasting

using SimpleSDMLayers
using EvoTrees
using GBIF
using StatsBase
using StatsPlots

# **Justification for this use case:** Boosted Regression Trees (BRTs) are a
# powerful way to predict the distribution of species. We will see how we can
# get information in and out of layers to use them, and how to use this model to
# predict a new distribution under a climate change scenario. This use-case
# assumes that you have read the manual pages for GBIF integration, future data,
# and pseudo-absences generation.

# We will re-use the data from the pseudo-absences example:

sp = GBIF.taxon("Hypomyces lactifluorum")
observations = occurrences(
    sp, "hasCoordinate" => true, "limit" => 300, "country" => "CA", "country" => "US"
)
while length(observations) < size(observations)
    occurrences!(observations)
end

# We will pick the entire BioClim layers at a 10 minutes resolution, and clip
# them to the observations (this adds a 5 degrees buffer).

layers = [
    clip(layer, observations) for layer in SimpleSDMPredictor(WorldClim, BioClim, 1:19)
];

# To remove the sampling effect, we transform the presences to a grid, and
# generate pseudo-absences using the surface range envelope method.

presences = mask(layers[1], observations, Bool)
absences = rand(SurfaceRangeEnvelope, presences)

# The next step is to extract coordinates at which the species is present or
# pseudo-absent - we can rely on the `replace` method to empty any `false`
# values:

xy_presence = keys(replace(presences, false => nothing));
xy_absence = keys(replace(absences, false => nothing));
xy = vcat(xy_presence, xy_absence);

# With the `xy` list of coordinates, we can get a predictor `X`, and a response
# `y`.

X = hcat([layer[xy] for layer in layers]...);
y = vcat(fill(1.0, length(xy_presence)), fill(0.0, length(xy_absence)));

# To train the model, we will use a random subset representing 70% of the
# dataset:

train_size = floor(Int, 0.7 * length(y));
train_idx = sample(1:length(y), train_size; replace=false);
test_idx = setdiff(1:length(y), train_idx);

# This gives use the training and testing (or evaluation) sets:

Xtrain, Xtest = X[train_idx, :], X[test_idx, :];
Ytrain, Ytest = y[train_idx], y[test_idx];

# In order to fit the tree, we need to define a number of parameters. We will
# use a Gaussian maximum likelihood tree (from `EvoTrees`), which will give us a
# measure of the average prediction, but also the standard deviation. This is
# important in order to communicate uncertainty.

gaussian_tree_parameters = EvoTreeGaussian(;
    loss=:gaussian,
    metric=:gaussian,
    nrounds=100,
    nbins=100,
    λ=0.0,
    γ=0.0,
    η=0.1,
    max_depth=7,
    min_weight=1.0,
    rowsample=0.5,
    colsample=1.0,
)

# We can now fit the BRT. This function has an additional `print_every_n` to
# update on the progress every `n` epochs, but we don't really need it here.

model = fit_evotree(gaussian_tree_parameters, Xtrain, Ytrain; X_eval=Xtest, Y_eval=Ytest)

# The next step is to gather *all* the values of all the layers in a matrix, in
# order to run the full spatial prediction:

all_values = hcat([layer[keys(layer)] for layer in layers]...);

# If the matrix is too big, we could resort to a combination of `clip`, make the
# prediction on each tile, and then use `hcat` and `vcat` to combine them. This
# is not the case here, so we can predict directly:

pred = EvoTrees.predict(model, all_values);

# Once the prediction is done, we can copy the values into a layer.

distribution = similar(layers[1], Float64)
distribution[keys(distribution)] = pred[:, 1]
distribution

# The BRT is able to calculate a measure of relative gain from the different
# variables:

top5_var = importance(model, collect(layernames(WorldClim, BioClim)))[1:5]

# This is an interesting alternative to VIF for variable selection. Let's
# examine how the most important variable relates to the predicted distribution
# score:

most_important_layer = findfirst(isequal(top5_var[1].first), collect(layernames(WorldClim, BioClim)))
histogram(
    layers[most_important_layer][xy_presence]; fill=(0, :teal, 0.2), lc=:teal, frame=:origin, lab="Present"
)
histogram!(
    layers[most_important_layer][xy_absence]; fill=(0, :white, 0.0), frame=:origin, lc=:grey, lab="Absent"
)
xaxis!(layernames(WorldClim, BioClim, most_important_layer))

# It is interesting to notice that despite the importance of this predictor, the
# difference between the presence and absence locations are not as clear as we
# may expect!

# We can similarly extract uncertainty:

uncertainty = similar(layers[1], Float64)
uncertainty[keys(uncertainty)] = pred[:, 2]
uncertainty

# And we can now visualize the prediction, which we force to be in `[0,1]`.

p_dis = plot(rescale(distribution, (0, 1)); c=:bamako, frame=:box)
scatter!(xy_presence; lab="", c=:black, alpha=0.2, msw=0.0, ms=3)

# We can do the same thing for the uncertainty

p_unc = plot(uncertainty; c=:tokyo, frame=:box)

# Of course, this prediction is returing values for the entire range of the
# initial layer, so let's compare the distributions of the prediction score:

histogram(
    distribution[xy_presence]; fill=(0, :teal, 0.2), lc=:teal, frame=:origin, lab="Present"
)
histogram!(
    distribution[xy_absence]; fill=(0, :white, 0.0), frame=:origin, lc=:grey, lab="Absent"
)
xaxis!("Prediction score")

# This looks like a good opportunity to do some thresholding. Note that the
# values are *not* moved back to the unit range, because we'll need the raw
# values for a little surprise later on. We will find the value of the score
# that optimizes Youden's J (Cohen's κ is also a suitable alternative):

cutoff = LinRange(extrema(distribution)..., 500);

obs = y .> 0

tp = zeros(Float64, length(cutoff));
fp = zeros(Float64, length(cutoff));
tn = zeros(Float64, length(cutoff));
fn = zeros(Float64, length(cutoff));

for (i, c) in enumerate(cutoff)
    prd = distribution[xy] .>= c
    tp[i] = sum(prd .& obs)
    tn[i] = sum(.!(prd) .& (.!obs))
    fp[i] = sum(prd .& (.!obs))
    fn[i] = sum(.!(prd) .& obs)
end

# From this, we can calculate a number of validation measures:

tpr = tp ./ (tp .+ fn);
fpr = fp ./ (fp .+ tn);
J = (tp ./ (tp .+ fn)) + (tn ./ (tn .+ fp)) .- 1.0;
ppv = tp ./ (tp .+ fp);

# The ROC-AUC is an overall measure of how good the fit is:

dx = [reverse(fpr)[i] - reverse(fpr)[i - 1] for i in 2:length(fpr)]
dy = [reverse(tpr)[i] + reverse(tpr)[i - 1] for i in 2:length(tpr)]
AUC = sum(dx .* (dy ./ 2.0))

# We can pick the value of the cutoff that maximizes J:

thr_index = last(findmax(J))
τ = cutoff[thr_index]

# Let's have a look at the ROC curve:

plot(fpr, tpr; aspectratio=1, frame=:box, lab="", dpi=600, size=(400, 400))
scatter!([fpr[thr_index]], [tpr[thr_index]]; lab="", c=:black)
plot!([0, 1], [0, 1]; c=:grey, ls=:dash, lab="")
xaxis!("False positive rate", (0, 1))
yaxis!("True positive rate", (0, 1))

# And the precision-recall as well:

plot(tpr, ppv; aspectratio=1, frame=:box, lab="", dpi=600, size=(400, 400))
scatter!([tpr[thr_index]], [ppv[thr_index]]; lab="", c=:black)
plot!([0, 1], [1, 0]; c=:grey, ls=:dash, lab="")
xaxis!("True positive rate", (0, 1))
yaxis!("Positive predictive value", (0, 1))

# We can now map the result using τ as a cutoff for the `distribution` data:

range_mask = broadcast(v -> v >= τ, distribution)

# And finally, plot the whole thing:

plot(distribution; c=:lightgrey, leg=false)
plot!(mask(range_mask, distribution); c=:darkgreen)
scatter!(xy_presence; lab="", c=:orange, alpha=0.5, msw=0.0, ms=2)

# Because our BRT also returns the uncertainty, we can combine both maps into a
# bivariate one, showing both where we expect the species, but also where we are
# uncertain about the prediction:

plot(distribution; leg=false, c=:lightgrey, frame=:grid, xlab="Longitude", ylab="Latitude", grid=false)
bivariate!(mask(range_mask, distribution), mask(range_mask, uncertainty))
p2 = bivariatelegend!(
    mask(range_mask, distribution),
    mask(range_mask, uncertainty);
    inset=(1, bbox(0.04, 0.08, 0.23, 0.23, :center, :left)),
    subplot=2,
    xlab="Prediction",
    ylab="Uncertainty",
    guidefontsize=7,
)

# Now, for the big question - will this range move in the future? To explore
# this, we will get the same variables, but in the future. In order to simplify
# the code, we will limit ourselves to one SSP (585) and one CMIP6 model
# (CanESM5), around 2050:

future_layers = [
    clip(layer, observations) for
    layer in SimpleSDMPredictor(WorldClim, BioClim, CanESM5, SSP585, 1:19; year="2041-2060")
];

# We can get all the future values from this data:

all_future_values = hcat([layer[keys(layer)] for layer in future_layers]...);

# And make a prediction based on our BRT model. This is, of course, assuming
# that BRTs are good at this type of prediction (they're OK).

future_pred = EvoTrees.predict(model, all_future_values);

# As before, we also have a measure of uncertainty. In the interest of keeping
# this vignette small, we will not look at it.

future_distribution = similar(layers[1], Float64)
future_distribution[keys(future_distribution)] = future_pred[:, 1]
future_distribution

# The values in `future_distribution` are in the scale of what the BRT returns,
# so we can compare them with the values of `distribution`:

plot(future_distribution - distribution; clim=(-1, 1), c=:broc, frame=:box)

# This shows the area of predicted gain and loss of presence. Because we have
# thresholded our current distribution, we can look at the predicted ranges of
# suitability:

future_range_mask = broadcast(v -> v >= τ, future_distribution)

# The last step is to get the difference between the future and current masks
# (so +1 is a gain of range, 0 is no change, and -1 is a loss), and to only
# report this for the cells that are both in the current and future data:

range_change = convert(Float32, future_range_mask) - convert(Float32, range_mask)
both_ranges_mask = maximum([future_range_mask, range_mask])

# We can now plot the result, with the brown area being range that becomes
# unfavorable, the green one remaining suitable, and the blue area being newly
# opened range:

plot(distribution; c=:lightgrey, leg=false)
plot!(mask(both_ranges_mask, range_change); c=:roma)
