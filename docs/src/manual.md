# Manual

`SpeciesDistributionToolkit.jl` is a collection of packages for species
distribution modeling and biodiversity research, for the
[Julia](https://julialang.org/) programming language.

::: info Not just for research!

This package is now used in pipelines in [BON in a
Box](https://boninabox.geobon.org/index), [GEOBON](https://geobon.org/)'s
project to automate the calculation and representation of the post-2020 [GBF
indicators](https://www.cbd.int/gbf).

:::

## Contents of the package

The package offers a series of methods to acces data required to build species distribution models, including:

- a wrapper around the [GBIF](https://www.gbif.org/) occurrences API to access occurrence data
- a wrapper around the [Phylopic](https://www.phylopic.org/) images API
- ways to generate fake occurrences with statistical properties similar to actual occurrences
- ways to generate pseudo-absences based on a series of heuristics
- a simple way to represent layers as mutable objectcs
- utility functions for *teaching* species distribution models
- a way to collect historic and future climate and land-use data to feed into the models, pre-loaded with datasets like CHELSA, WorldClim, EarthEnv, PaleoClim, etc
- an interface to [Makie](https://docs.makie.org/stable/) for plotting and data visualisation

::: details Installation

The only package you need to install is `SpeciesDistributionToolkit` itself,
which can be done using

```julia
import Pkg
Pkg.add("SpeciesDistributionToolkit") # [!code focus]
```

This will automatically install all the sub-packages.

:::

## Contents of the manual

This manual is split into two sections: tutorials, which are medium to long
examples of using the full functionality of the package; and how-tos, which are
shorter (and denser) summaries of how to achieve a specific task.

## Current component packages

The packages *do* work independently, but they are *designed* to work together.
In particular, when installing `SpeciesDistributionToolkit`, you get access to
all the functions and types exported by the component packages. This is the
*recommended* way to interact with the packages.


::: details Access to GBIF data

`GBIF.jl` is a wrapper around the GBIF API, to retrieve taxa and occurrence datasets, and
perform filtering on these occurrence data based on flags.

![GitHub Release](https://img.shields.io/github/v/release/poisotlab/speciesdistributiontoolkit.jl?filter=GBIF-*&style=flat-square&label=GBIF.jl)

![Lifecycle:Stable](https://img.shields.io/badge/Lifecycle-Stable-97ca00?style=flat-square)

:::


::: details Handling occurrence data

`OccurrencesInterface.jl` is a *lightweight*, *general purpose* interface that allows other types to be used with the Species Distribution Toolkit package.

![GitHub Release](https://img.shields.io/github/v/release/poisotlab/speciesdistributiontoolkit.jl?filter=OccurrencesInterface-*&style=flat-square&label=OccurrencesInterface.jl)

![Lifecycle:Stable](https://img.shields.io/badge/Lifecycle-Stable-97ca00?style=flat-square)

:::



::: details Downloading and managing environmental data

`SimpleSDMDatasets.jl` is an efficient and transparent, interface-based way to download and store environmental raster data for consumption
by other packages.

![GitHub Release](https://img.shields.io/github/v/release/poisotlab/speciesdistributiontoolkit.jl?filter=SimpleSDMDatasets-*&style=flat-square&label=SimpleSDMDatasets.jl)

![Lifecycle:Stable](https://img.shields.io/badge/Lifecycle-Stable-97ca00?style=flat-square)

:::


::: details Manipulating raster

`SimpleSDMLayers.jl` offers a series of types and common operations on raster data.

![GitHub Release](https://img.shields.io/github/v/release/poisotlab/speciesdistributiontoolkit.jl?filter=SimpleSDMLayers-*&style=flat-square&label=SimpleSDMLayers.jl)

![Lifecycle:Maturing](https://img.shields.io/badge/Lifecycle-Maturing-007EC6?style=flat-square)

:::


::: details Simulating occurrence data

`Fauxcurrences.jl` is a package to simulate realistic species occurrence data from a known series of
occurrences, with additional statistical constraints.

![GitHub Release](https://img.shields.io/github/v/release/poisotlab/speciesdistributiontoolkit.jl?filter=Fauxcurrences-*&style=flat-square&label=Fauxcurrences.jl)

![Lifecycle:Maturing](https://img.shields.io/badge/Lifecycle-Maturing-007EC6?style=flat-square)

:::



::: details Access to the Phylopic library

`Phylopic.jl` is a wrapper around the Phylopic API.

![GitHub Release](https://img.shields.io/github/v/release/poisotlab/speciesdistributiontoolkit.jl?filter=Phylopic-*&style=flat-square&label=Phylopic.jl)

![Lifecycle:Stable](https://img.shields.io/badge/Lifecycle-Stable-97ca00?style=flat-square)

:::



::: details Tools for workshops and education

`SDeMo.jl` is a series of very simple SDMs and utility functions for education, with some tools for interpretable machine learning.

![GitHub Release](https://img.shields.io/github/v/release/poisotlab/speciesdistributiontoolkit.jl?filter=SDeMo-*&style=flat-square&label=SDeMo.jl)

![Lifecycle:Maturing](https://img.shields.io/badge/Lifecycle-Maturing-007EC6?style=flat-square)

:::


