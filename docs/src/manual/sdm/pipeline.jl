# # The model training pipeline

# The purpose of this vignette is to present the ways to train and predict with
# a model. This is not a complete overview of the features of the package, but
# rather a compendium of the ways to declare, train, and predict with a model.

using SpeciesDistributionToolkit
import Statistics
using CairoMakie

# The rest of the vignettes in this section present more advanced
# functionalities. In particular, the ones on
# [cross-validation](/manual/sdm/crossvalidation/), [variable
# selection](/manual/sdm/variableselection/), and
# [hyper-parameters](/manual/sdm/hyperparameters/) are key. 

# ## Data for a model

# Models require two sources of information to be trained. First, the features
# (a matrix of predictors); second, the labels (a vector of boolean values
# representing the presence of the species). Thankfully, the package is built so
# that we can get at this information through different ways, and these are
# notably:

# - a vector of spatial layers for the features, and two layers with boolean
#   values for the presence/absence
# - a vector of spatial layers for the features, and a collection of occurrences
#   for the presence/absence

# In addition, models can have geospatial information about the occurrences.

# A lot of vignettes will use a demonstration dataset which contains all three:

X, y, c = SDeMo.__demodata();

# ## Components of a model

# All models have three steps: the data transformation, the classifier, and the
# threshold. These are trained in sequence. The data transformation step is done
# in a way that avoids data leakage, which means that it is _only_ trained on
# values that are accessible to the model at the time where it is trained.

# The classifier is the algorithm used to transform the input values (possibly
# transformed) into a quantitative score. This score is then compared to the
# threshold, in order to return a yes/no answer.

# The syntax to build a model is 

model = SDM(ZScore, NaiveBayes, X, y, c)

# ::: info About coordinates
#
# When constructing a model from layers and occurrences, the coordinates of the
# instances will be added automatically. Having coordinates is useful to [plot
# models](/manual/dataviz/models/).
#
# :::

# We can check whether this model is georeferenced:

isgeoreferenced(model)

# And whether it is trained:

istrained(model)

# ## Training a model

# A model will by default train using all its available information.

train!(model)

# We can verify that the training actually happened:

istrained(model)

# It is possible to specify which instances are used for training. Generally
# speaking, this is useful for cross-validation, and the function for
# cross-validation will take care of this automatically.

# ## Thresholded v. unthresholded predictions

# A model can be used to make a prediction with no argument, in which case it
# will predict on its entire training set. For example, we can check how many
# predictions of "presence" the model makes:

sum(predict(model))

# The `predict` function can also take a vector (prediction for a single
# instance), or a matrix. Finally, it can also take a vector of spatial
# information.

# ::: info Models in space
#
# The use of models with spatial information is covered in more depth in the
# vignette on [training spatial models](/manual/distributions/training/).
#
# :::

# The `predict` function takes a `threshold` keyword argument, which defaults to
# `true`. When it is `false`, the function will return the score that is coming
# directly from the classifier. For example, we can get the score associated to
# the second training instance:

predict(model, X[:,2]; threshold=false)

# ::: info Scores and probabilities
#
# There is additional documentation covering the [calibration
# functions](/manual/sdm/calibration/), as well as an illustrative [vignette on
# spatial prediction of probabilities](/manual/distributions/adaboost/).
#
# :::

# The threshold of the model is optimized during training, and can be access
# with

threshold(model)

# ## Modifying a model

# The components of a model can be changed in real time.

# ::: tip But should they?
#
# It may be better to declare a new model. One case in which rapidly changing
# the classifier or transformer is useful is when trying different combinations
# in order to get the best fit.
#
# :::

# For example, we can move away from naive Bayes and use logistic regression:

classifier!(model, Logistic)

# Note that this marked the model as _untrained_:

istrained(model)

# So we can re-train it:

train!(model)

# ## Bagging

# Models can be aggregated into homogeneous ensembles, by using them as
# arguments to the `Bagging` function.

tree = SDM(PCATransform, DecisionTree, X, y, c)
forest = Bagging(tree, 50)

# We can also set each component model to use a different set of features:

bagfeatures!(forest)

# And we can now train this model:

train!(forest)

# The prediction for these models takes another argument, `consensus`, which is
# a function that, when called on a vector (the output of each model), will
# return a single value. For example, we can measure how many models agreed that
# the first training instance is a presence:

predict(forest, X[:,1]; consensus=sum)

# A particularly useful consensus function is `majority`, which will return the
# outcome of a majority consensus:

predict(forest, X[:,1]; consensus=majority)

# When predicting without the threshold, this can be used to measure the
# variability of the different models:

predict(forest, X[:,1]; threshold=false, consensus=iqr)

# ## Boosting

# We can use the AdaBoost approach to boost a component model. For the sake of
# argument, let's do a booster BIOCLIM. We only live once, and it's a very
# confusin experience, so we might as well embrace the weird.

why = AdaBoost(SDM(RawData, BIOCLIM, X, y, c), 50)
train!(why)

# ::: info More on boosting
#
# There is a more complete [vignette on
# AdaBoost](/manual/distributions/adaboost/), which also touches upon the issue
# of model calibration.
#
# :::

# This model can be used just like any other model:

predict(why, X[:,4])

# ## Heterogeneous ensembles

# Several models can be combined into an ensemble, which is done by using an
# array of models:

ensemble = Ensemble([
    SDM(RawData, Maxent, X, y, c),
    SDM(PCATransform, Logistic, X, y, c),
    SDM(RawData, NaiveBayes, X, y, c),
    Bagging(
        SDM(RawData, DecisionTree, X, y, c),
        50
    )
])
train!(ensemble)

# This model can be predicted just like an homogeneus ensemble, including using
# `threshold` and `consensus` keywords:

predict(ensemble, X[:,3]; threshold=false, consensus=Statistics.median)

# ## Related documentation

# ```@meta
# CollapsedDocStrings = true
# ```

# ```@docs; canonical=false
# SDM
# Bagging
# ```
