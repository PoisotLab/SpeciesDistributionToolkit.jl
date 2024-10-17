# SDeMo

The `SDeMo` package is a collection of tools meant to help with species distribution
modeling education and training. It helps to think of it as a barebones ML package that is
pretty good at simple classification tasks (but designed to be extendable).

::: tip Uspe `SpeciesDistributionToolkit`

This website gives you access to the documentation of the functions that `SDeMo` implements.
For actual use, it is best to install and load `SpeciesDistributionToolkit`, which gives you
access to advanced data collection, manipulation, and visualization capacities.

:::

This package is not meant to be used for actual applications, but is intended to allow to
rapidly iterate on examples, and to rapidly experiment with different approaches to building
models. Both are required features for live demos and classroom usage. For this reason, the
number of methods is relatively small, in order to keep the need to refer to the
documentation to a minimum.

## Training and predicting

```@docs
train!
predict
reset!
```

## The type system

The package implements SDMs in three different ways:

- `SDM` are models that bind one dataset to one prediction pipeline
- `Bagging` bind one model to different bootstrap indices for trainig and evaluation
- `Ensemble` are a collection of many different models

Most of these models can be used interchangeably, *i.e.* you can use them within
cross-validation, Shapley values, partial responses, and counterfactual generation.


### Different types of models

```@docs
AbstractSDM
AbstractEnsembleSDM
```

### Model building blocks

```@docs
SDM
Transformer
Classifier
```

## Utility functions

### Access to model data and parameters

```@docs
features
labels
threshold
threshold!
variables
variables!
instance
```

### Access to model components

```@docs
classifier
transformer
```

