# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## `v1.3.1`

- **fixed** plotting support to use `Makie` instead of `MakieCore`

## `v1.3.0

- **fixed** a deprecation in the syntax of MultivariateStats
- **added** the `reclassify` function to change layer values using rules [#407]
- **added** the `cellarea` function in replacement of `cellsize` [#416]

## `v1.2.2`

- **added** a Makie extension [#422]

## `v1.2.1`

- **improved** performance of looking up values based on coordinates by using binary search via `Base.Sort.searchsortedfirst` [#342]
- **added** (fixed) support for the `MultivariateStats` package through an extension (currently supporting PCA and variants, and whitening)
- **added** (back) `coarsen` [#347]

## `v1.2.0`

- **added** support for the `NeutralLandcapes` package through an extension (not currently supporting updaters) [#368]
- **removed** `Requires` as a dependency
- **changed** the Julia version to LTS (1.10)

## `v1.1.1`

- **added** an overload for clustering quality [#356]
- **added** an overload to transform a clustering result based on the vector of layers used to generate it [#357]

## `v1.1.0`

- **added** an extension for `Clustering` to support `kmeans` and `fuzzy_cmeans`
- **added** `burnin` and `burnin!` methods to write vectors into layers

## `v1.0.7`

- **added** support for the `⊻ ` operator
- **fixed** the `show` method for layers (especially when returning many) 

## `v1.0.6`

- **fixed** the export of the `interpolate!` method
