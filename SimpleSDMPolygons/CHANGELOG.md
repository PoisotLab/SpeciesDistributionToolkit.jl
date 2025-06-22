# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## `v1.1.3`

- **fixed** the difference between `Bioregions` and `Ecoregions` [#482]
- **fixed** an issue with the `EPA` provider not getting the right level [#481]
- **fixed** the name of the `Resolve` provider [#480]

## `v1.1.2`

- **fixed** plotting support to use `Makie` instead of `MakieCore`

## `v1.1.1`

- **added** tests to a few polygon providers [#452]

## `v1.1.0`

- **added** `OneEarth` dataset of ecoregions [#442]
- **added** indexing of `FeatureCollections` by the "name" property, and arbitrary pairs of property keys/values [#449]
- **added** the `getproperty` method for `Feature`s
- **added** the `getname` method for `Feature`s (an alias for `getproperty(feat, "Name")`)
- **added** the `uniqueproperties` for `FeatureCollections` method

## `v1.0.5`

- **fixed** the GeoInterface for polygons

## `v1.0.4`

- **added** Makie support for `lines!`/`poly!` without axis argument

## `v1.0.3`

- **fixed** a typo in the `GADM` URL

## `v1.0.2`

- **added** support for `lines`/`lines!` in Makie
- **added** a `boundingbox` method

## `v1.0.1`

- **added** a `getpolygon` method which is more explicit than `downloader`
- **fixed** the overloading of methods from `SimpleSDMDatasets`

## `v1.0.0`

- Initial version of the package
