# # Feature importance

# The purpose of this vignette is to show how to measure the importance of
# features in a model.

using SpeciesDistributionToolkit
using CairoMakie
using PrettyTables

# We will start with the full set of BIOCLIM variables and the entire set of
# observations.

model = SDM(PCATransform, Logistic, SDeMo.__demodata()...)
variables!(model, ForwardSelection; included = [1])

# We will split the instances into a training and validation group using
# `holdout`:

train, test = holdout(model);

# ## Permutation importance

# We start by measuring the permutation importance of the features. There are
# several ways to perform this task, the first being by passing an array with
# the positions of training/testing instances:

featureimportance(PermutationImportance, model, 1, train, test)

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

# Note that we can also get the feature importance on all the training data:

featureimportance(PermutationImportance, model, 1)

# The feature importances are _relative_ values, so it is a good idea to express
# them as a proportion:

fi = [featureimportance(PermutationImportance, model, v) for v in variables(model)]
fi ./= sum(fi)
Dict(zip("BIO" .* string.(variables(model)), fi))

# ## Partial dependence importance

# see [vignette on interpretability](/manual/sdm/interpretability/)

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
