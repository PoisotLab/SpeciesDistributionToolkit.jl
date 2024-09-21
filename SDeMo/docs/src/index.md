# Tools for SDM demos and education

## The prediction pipeline

```@docs
SDM
Transformer
Classifier
```

### Utility functions

```@docs
features
labels
threshold
variables
```

### Transformers (univariate)

```@docs
RawData
ZScore
```

### Transformers (multivariate)

### Classifiers

```@docs
NaiveBayes
BIOCLIM
```

### Training and prediction

```@docs
train!
predict
```

### Other model functions

```@docs
reset!
```

## Cross-validation

### Confusion matrix

```@docs
ConfusionMatrix
```

### Folds

These method will all take as input a vector of labels and a matrix of features,
and return a vector of tuples, that have the training indices in the first
position, and the validation data in the second. This is not true for `holdout`,
which returns a single tuple.

```@docs
holdout
montecarlo
leaveoneout
kfolds
```

### Cross-validation

```@docs
crossvalidate
```

### List of performance measures

## Feature selection

## Feature importance

## Shapley values

## Counterfactuals

## Partial responses

## IO and utility functions

## Bagging

```@docs
Bagging
outofbag
bootstrap
```
