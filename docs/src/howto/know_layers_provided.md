# ... know which layers are provided?

This page gives an overview of the methods to get access to additional
information about the data available through different data providers. Note that
the documentation website has a series of auto-generated pages that summarize
the same information.

```@example 1
using SpeciesDistributionToolkit
using InteractiveUtils
```

Note that when working from the REPL, `InteractiveUtils` is loaded by default.

Data are identified by a `RasterProvider` (*e.g.* the initiative or website
providing the data), and a `RasterDataset` that is a collection of layers
representing specific information.

## Listing the providers

```@example 1
subtypes(RasterProvider)
```

## Listing the datasets associated to a provider

The `provides` method from `SimpleSDMDatasets` will return `true` if the provide
offers the dataset:

```@example 1
[ds for ds in subtypes(RasterDataset) if SimpleSDMDatasets.provides(WorldClim2, ds)]
```

## Datasets with multiple layers

The `layers` and `layerdescriptions` methods return a list of layers:

```@example 1
SimpleSDMDatasets.layers(RasterData(CHELSA2, BioClim))
```

```@example 1
SimpleSDMDatasets.layerdescriptions(RasterData(CHELSA2, BioClim))
```

## Related documentation

```@docs; canonical=false
RasterDataset
RasterProvider
```