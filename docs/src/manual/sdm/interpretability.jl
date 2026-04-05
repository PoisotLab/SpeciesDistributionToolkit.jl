# # Interpreting models

# The purpose of this vignette is to show how to generate explanations from
# `SDeMo` models, using partial responses and Shapley values.

using SpeciesDistributionToolkit
using PrettyTables
using Statistics
using CairoMakie

# We will work on the demo data:

X, y, C = SDeMo.__demodata()
model = SDM(RawData, Logistic, X, y)
hyperparameters!(classifier(model), :interactions, :self)
variables!(model, StrictVarianceInflationFactor{10.0}; included = [1])
variables!(model, ForwardSelection; included = [1])

# Model explanations require a trained model, a choice of an explanation method
# (`PartialResponse` or `CeterisParibus`, as well as `PartialDependence`), and
# additional arguments to decide where the responses will be predicted. These
# functions work on either one or two variables.

# ## Partial responses

# Partial responses work by setting the value of all variables to their average
# value, and then varying the value of the variable of interest on a given range
# of values. It allows to examine how the model is reacting to a change in a
# focal variable, in the context of the average value of all other variables.

px, py = explainmodel(PartialResponse, model, 1; threshold = false);

# The order of arguments is always the type of response, then the model, then the variable(s). Some methods also have a 

# Note that we use `threshold=false` to make sure that we look at the score that
# is returned by the classifier, and not the thresholded version (_i.e._
# presence/absence). When called with no arguments, the `explainmodel` function
# will evaluate at each unique value of the predictor layer.

#figure partialrespo-bio1
f = Figure()
ax = Axis(f[1, 1]; xlabel = "BIO1", ylabel = "Partial response")
lines!(ax, px, py; color = :black)
current_figure() #hide

# Alternatively, we can set the number of equally spaced steps to use:

px, py = explainmodel(PartialResponse, model, 1, 15; threshold = false);

#figure partialrespo-bio1
f = Figure()
ax = Axis(f[1, 1]; xlabel = "BIO1", ylabel = "Partial response")
scatter!(ax, px, py; color = :black, marker=:rect)
current_figure() #hide

# We can also look at a series of user-defined values:

x = quantile(features(model, 1), 0.0:0.02:1.0)
px, py = explainmodel(PartialResponse, model, 1, x; threshold = false);

#figure partialrespo-bio1-quantiles
f = Figure()
ax = Axis(f[1, 1]; xlabel = "BIO1", ylabel = "Partial response")
scatter!(ax, px, py; color = :black, marker=:rect)
current_figure() #hide

# We can also show the response surface using two variables:

vars = (variables(model)[1], variables(model)[2])
px, py, pz = explainmodel(PartialResponse, model, vars, 20; threshold = false);

# Note that the last element returned in this case is a two-dimensional array,
# as it makes sense to visualize the result as a surface.

#figure partialresp-surface
f = Figure()
ax = Axis(f[1, 1]; xlabel = "BIO$(variables(model)[1])", ylabel = "BIO$(variables(model)[2])")
cm = heatmap!(px, py, pz; colormap = Reverse(:batlowW), colorrange=(0, 1))
Colorbar(f[1, 2], cm)
current_figure() #hide

# Inflated partial responses replace the average value by other values drawn
# at random from the pool of existing variables:

px, py = explainmodel(PartialResponse, model, vars, 10; inflated=true, threshold = false);

#figure inflated-curve
f = Figure()
ax = Axis(f[1, 1])
px, py = explainmodel(PartialResponse, model, 1; inflated = false, threshold = false)
for i in 1:300
    ix, iy = explainmodel(PartialResponse, model, 1; inflated = true, threshold = false)
    lines!(ax, ix, iy; color = (:grey, 0.2))
end
lines!(ax, px, py; color = :black, linewidth = 4)
current_figure() #hide

# ## Ceteris paribus plots

# CP plots are _for a single instance_ by keeping non focal variables and then
# replace by all values of the focal variable(s)

px, py = explainmodel(CeterisParibus, model, 1, 1, 50; threshold = false);

# ::: warning Additional argument
#
# The CP plot explanation requires an additional argument, which is the position
# of the instance at which the response must be evaluated. The order of
# arguments is model, then variable, then instance.
#
# :::

