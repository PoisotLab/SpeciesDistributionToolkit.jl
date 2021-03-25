# Datasets

The package offers access to bioclimatic and other datasets - they are
downloaded, saved to the disk, and then read locally. Please note that some of
them require a lot of memory, so make sure your machine can handle them.

TODO make a refence to the environment variable

## General interface

TODO return as `SimpleSDMPredictors`

## Later providers

```@docs
LayerProvider
WorldClim
CHELSA
EarthEnv
```

## Layer datasets

```@docs
LayerDataset
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