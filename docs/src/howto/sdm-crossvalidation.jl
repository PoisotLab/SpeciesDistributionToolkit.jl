# # Training and cross-validation

# The purpose of this vignette is to show how to train and cross-validate
# `SDeMo` models.

using SpeciesDistributionToolkit
using CairoMakie
using PrettyTables
CairoMakie.activate!(; px_per_unit = 3) #hide
import Random #hide
Random.seed!(123451234123121); #hide

# We will work on the demo data:

X, y = SDeMo.__demodata()

# We will limit the model to two variables for the sake of illustration. We will
# train a simple decision tree with two variables:

sdm = SDM(RawData, DecisionTree, X, y)

# Note that the models are all composed of a transformer, and then a classifier;
# this means that `SDeMo` can be reasonably easy to extend (by defining a
# `train!` and a `predict` method for additional types you would like to
# include).

variables!(sdm, [1, 12])

# The cross-validation of a model requires a series of training/validation
# indices, and there are several convenience functions implemented:

folds = kfold(sdm)

# ::: tip Stratification
#
# By default, the sets of testing and training indices will always be
# stratified, so that they have the same prevalence. This is also true when
# using bagging for homogeneous ensemble models.
#
# :::

# We can cross-validate this model with:

cv = crossvalidate(sdm, folds);

# This returns the confusion matrices for the validation and training sets, in a
# named tuple:

mcc(cv.validation)

#-

mcc(cv.training)

# `SDeMo` has methods for the most common measures on a confusion matrix. For example, the true-skill statistics is:

trueskill(cv.training)

# And Cohen's κ:

κ(cv.training)

# It is a good idea to compare the value of different measures to some null
# classifiers:

measures = [mcc, ppv, npv, plr, nlr]
cvresult = [measure(set) for measure in measures, set in cv]
nullresult = [measure(null(sdm)) for measure in measures, null in [coinflip, noskill]]
pretty_table(
    hcat(string.(measures), hcat(cvresult, nullresult));
    alignment = [:l, :c, :c, :c, :c],
    backend = Val(:markdown),
    header = ["Measure", "Validation", "Training", "Coin-flip", "No-skill"],
    formatters = ft_printf("%5.3f", [2, 3, 4, 5]),
)

# Note that `crossvalidate` *does not* train the model. The point of
# `crossvalidate` is to decide whether the model should be trained. If the
# performance is good enough, training the model with all data is done with:

train!(sdm)

# Training the model will automatically optimize the threshold, using the MCC as
# a measure of optimal predictive ability.