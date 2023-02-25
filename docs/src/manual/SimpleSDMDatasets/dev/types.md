# Type system for datasets

Note that all datasets **must** be a direct subtype of `RasterDataset`, all
providers **must** be a direct subtype of `RasterProvider`, all scenarios
**must** be a direct subtype of `FutureScenario`, and all models **must** be a
direct subtype of `FutureModel`. If you need to aggregate multiple models within
a type (*e.g.* `CMIP6Scenarios`), use a `Union` type. The reason for this
convention is that in interactive mode, `subtype` will let users pick the data
combination they want.

## Type system overview

```@docs
RasterData
RasterDataset
RasterProvider
```

## List of datasets

```@docs
BioClim
Elevation
MinimumTemperature
MaximumTemperature
AverageTemperature
Precipitation
SolarRadiation
WindSpeed
WaterVaporPressure
LandCover
HabitatHeterogeneity
Topography
```

## List of providers

```@docs
WorldClim2
EarthEnv
CHELSA1
CHELSA2
```

## List of enumerated types

```@docs
SimpleSDMDatasets.RasterDownloadType
SimpleSDMDatasets.RasterFileType
```
