# Transformers and classifiers

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

```@docs
PCATransform
MultivariateTransform
```

## Classifiers

```@docs
NaiveBayes
BIOCLIM
DecisionTree
```
