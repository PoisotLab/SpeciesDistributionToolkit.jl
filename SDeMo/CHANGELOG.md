# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## Unreleased - 2026-03

- **added** support for `OccurrencesInterface` [#569]
- **added** `MaxEnt` as a classifier

## `v1.8.0` - 2026-02-27

- **added** an overload of `copy` for SDMs
- **added** `Conformal` and related functions for conformal prediction [#538]
- **added** `transformer!` and `classifier!` to switch models [#539]
- **added** `istrained` to check that the model is trained [#513]
- **added** support for training point coordinates to `SDM`
- **added** a Makie extension for georeferenced SDMs [#545]
- **changed** the syntax to declare SDMs in most tests to streamline it (this is not a breaking, user-facing change)
- **fixed** a bug where calling `reset!` would use a magic number threshold instead of the correct `zero`
- **fixed** a bug where the `gmean` mesure of model performance had no method for vectors of confusion matrices

## `v1.7.1` - 2025-12-05

- **added** support for rebalanced leave one out, with `rebalanced` keyword argument [#529]
- **added** support to set the variables for `AdaBoost`
- **fixed** the weights of an `AdaBoost` when re-training

## `v1.7.0` - 2025-12-04

- **added** a learning rate hyperparameter (`η`, in (0, Inf.)) to `AdaBoost` [#530]

## `v1.6.1` - 2025-11-19

- **added** tests for reliability curve and calibration
- **improved** the performance of applying `PlattCalibration` [#522]
- **added** support for the weights in PAVA [#521]
- **improved** the thread safety of `Bagging` training
- **improved** the performance of `DecisionTree`

## `v1.6.0` - 2025-11-15

- **added** support for isotonic calibration
- **changed** `JSON` requirements to 1 [#507]

## `v1.5.5` - 2025-11-04

- **fixed** a bug in decision trees that would return the wrong probability [#517]

## `v1.5.4` - 2025-10-31

- **fixed** a bug where multivariate transforms predicted on the unscaled predictors

## `v1.5.3` - 2025-10-31

- **added** a `show` method for `ConfusionMatrix`
- **added** a method to divide a `ConfusionMatrix` by a number
- **fixed** the need to use ZScore before logistic and multivariate transforms

## `v1.5.2` - 2025-08-19

- **fixed** support for decision stubs

## `v1.5.1` - 2025-07-31

- **improved** the performance of `train!`
- **fixed** the traininig of the threshold to use validation data when there are enough
- **fixed** the bags being returned as a `Vector{Any}`
- **added** a method for `crossvalidate` using `kfold` when no folds are given
- **added** a method for `threshold!` that cross-validates the threshold for the SDM
- **added** a method for `fscore` that takes the value of β as an argument and returns a function
- **added** a `gmean` function

## `v1.5.0` - 2025-07-03

- **added** the `AdaBoost` model for boosting, currently the only `AbstractBoostedSDM`
- **added** the `reliability` method to get the data for a reliability curve
- **added** a vignette for boosting and probability calibration

## `v1.4.1` - 2025-06-17

- **fixed** a bug where the wrong checkpoint was restored during variable selection

## `v1.4.0` - 2025-03-20

- **added** support `Bagging` models as a component in an `Ensemble`
- **added** support for null classifiers based on `Bagging` models
- **added** variable selection for `Bagging` models [#405]
- **added** a more general syntax for variable selection (`VariableSelectionStrategy`)
- **added** a `ChainedTransform` type to chain two data transformation steps, useful for PCA + z-score [#408]
- **fixed** the issue with variable selection reseting the model variables [#400]
- **added** a method for `noselection!` where no folds are given

## `v1.3.4` - 2025-03-08

- **improved** the memory allocation of Logistic regression

## `v1.3.3` - 2025-03-05

- **fixed** the problem with hyper-parameters not being restored [#371]
- **fixed** the typing issue in Shapley values [#392]

## `v1.3.2` - 2025-03-02

- **fixed** a bug where the Shapley values calculation would not work when applied to a dataset not used for testing [#375]

## `v1.3.1` - 2025-10-28

- **fixed** a bug where the verbose output of variable selection was wrong [#372]

## `v1.3.0` - 2025-02-27

- **added** the option to report on validation loss when training a logistic [#365]
- **added** the option to pass arbitrary keywords to the training of the classifier
- **improved** the verbose output of logistic regression [#364]
- **improved** the internals of `train!` to use a simpler syntax
- **improved** the verbose output of variable selection [#366]

## `v1.2.3` - 2025-02-24

- **fixed** the threading mechanism for cross-validation [#458]
- **added** a QOL function to sum confusion matrices

## `v1.2.2` - 2025-02-14

- **added** the `verbose` field to `Logistic` to determine whether to print an output for gradient descent
- **added** the `interactions` field to `Logistic` to determine which interactions to include
- **changed** the creation of parameters for `Logistic` to allow only some interaction terms
- **improved** the performance (speed and memory consumption) of training logistic regressions

## `v1.2.1` - 2025-02-13

- **added** `Logistic` as a new classifier using logistic regression with gradient descent

## `v1.2.0` - 2025-02-13

- **changed** the default for bagging to maintain class balance in all bagged models

## `v1.1.2` - 2025-02-27

- **improved** the performance (speed and memory requirement) of prediction with Naive Bayes
- **improved** the performance (speed) of training BIOCLIM
- **improved** the performance (GC) of Shapley explanations
- **improved** the performance (speed) of variable importance

## `v1.1.1` - 2025-12-13

- **improved** the performance (speed and memory requirement) of training decision trees

## `v1.1.0` - 2024-12-05

- **added** backward selection with protected variables (to mirror forced variables in forward selection)
- **added** stratification of presence/absence for cross-validation (prevalence is maintained across folds)

## `v1.0.0` - 2024-10-26

- **changed** the default training option for transformers to be presence-only, with the `absences=true` keyword to use absences as well
- **added** the `transformer` and `classifier` methods, that return the transformer and classifier of `SDM` and `Bagging` models

