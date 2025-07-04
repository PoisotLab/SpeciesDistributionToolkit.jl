# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## `v1.5.0`

- **added** the `AdaBoost` model for boosting, currently the only `AbstractBoostedSDM`
- **added** the `reliability` method to get the data for a reliability curve
- **added** a vignette for boosting and probability calibration

## `v1.4.1`

- **fixed** a bug where the wrong checkpoint was restored during variable selection

## `v1.4.0`

- **added** support `Bagging` models as a component in an `Ensemble`
- **added** support for null classifiers based on `Bagging` models
- **added** variable selection for `Bagging` models [#405]
- **added** a more general syntax for variable selection (`VariableSelectionStrategy`)
- **added** a `ChainedTransform` type to chain two data transformation steps, useful for PCA + z-score [#408]
- **fixed** the issue with variable selection reseting the model variables [#400]
- **added** a method for `noselection!` where no folds are given

## `v1.3.4`

- **improved** the memory allocation of Logistic regression

## `v1.3.3`

- **fixed** the problem with hyper-parameters not being restored [#371]
- **fixed** the typing issue in Shapley values [#392]

## `v1.3.2`

- **fixed** a bug where the Shapley values calculation would not work when applied to a dataset not used for testing [#375]

## `v1.3.1`

- **fixed** a bug where the verbose output of variable selection was wrong [#372]

## `v1.3.0`

- **added** the option to report on validation loss when training a logistic [#365]
- **added** the option to pass arbitrary keywords to the training of the classifier
- **improved** the verbose output of logistic regression [#364]
- **improved** the internals of `train!` to use a simpler syntax
- **improved** the verbose output of variable selection [#366]

## `v1.2.3`

- **fixed** the threading mechanism for cross-validation [#458]
- **added** a QOL function to sum confusion matrices

## `v1.2.2`

- **added** the `verbose` field to `Logistic` to determine whether to print an output for gradient descent
- **added** the `interactions` field to `Logistic` to determine which interactions to include
- **changed** the creation of parameters for `Logistic` to allow only some interaction terms
- **improved** the performance (speed and memory consumption) of training logistic regressions

## `v1.2.1`

- **added** `Logistic` as a new classifier using logistic regression with gradient descent

## `v1.2.0`

- **changed** the default for bagging to maintain class balance in all bagged models

## `v1.1.2`

- **improved** the performance (speed and memory requirement) of prediction with Naive Bayes
- **improved** the performance (speed) of training BIOCLIM
- **improved** the performance (GC) of Shapley explanations
- **improved** the performance (speed) of variable importance

## `v1.1.1`

- **improved** the performance (speed and memory requirement) of training decision trees

## `v1.1.0`

- **added** backward selection with protected variables (to mirror forced variables in forward selection)
- **added** stratification of presence/absence for cross-validation (prevalence is maintained across folds)

## `v1.0.0`

- **changed** the default training option for transformers to be presence-only, with the `absences=true` keyword to use absences as well
- **added** the `transformer` and `classifier` methods, that return the transformer and classifier of `SDM` and `Bagging` models

