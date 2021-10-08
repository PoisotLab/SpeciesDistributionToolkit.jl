# Datasets

The package offers access to bioclimatic and other datasets - they are
downloaded, saved to the disk, and then read locally. Please note that some of
them require a lot of memory, so make sure your machine can handle them.

By default, the layers are stored in the `assets` subfolder of the current
project. This being said, the prefered solution is to define a `SDMLAYERS_PATH`
environment variable pointing to a specific path, where the layers will live.
This will ensure that they are re-used between projects.

All layers are returned as `SimpleSDMPredictor`, and therefore constructed by
calling the `SimpleSDMPredictor` function on a `LayerProvider` and a
`LayerDataset`, possibly with a future climate model and scenario. In all cases,
the method accepts either a single layer, or an array of layers.

| Data provider | Dataset                | Layers | Future models    | Future scenarios                                                   |
| ------------- | ---------------------- | ------ | ---------------- | ------------------------------------------------------------------ |
| `EarthEnv`    | `Landcover`            | 12     |                  |                                                                    |
| `EarthEnv`    | `HabitatHeterogeneity` | 14     |                  |                                                                    |
| `WorldClim`   | `BioClim`              | 19     | `CMIP6`          | `SharedSocioeconomicPathway`                                       |
| `WorldClim`   | `Elevation`            | 1      | `Elevation`      |                                                                    |
| `CHELSA`      | `BioClim`              | 12     | `CMIP5`, `CMIP6` | `RepresentativeConcentrationPathway`, `SharedSocioeconomicPathway` |

## Providers and datasets

The `layernames` method (inputs are a provider and a dataset) will return a
tuple with the name of the layers.

### Data providers

```@docs
SimpleSDMLayers.LayerProvider
```

```@docs
WorldClim
CHELSA
EarthEnv
```

### Datasets

```@docs
SimpleSDMLayers.LayerDataset
```

```@docs
BioClim
LandCover
HabitatHeterogeneity
Elevation
```

## Future data

### CMIP5

```@docs
CMIP5
RepresentativeConcentrationPathway
```

### CMIP6

```@docs
CIMP6
SharedSocioeconomicPathway
```
