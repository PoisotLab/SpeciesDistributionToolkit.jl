# # Interpreting models

# The purpose of this vignette is to show how to generate explanations from
# `SDeMo` models, using partial responses and Shapley values.

using SpeciesDistributionToolkit
using PrettyTables
using Statistics
using CairoMakie

# We will work on the demo data:

X, y, C = SDeMo.__demodata()
model = SDM(RawData, Maxent, X, y)
hyperparameters!(classifier(model), :product, true)
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
scatterlines!(ax, px, py; color = :black)
current_figure() #hide

# We can also look at a series of user-defined values:

x = quantile(features(model, 1), 0.0:0.05:1.0)
px, py = explainmodel(PartialResponse, model, 1, x; threshold = false);

#figure partialrespo-bio1
f = Figure()
ax = Axis(f[1, 1]; xlabel = "BIO1", ylabel = "Partial response")
scatterlines!(ax, px, py; color = :black)
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

# note that the order is variable then instance

# Note that we use `threshold=false` to make sure that we look at the score that
# is returned by the classifier, and not the thresholded version (_i.e._
# presence/absence). When called with no arguments, the `explainmodel` function
# will evaluate at each unique value of the predictor layer.

#figure partialrespo-bio1
f = Figure()
ax = Axis(f[1, 1]; xlabel = "BIO1", ylabel = "Partial response")
scatter!(ax, [features(model, 1)[1]], [predict(model; threshold=false)[1]], color=:black)
lines!(ax, px, py; color = :black)
current_figure() #hide

# We can also do this for two variables at a time

px, py, pz = explainmodel(CeterisParibus, model, vars, 1, 50; threshold = false);

#figure partialresp-surface
f = Figure()
ax = Axis(f[1, 1]; xlabel = "BIO$(variables(model)[1])", ylabel = "BIO$(variables(model)[2])")
cm = heatmap!(px, py, pz; colormap = Reverse(:batlowW), colorrange=(0, 1))
Colorbar(f[1, 2], cm)
current_figure() #hide

# ## Individual conditional expectations

# simply all the CP plots put together

#figure partialresp-surface
f = Figure()
ax = Axis(f[1, 1]; xlabel = "BIO1 (presences)", ylabel = "Partial response")
bx = Axis(f[2, 1]; xlabel = "BIO1 (absences)", ylabel = "Partial response")
for (i, l) in enumerate(labels(model))
    a = l ? ax : bx
    lines!(a, explainmodel(CeterisParibus, model, 1, i, 30; threshold = false)..., color=:black, alpha=0.1)
end
current_figure() #hide

# ## Partial dependence plot

# Average of the CP plots

px, py = explainmodel(SDeMo.PartialDependence, model, 1, 20; threshold = false);

#figure partialrespo-bio1
f = Figure()
ax = Axis(f[1, 1]; xlabel = "BIO1", ylabel = "Partial response")
lines!(ax, px, py; color = :black)
current_figure() #hide

# with two variables

px, py, pz = explainmodel(SDeMo.PartialDependence, model, vars, 50; threshold = false);

#figure partialresp-surface
f = Figure()
ax = Axis(f[1, 1]; xlabel = "BIO$(variables(model)[1])", ylabel = "BIO$(variables(model)[2])")
cm = heatmap!(px, py, pz; colormap = Reverse(:batlowW), colorrange=(0, 1))
Colorbar(f[1, 2], cm)
current_figure() #hide

# ## Shapley values

# We can perform the (MCMC version of) Shapley values measurement, using the
# `explain` method:

[explain(model, v; observation = 3, threshold = false) for v in variables(model)]

# These values are returned as the effect of this variable's value on the
# average prediction for this observation.

# We can also produce a figure that looks like the partial response curve, by
# showing the effect on a variable on each training instance:

#figure bio1-effect-map
f = Figure()
ax = Axis(f[1, 1]; xlabel = "BIO1", ylabel = "Effect on the average prediction")
scatter!(ax, features(model, 1), explain(model, 1; threshold = false))
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
