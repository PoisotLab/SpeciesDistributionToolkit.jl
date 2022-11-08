# SpeciesDistributionsToolkit

This is a [Monorepo][mnrp] consisting of several related packages to work with species
distribution data. These packages were formerly independent and tied together with the use
of `Require`, which is not the case anymore.

The *core* package is `SpeciesDistributionsToolkit.jl`, and it currently ships with:

- `GBIF.jl`, a wrapper around the GBIF API, to retrieve taxa and occurrence data
- `SimpleSDMDatasets.jl`, a series of wrappers around providers of raster datasets for use in
species distribution models
- `SimpleSDMLayers.jl`, a series of types and usual operations to handle raster data
- `Fauxcurrences.jl`, a package to simulate faux species with distances distributions that
mimick empirical ones

[mnrp]: https://monorepo.tools/
