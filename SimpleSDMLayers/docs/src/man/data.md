# Datasets

The package offers access to bioclimatic and other datasets - they are
downloaded, saved to the disk, and then read locally. Please note that some of
them require a lot of memory, so make sure your machine can handle them.

By default, the layers are stored in the `assets` subfolder of the current
project. This being said, the prefered solution is to define a `SDMLAYERS_PATH`
environment variable pointing to a specific path, where the layers will live.
This will ensure that they are re-used between projects.

## General interface

All layers are returned as `SimpleSDMPredictor`, and therefore constructed by
calling the `SimpleSDMPredictor` function on a `LayerProvider` and a
`LayerDataset`, possibly with a future climate model and scenario.

## Later providers

```@docs
SimpleSDMLayers.LayerProvider
WorldClim
CHELSA
EarthEnv
```

## Layer datasets

```@docs
SimpleSDMLayers.LayerDataset
BioClim
LandCover
HabitatHeterogeneity
```

## Future climate models

```@docs
SharedSocioeconomicPathway
RepresentativeConcentrationPathway
CMIP5
CMIP6
```

## File reading and writing

```@docs
SimpleSDMLayers.ascii
geotiff
```