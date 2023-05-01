# Species Distributions Toolkit

This package is a wrapper around a series of tools, *a.k.a.* component packages,
that are meant to simplify the construction of species distribution models. The
models themselves are *not* part of this package, which is intended to take the
tedium out of data preparation.

In particular, the package offers

- a wrapper around the GBIF occurrences API to access occurrence data
  (`GBIF.jl`)
- ways to generate pseudo-absences based on a series of heuristics
- ways to generate fake occurrences with statistical properties similar to
  actual occurrences (`Fauxcurrences.jl`)
- a simple way to represent layers as either mutable or immutable objects (`SimpleSDMLayers.jl`)
- a way to collect historic and future climate and land-use data to feed into the models (`SimpleSDMDatasets.jl`)
- interfaces to Makie for plotting and data visualisation
- an integration of the phylopic API to get illustrations for organisms

This documentation is therefore pretty vast: it offers an in-depth explanation of what the
component packages are doing and how they work, discusses the interactions between these
packages, and offers a series of user stories which includes some examples of models of
species distributions.

The *suggested* way to use this documentation is to start by having a look at "user
stories", which show ways to use the package to solve well-defined problems. After this, the
documentation of each of the components go into more detail about how to use the different
methods.

If you want to contribute to the project, the best way is likely to have a look
at the [development dashboard](https://github.com/orgs/PoisotLab/projects/3), or
look for [possible first
PRs](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/issues?q=is%3Aissue+is%3Aopen+label%3A%22good+first+issue%22).
