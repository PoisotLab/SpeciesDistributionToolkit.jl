# Species Distributions Toolkit

This package is a wrapper around a series of tools, *a.k.a.* component packages,
that are meant to simplify the building of species distribution models. The
models themselves are *not* part of this package, which is intended to take the
tedium out of data preparation.

This package is now used in some of the default pipelines in [BON in a
Box](https://boninabox.geobon.org/frontend/index),
[GEOBON](https://geobon.org/)'s project to automate the calculation and
representation of the pos-2020 [GBF](https://www.cbd.int/gbf) indicators.

In particular, the package offers

- a wrapper around the [GBIF](https://www.gbif.org/) occurrences API to access occurrence data
  (`GBIF.jl`)
- a wrapper around the [Phylopic](https://www.phylopic.org/) images API (`Phylopic.jl`)
- ways to generate pseudo-absences based on a series of heuristics
- ways to generate fake occurrences with statistical properties similar to
  actual occurrences (`Fauxcurrences.jl`)
- a simple way to represent layers as either mutable or immutable objects (`SimpleSDMLayers.jl`)
- a way to collect historic and future climate and land-use data to feed into the models (`SimpleSDMDatasets.jl`), pre-loaded with data from [CHELSA](https://chelsa-climate.org/), [EarthEnv](https://www.earthenv.org/), and [WorldClim](https://www.worldclim.org/)
- interfaces to [Makie](https://docs.makie.org/stable/) for plotting and data visualisation

This documentation is therefore pretty vast: it offers an in-depth explanation of what the
component packages are doing and how they work, discusses the interactions between these
packages, and offers a series of illustrations which includes some examples of models of
species distributions.

Each package also comes with its specific documentation:

- [GBIF.jl](https://poisotlab.github.io/SpeciesDistributionToolkit.jl/GBIF/)
- [Phylopic.jl](https://poisotlab.github.io/SpeciesDistributionToolkit.jl/Phylopic/)
- [SimpleSDMDatasets.jl](https://poisotlab.github.io/SpeciesDistributionToolkit.jl/SimpleSDMDatasets/)

If you want to contribute to the project, the best way is likely to have a look
at the [development dashboard](https://github.com/orgs/PoisotLab/projects/3), or
look for [possible first
PRs](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/issues?q=is%3Aissue+is%3Aopen+label%3A%22good+first+issue%22).
