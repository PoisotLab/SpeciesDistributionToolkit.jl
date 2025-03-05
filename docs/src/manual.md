# Manual

`SpeciesDistributionToolkit.jl` is a collection of packages for species
distribution modeling and biodiversity research, for the
[Julia](https://julialang.org/) programming language.

::: info Not just for research!

This package is now used in pipelines in [BON in a
Box](https://boninabox.geobon.org/index), [GEOBON](https://geobon.org/)'s
project to automate the calculation and representation of the post-2020 [GBF
indicators](https://www.cbd.int/gbf). See the [BON in a Box tool page](https://boninabox.geobon.org/tool-detail?id=236).

:::

## Getting started

The package is published in the Julia general repository, and can be installed with:

```julia
import Pkg
Pkg.add("SpeciesDistributionToolkit") # [!code highlight]
```

This will automatically install all the sub-packages.

::: details A note about versions (and updates)

To help with dependency management, we suggest that the `compat` entry in the `Project.toml` file of your project should be:

```toml
[compat]
SpeciesDistributionToolkit = "1"
```

This will ensure that all releases of the `v1.x.x.` series will be compatible with your project. Because the modules all internally rely on this same compatibility rule, you can run

```julia
import Pkg
Pkg.update() # [!code highlight]
```

to get the latest features of each component package

:::

## Contents of the package

![Overview of the package](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/main/structure.drawio.png?raw=true)

The package offers a series of methods to acces data required to build species distribution models, including:

- a wrapper around the [GBIF](https://www.gbif.org/) occurrences API to access occurrence data
- a wrapper around the [Phylopic](https://www.phylopic.org/) images API
- ways to generate fake occurrences with statistical properties similar to actual occurrences
- ways to generate pseudo-absences based on a series of heuristics
- a simple way to represent layers as mutable objects
- utility functions for *teaching* species distribution models
- a way to collect historic and future climate and land-use data to feed into the models, pre-loaded with datasets like CHELSA, WorldClim, EarthEnv, PaleoClim, etc
- an interface to [Makie](https://docs.makie.org/stable/) for plotting and data visualisation
- interfaces with _many_ different packages from the Julia ecosystem

## Contents of the manual

This manual is split into two sections: tutorials, which are longer examples of
using the full functionality of the package; and how-tos, which are shorter (and
denser) summaries of how to achieve a specific task. It is a good idea to start
skimming the tutorials to get a sense for what using the package feels like, and
then dive into the how-to examples for specific tasks.