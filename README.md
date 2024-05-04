# SpeciesDistributionToolkit

`SpeciesDistributionToolkit.jl` is a collection of Julia packages forming a
toolkit meant to deal with (surprise!) species distribution data. Specifically,
the goal of these packages put together is to provide a consistent way to handle
occurrence data, put them on a map, and make it interact with environmental
information.

![GitHub Release](https://img.shields.io/github/v/release/poisotlab/speciesdistributiontoolkit.jl?filter=v*)

![GitHub Release](https://img.shields.io/github/v/release/poisotlab/speciesdistributiontoolkit.jl?filter=gbif*)

![GitHub Release](https://img.shields.io/github/v/release/poisotlab/speciesdistributiontoolkit.jl?filter=phylopic*)

![GitHub Release](https://img.shields.io/github/v/release/poisotlab/speciesdistributiontoolkit.jl?filter=fauxcurrences*)

![GitHub Release](https://img.shields.io/github/v/release/poisotlab/speciesdistributiontoolkit.jl?filter=simplesdmdatasets*)

![GitHub Release](https://img.shields.io/github/v/release/poisotlab/speciesdistributiontoolkit.jl?filter=simplesdmlayers*)

> To get a sense of the next steps and help with the development, see the 
[issues/bugs tracker](https://github.com/orgs/PoisotLab/projects/3)

This package is *not* intended to perform any actual modeling, but can serve as
a robust basis for such models. We offer an interface from this package to `MLJ`
to facilitate prediction.

Form a technical point of view, this *repository* is a [Monorepo][mnrp]
consisting of several related packages to work with species distribution data.
These packages were formerly independent and tied together with moxie and
`Require`, which was less than ideal. All the packages forming the toolkit share
a version number (which was set based on the version number of the eldest
package, `SimpleSDMLayers`), and the toolkit itself has its own version number.

[mnrp]: https://monorepo.tools/

Note that the packages *do* work independently as well, but they are now *designed*
to work together. In particular, when installing `SpeciesDistributionToolkit`,
you get access to all the functions and types exported by the component
packages. This is the *recommended* way to interact with the packages.

## Current component packages

**Getting occurrence data**: `GBIF.jl`, a wrapper around the GBIF API, to
retrieve taxa and occurrence datasets, and perform filtering on these occurrence
data based on flags

**Getting environmental data**: `SimpleSDMDatasets.jl`, an efficient way to
download and store environmental raster data for consumption by other packages.

**Using environmental data**: `SimpleSDMLayers.jl`, a series of types and common
operations on raster data

**Simulating occurrence data**: `Fauxcurrences.jl`, a package to simulate
realistic species occurrence data from a know series of occurrences, with
additional statistical constraints

**Getting organisms silhouettes**: `Phylopic.jl`, a wrapper around the Phylopic
API

