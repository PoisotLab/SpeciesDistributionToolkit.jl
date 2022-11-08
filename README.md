# SpeciesDistributionsToolkit

`SpeciesDistributionsToolkit.jl` is a few different packages wearing a trench coat. The goal
of these packages put together is to provide a consistent way to handle occurrence data, put
them on a map, and make it interact with environmental information. This package is *not*
intended to perform any actual modeling, but can serve as a robust basis for such models.

This is a [Monorepo][mnrp] consisting of several related packages to work with species
distribution data. These packages were formerly independent and tied together with the use
of `Require`, which is not the case anymore.

[mnrp]: https://monorepo.tools/

**Getting occurrence data**: `GBIF.jl`, a wrapper around the GBIF API, to retrieve taxa and occurrence
occurrence datasets, and perform filtering on these occurrence data based on flags.

**Getting environmental data**: `SimpleSDMDatasets.jl`, an efficient way to download and
store environmental raster data for consumption by other packages.

**Using environmental data**: `SimpleSDMLayers.jl`, a series of types and common operations
on raster data

**Simulating occurrence data**: `Fauxcurrences.jl`, a package to simulate faux species distribution data
