# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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

