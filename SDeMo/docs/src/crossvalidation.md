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

## Null classifiers

```@docs
noskill
coinflip
constantnegative
constantpositive
```

## List of performance measures

```@docs
tpr
tnr
fpr
fnr
ppv
npv
fdir
fomr
plr
nlr
accuracy
balancedaccuracy
f1
fscore
trueskill
markedness
dor
κ
mcc
```

## Confidence interval

```@docs
ci
```

## Aliases

```@docs
SDeMo.specificity
SDeMo.sensitivity
SDeMo.recall
SDeMo.precision
```