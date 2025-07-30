# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## `v1.7.1`

- **fixed** SDT level dispatch `boundingbox` for `MultiPolygon`s

## `v1.7.0`

- **added** Zenodo integration to get a DOI for each release

## `v1.6.3`

- **fixed** a bug where `SDMLayer`s could not be masked by a `FeatureCollection` [#477]

## `v1.6.2`

- **fixed** a bug where `AbstactOccurrenceCollection` could not be masked by a `FeatureCollection` [#476]

## `v1.6.1`

- **changed** `Phylopic` requirement to 1 [#430]

## `v1.6.0`

- **added** the `SimpleSDMPolygons` package [#417]

## `v1.5.1`

- **removed** the support for `SimpleSDMLayers` plotting (now handled in the package) [#422]
- **removed** the support for `OccurrencesInterface` plotting (now handled in the package) [#422]

## `v1.5.0`

- **replaced** the pseudo absences data by the `PseudoAbsences` package [#411]

## `v1.4.3`

- **improved** the performance of polygon masking with threading
- **added** a `mask` method for layers and polygons (in addition to `mask!` and similar to `trim`)
- **fixed** the `simplify`/`simplify!` functions to ensure that the first and last points are the same

## `v1.4.2`

- **added** an `openstreetmap` method (not exported) to get various GeoJSON limits from plan-text queries
- **added** a `simplify` and `simplify!` method to remove some complexity from OSM polygons
- **fixed** the vignettes so they don't use GADM

## `v1.4.1`

- **fixed** a bug where GeoJSON GADM files were not readable by `ZipFiles`
- **added** a dependency on `ZipArchives`
- **removed** a dependency on `ZipFile`

## `v1.4.0`

- **added** (preliminary) support for STAC via an extension

## `v1.3.2`

- **added** a method for `boundingbox` on a vector of abstract occurrences
- **added** methods for `latitude` and `longitude` on a vector of abstract occurrences

## `v1.3.1`

- **added** support for nightly in github actions
- **improved** the performance of pseudo-absence distance to event by making it threaded

## `v1.3.0`

- **changed** Julia requirement to LTS
- **changed** the github actions to work on LTS and latest release
- **added** support for `SpatialBoundaries` wombling through an extension
- **added** `SpatialBoundaries` version 0.2 *(WEAKDEP)*
- **added** tutorials for spatial boundaries and virtual species
- **improved** the CI time by preventing a run of the full test suite when testing SDT

## `v1.2.4`

- **improved** the performance of measuring distances from observed presence data

## `v1.2.3`

- **changed** the compat entry of `MakieCore` from `0.8` to `0.8, 0.9`

## `v1.2.2`

- **fixed** dispatch of masking a vector of layers using polygons to work on any
`Vector{<:SDMLayer}`

## `v1.2.1`

- **improved** the performance of masking a vector of layers using polygons

## `v1.2.0`

- **added** `SimpleSDMDatasets` version 1

## `v1.1.1`

- **fixed** issues with the download of some GADM files

## `v1.1.0`

- **added** `boundingbox` method to get the left, right, bottom, top coordinates of an object in WGS84

## `v1.0.0`

- **added** `OccurrencesInterface` version 1
- **added** `Fauxcurrences` version 1
- **added** `GBIF` version 1
- **added** `SDeMo` version 1
