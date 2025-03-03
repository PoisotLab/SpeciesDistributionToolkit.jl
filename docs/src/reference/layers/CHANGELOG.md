# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

<!-- Added, Changed, Deprecated, Removed, Fixed -->

## `v1.2.1`

- **added** (back) `coarsen`

## `v1.2.0`

- **added** support for the NeutralLandcapes package (not currently supporting updaters)
- **removed** `Requires` as a dependency
- **changed** the Julia version to LTS (1.10)

## `v1.1.1`

- **added** an overload for clustering quality
- **added** an overload to transform a clustering result based on the vector of layers used to generate it

## `v1.1.0`

- **added** an extension for `Clustering` to support `kmeans` and `fuzzy_cmeans`
- **added** `burnin` and `burnin!` methods to write vectors into layers

## `v1.0.7`

- **added** support for the `⊻ ` operator
- **fixed** the `show` method for layers (especially when returning many) 

## `v1.0.6`

- **fixed** the export of the `interpolate!` method