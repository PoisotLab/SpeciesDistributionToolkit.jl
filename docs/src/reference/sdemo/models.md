# Models

This page provides information about the models that are currently implemented. All models
have three components: a transformer to prepare the data, a classifier to produce
a quantitative prediction, and a threshold to turn it into a presence/absence prediction.
All three of these components are trained when training a model (plus or minus the keyword
arguments to `train!`).

::: warning Training of transformers

The transformers, by default, are only trained on the *presences*. This is because, in most
cases, the pseudo-absences are sampled from the background. When the model uses actual
absences, passing `absences=true` to functions that train the model will instead use the
absence data as well.

:::

## Transformers (univariate)

```@docs
RawData
ZScore
```

## Transformers (multivariate)

The multivariate transformers are using [`MultivariateStats`](https://juliastats.org/MultivariateStats.jl/dev/) to handle the training data. During projection, the features are projected using the transformation that was learned from the training data.

```@docs
PCATransform
WhiteningTransform
MultivariateTransform
```

## Classifiers

```@docs
NaiveBayes
BIOCLIM
DecisionTree
```

::: tip Adding new models

Adding a new transformer or classifier is relatively straightforward (refer to the
implementation of `ZScore` and `BIOCLIM` for easily digestible examples). The only methods
to implement are `train!` and `StatsAPI.predict`.

:::
