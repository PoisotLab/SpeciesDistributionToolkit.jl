# Cross-validation

## Confusion matrix

```@docs
ConfusionMatrix
```

## Folds

These methods will all take as input a vector of labels and a matrix of features,
and return a vector of tuples, that have the training indices in the first
position, and the validation data in the second. This is not true for `holdout`,
which returns a single tuple.

```@docs
holdout
montecarlo
leaveoneout
kfold
```

## Cross-validation

```@docs
crossvalidate
```

## List of performance measures

## Null classifiers

```@docs
noskill
coinflip
constantnegative
constantpositive
```
