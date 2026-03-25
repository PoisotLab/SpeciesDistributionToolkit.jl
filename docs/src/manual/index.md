# Manual

`SpeciesDistributionToolkit.jl` is a collection of packages for species
distribution modeling and biodiversity research, for the
[Julia](https://julialang.org/) programming language. It is built and maintained
by the *Laboratoire d'Écologie Prédictive et Interprétable pour la Crise de la
Biodiversité* ([ÉPIC Biodiversity](https://epic-biodiversity.org/)).

::: info Not just for research!

This package is now used in pipelines in [BON in a
Box](https://boninabox.geobon.org/index), [GEOBON](https://geobon.org/)'s
project to automate the calculation and representation of the post-2020 [GBF
indicators](https://www.cbd.int/gbf). See the [BON in a Box tool page](https://boninabox.geobon.org/tool-detail?id=236).

:::

If you use the package, please cite

> Poisot, T., Bussières-Fournel, A., Dansereau, G., and Catchen, M. D. (2025). A
> Julia toolkit for species distribution data. _Peer Community Journal_ 5(e101).
> doi:
> [10.24072/pcjournal.589](https://peercommunityjournal.org/articles/10.24072/pcjournal.589/)

as well as

> Dansereau, G., and Poisot, T. (2021). SimpleSDMLayers.jl and GBIF.jl: A
> Framework for Species Distribution Modeling in Julia. _Journal of Open Source
> Software_ 6(57), 2872, doi:
> [10.21105/joss.02872](https://doi.org/10.21105/joss.02872)

## Getting started

The package is published in the Julia general repository, and can be installed with:

```julia
import Pkg
Pkg.add("SpeciesDistributionToolkit") # [!code highlight]
```

This will automatically install all the sub-packages.

::: details A note about versions (and updates)

To help with dependency management, we suggest that the `compat` entry in the
`Project.toml` file of your project should be:

```toml
[compat]
SpeciesDistributionToolkit = "1"
```

This will ensure that all releases of the `v1.x.x.` series will be compatible
with your project. Because the modules all internally rely on this same
compatibility rule, you can run

```julia
import Pkg
Pkg.update() # [!code highlight]
```

to get the latest features of each component package

:::

## Contents of the manual

This section of the manual presents short capsules about getting you to achieve
a simple, well-defined task. Although there is some discussion of design
elements for the various packages, this is *not* the documentation; instead, you
can think of this section as a collection of snippets to re-use to build your
own analysis. The vignettes also introduce, when relevant, some variations
around how to perform a given task.

Most manual pages end with a list of the documentation of the most important
functions used.

If you have a question about how to achieve a specific task, feel free to [share
it](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/discussions/categories/ideas)
in the Discussion page, so we can add it to the manual.