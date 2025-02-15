# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).


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
