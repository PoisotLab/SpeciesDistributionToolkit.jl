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
