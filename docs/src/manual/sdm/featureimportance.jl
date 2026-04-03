# # Feature importance

# The purpose of this vignette is to show how to measure the importance of
# features in a model.

using SpeciesDistributionToolkit
using Statistics
using CairoMakie

# We will train a very simple model using the demonstration dataset:

model = SDM(RawData, Logistic, SDeMo.__demodata()...)

# We will then select variables using forward selection, but retaining the 1st
# and 12th variables (mean temperature, total precipitation).

variables!(model, ForwardSelection; included = [1, 12])

# ::: info Variable selection
#
# For more on variable selection, see [the
# vignette](/manual/sdm/variableselection/).There are additional techniques to
# decide which variables are included in a model.
#
# :::

# We will split the instances into a training and validation group using
# `holdout` -- this will be useful to illustrate the permutation importance,
# which works best when applied to a dataset that was not used for model
# training.

train, test = holdout(model);

# ## Permutation importance

# We start by measuring the permutation importance of the features.

# There are several ways to perform this task, the first being by passing an
# array with the positions of training/testing instances:

featureimportance(PermutationImportance, model, 1, train, test)

# ::: warning Interpretation of importance
#
# The ratio is measured as permuted score over true score, and the difference as
# permuted score minus true score. For this reason, the interpretation _must_
# depend on whether a higher value of the measure is associated to a better
# performance of the model. For cross-entropy loss, _lower_ values are best.
#
# :::

# The interpretation of this value depends on a few things, which are all set
# through keyword arguments. The first is the `optimality` measure -- by
# default, this is the `mcc`. The second is whether is the importance is
# measured as a `ratio` (the default, `true`) or a difference. For example, we
# can measure the importance of the same variable as "how much it decreases the
# F₁ measure when the data are shuffled" with

featureimportance(
    PermutationImportance,
    model,
    1,
    train,
    test;
    optimality = f1,
    ratio = false,
)

# We can also ask the importance for the model score (as opposed to the binary
# prediction):

featureimportance(
    PermutationImportance,
    model,
    1,
    train,
    test;
    optimality = crossentropyloss,
    threshold = false,
)

# Because this value is larger than unity, this means that the loss when this
# feature is shuffled is _larger_ than when the true values are used: it
# contributes positively to model performance.

# Note that we can also get the feature importance on all the training data:

featureimportance(PermutationImportance, model, 1; optimality = mcc)

# The feature importances are _relative_ values, so it is a good idea to express
# them as a proportion of all the variables used in the model:

fi = [1 - featureimportance(PermutationImportance, model, v; ratio=false) for v in variables(model)]
fi ./= sum(fi)
Dict(zip("BIO" .* string.(variables(model)), fi))

# ## Partial dependence importance

# We can also derive a measure of feature importance from the partial dependence
# plot of the model; this is covered in more depth in the [vignette on
# interpretability](/manual/sdm/interpretability/).

#figure PDP importance
f = Figure()
ax = Axis(f[1,1], xlabel="BIO1", ylabel="Effect")
vlines!(ax, features(model, 1), ymax=0.03, color=:grey70)
x, y = explainmodel(PartialDependence, model, 1, 50; threshold=false)
lines!(ax, x, y, color=:black)
hlines!(ax, mean(y), linestyle=:dash, color=:grey60)
tightlimits!(ax)
ylims!(ax, 0, 1)
current_figure() #hide

# Essentially, the more each point is far away from the average of the partial
# dependence curve (indicated by a dashed line on the above figure), the more
# this feature is important.

# Unlike with the permutation approach, this measure of feature importance does
# not take additional arguments. It can be applied without model re-training, as
# it measures importance on the model _response_.

fi = [
    featureimportance(PartialDependence, model, v; threshold = false) for
    v in variables(model)
]
fi ./= sum(fi)
Dict(zip("BIO" .* string.(variables(model)), fi))

# ## Related documentation

# ```@meta
# CollapsedDocStrings = true
# ```

# ```@docs; canonical=false
# SDeMo.featureimportance
# ```
