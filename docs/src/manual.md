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
>
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

## Contents of the manual

This manual is split into two sections: tutorials, which are longer examples of
using the full functionality of the package; and how-tos, which are shorter (and
denser) summaries of how to achieve a specific task. It is a good idea to start
skimming the tutorials to get a sense for what using the package feels like, and
then dive into the how-to examples for specific tasks.