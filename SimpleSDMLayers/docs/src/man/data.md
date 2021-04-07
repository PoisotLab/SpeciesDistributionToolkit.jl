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
`LayerDataset`, possibly with a future climate model and scenario. In all cases,
the method accepts either a single layer, or an array of layers.

| Data provider                    | Dataset                | Layers | Future models | Future scenarios                     |
| -------------------------------- | ---------------------- | ------ | ------------- | ------------------------------------ |
| `EarthEnv`                       | `Landcover`            | 12     |               |                                      |
| `EarthEnv`                       | `HabitatHeterogeneity` | 14     |               |                                      |
| [`WorldClim`][worldclim-current] | `BioClim`              | 19     | `CMIP6`       | `SharedSocioeconomicPathway`         |
| [`CHELSA`][chelsa-bioclim]       | `BioClim`              | 12     | `CMIP5`       | `RepresentativeConcentrationPathway` |
 
[earthenv-landcover]: http://www.earthenv.org/landcover
[earthenv-texture]: http://www.earthenv.org/texture
[worldclim-current]: https://www.worldclim.org/data/worldclim21.html
[chelsa-bioclim]: http://chelsa-climate.org/

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