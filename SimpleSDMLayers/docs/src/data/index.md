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

| Data provider                     | Dataset                                     | Layers | Future models    | Future scenarios                                                   |
| --------------------------------- | ------------------------------------------- | ------ | ---------------- | ------------------------------------------------------------------ |
| `EarthEnv`                        | `Landcover`[→][earthenv-landcover]          | 12     |                  |                                                                    |
| `EarthEnv`                        | `HabitatHeterogeneity`[→][earthenv-texture] | 14     |                  |                                                                    |
| `WorldClim`[→][worldclim-current] | `BioClim`                                   | 19     | `CMIP6`          | `SharedSocioeconomicPathway`                                       |
| `CHELSA`[→][chelsa-bioclim]       | `BioClim`                                   | 12     | `CMIP5`, `CMIP6` | `RepresentativeConcentrationPathway`, `SharedSocioeconomicPathway` |

[earthenv-landcover]: http://www.earthenv.org/landcover
[earthenv-texture]: http://www.earthenv.org/texture
[worldclim-current]: https://www.worldclim.org/data/worldclim21.html
[chelsa-bioclim]: http://chelsa-climate.org/

## Providers and datasets

```@docs
SimpleSDMLayers.LayerProvider
SimpleSDMLayers.LayerDataset
```