# Note that we use `threshold=false` to make sure that we look at the score that
# is returned by the classifier, and not the thresholded version (_i.e._
# presence/absence). When called with no arguments, the `explainmodel` function
# will evaluate at each unique value of the predictor layer.

#figure cp-bio1
f = Figure()
ax = Axis(f[1, 1]; xlabel = "BIO1", ylabel = "Partial response")
scatter!(ax, [features(model, 1)[1]], [predict(model; threshold=false)[1]], color=:black)
lines!(ax, px, py; color = :black)
current_figure() #hide

# We can also do this for two variables at a time

px, py, pz = explainmodel(CeterisParibus, model, vars, 1, 20; threshold = false);

#figure cp-twovar-surface
f = Figure()
ax = Axis(f[1, 1]; xlabel = "BIO$(variables(model)[1])", ylabel = "BIO$(variables(model)[2])")
cm = heatmap!(px, py, pz; colormap = Reverse(:batlowW), colorrange=(0, 1))
Colorbar(f[1, 2], cm)
current_figure() #hide

# ## Individual conditional expectations

# The ICE plot is quite simply all of the CP plots at the same time. Here,
# instances that are positive in the training data are in purple.

#figure ice-plot
f = Figure()
ax = Axis(f[1, 1]; xlabel = "BIO1", ylabel = "Partial response")
for (i, l) in enumerate(labels(model))
    col = l ? :purple : :grey50
    lab = l ? "Presences" : "Absences"
    lines!(ax, explainmodel(CeterisParibus, model, 1, i, 50; threshold = false)..., color=col, alpha=0.1)
end
current_figure() #hide

# ## Partial dependence plot

# The partial dependence plot is the average of all CP plots.

px, py = explainmodel(SDeMo.PartialDependence, model, 1, 50; threshold = false);

#figure partial-dep-onevar
f = Figure()
ax = Axis(f[1, 1]; xlabel = "BIO1", ylabel = "Partial response")
lines!(ax, px, py; color = :black)
current_figure() #hide

# We can also produce it for two variables, using the same syntax as before.
# Note that in this case, we look at the prediction of the model _with_ a
# threshold, so the resulting plot will indicate how strongly the model would
# predict the presence of the species for a pair of values of these two
# variables:

px, py, pz = explainmodel(SDeMo.PartialDependence, model, vars, 100; threshold = true);

#figure partialresp-surface
f = Figure()
ax = Axis(f[1, 1]; xlabel = "BIO$(variables(model)[1])", ylabel = "BIO$(variables(model)[2])")
cm = heatmap!(px, py, pz; colormap = Reverse(:batlowW), colorrange=(0, 1))
Colorbar(f[1, 2], cm)
current_figure() #hide

# ::: info Feature importance
#
# The partial dependence curve also serves as a measure of [feature
# importance](/manual/sdm/featureimportance/), as explained in the relevant
# vignette.
#
# :::

# ## Shapley values

# We can perform the (MCMC version of) Shapley values measurement, using
# `ShapleyMC` as the first argument to `explainmodel`. For example, we can check
# how much the prediction for the third instance was shifted by the value of the
# first variable:

feat, inst = 1, 3
explainmodel(ShapleyMC, model, feat, inst)

# As for all other `explainmodel` methods, the results are returned as a tuple
# with the feature value, and the response.

# ::: tip Interpretation of Shapley values
#
# The Shapley values measure the _difference to the average prediction_, and so
# they exist on a different scale compared to the other responses we have seen
# in this vignette.
#
# :::

# We can also produce a figure that looks like the partial response curve, by
# showing the effect of a variable on each training instance:

#figure bio1-shap-value
f = Figure()
ax = Axis(f[1, 1]; xlabel = "BIO1", ylabel = "Effect on the average prediction")
scatter!(ax, explainmodel(ShapleyMC, model, 1; threshold=false)..., color=:black)
current_figure() #hide

# ## Related documentation

# ```@meta
# CollapsedDocStrings = true
# ```

# ```@docs; canonical=false
# SDeMo.explain
# SDeMo.explainmodel
# SDeMo.CeterisParibus
# SDeMo.PartialResponse
# SDeMo.PartialDependence
# SDeMo.ModelExplanation
# ```
