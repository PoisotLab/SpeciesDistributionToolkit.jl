# SpeciesDistributionToolkit

🗺️ `SpeciesDistributionToolkit.jl` is a collection of Julia packages forming a
toolkit meant to deal with (surprise!) species distribution data. Specifically,
the goal of these packages put together is to provide a consistent way to handle
occurrence data, put them on a map, and make it interact with environmental
information.

![GitHub Release](https://img.shields.io/github/v/release/poisotlab/speciesdistributiontoolkit.jl?filter=v*&style=flat-square&label=Main%20package) [![DOC](https://img.shields.io/badge/Manual-teal?style=flat-square)](https://poisotlab.github.io/SpeciesDistributionToolkit.jl)

> [!IMPORTANT]
> This package is *not* intended to perform any actual modeling,
> but can serve as a robust basis for such models.

🔄 Note that the packages *do* work independently as well, but they are *designed*
to work together. In particular, when installing `SpeciesDistributionToolkit`,
you get access to all the functions and types exported by the component
packages. This is the *recommended* way to interact with the packages.

🧑‍💻 To get a sense of the next steps and help with the development, see the 
[issues/bugs tracker](https://github.com/orgs/PoisotLab/projects/3)

🤓 From a technical point of view, this *repository* is a [Monorepo][mnrp]
consisting of several related packages to work with species distribution data.
These packages were formerly independent and tied together with moxie and
`Require`, which was less than ideal. All the packages forming the toolkit share
a version number (which was set based on the version number of the eldest
package, `SimpleSDMLayers`), and the toolkit itself has its own version number.

[mnrp]: https://monorepo.tools/

## Current component packages

> [!NOTE]
> The badges will not pick up old releases of the component packages, and so they will show "no matching release found" until a new release is done. The packages still work.

**Getting occurrence data**: `GBIF.jl`, a wrapper around the GBIF API, to
retrieve taxa and occurrence datasets, and perform filtering on these occurrence
data based on flags

![GitHub Release](https://img.shields.io/github/v/release/poisotlab/speciesdistributiontoolkit.jl?filter=GBIF-*&style=flat-square&label=GBIF.jl) [![DOC](https://img.shields.io/badge/Manual-teal?style=flat-square)](https://poisotlab.github.io/SpeciesDistributionToolkit.jl/GBIF/)

**Getting environmental data**: `SimpleSDMDatasets.jl`, an efficient way to
download and store environmental raster data for consumption by other packages.

![GitHub Release](https://img.shields.io/github/v/release/poisotlab/speciesdistributiontoolkit.jl?filter=SimpleSDMDatasets-*&style=flat-square&label=SimpleSDMDatasets.jl) [![DOC](https://img.shields.io/badge/Manual-teal?style=flat-square)](https://poisotlab.github.io/SpeciesDistributionToolkit.jl/SimpleSDMDatasets/)

**Using environmental data**: `SimpleSDMLayers.jl`, a series of types and common
operations on raster data

![GitHub Release](https://img.shields.io/github/v/release/poisotlab/speciesdistributiontoolkit.jl?filter=SimpleSDMLayers-*&style=flat-square&label=SimpleSDMLayers.jl) [![DOC](https://img.shields.io/badge/Manual-teal?style=flat-square)](https://poisotlab.github.io/SpeciesDistributionToolkit.jl/SimpleSDMLayers/)

**Simulating occurrence data**: `Fauxcurrences.jl`, a package to simulate
realistic species occurrence data from a know series of occurrences, with
additional statistical constraints

![GitHub Release](https://img.shields.io/github/v/release/poisotlab/speciesdistributiontoolkit.jl?filter=Fauxcurrences-*&style=flat-square&label=Fauxcurrences.jl) [![DOC](https://img.shields.io/badge/Manual-teal?style=flat-square)](https://poisotlab.github.io/SpeciesDistributionToolkit.jl/Fauxcurrences/)

**Getting organisms silhouettes**: `Phylopic.jl`, a wrapper around the Phylopic
API

![GitHub Release](https://img.shields.io/github/v/release/poisotlab/speciesdistributiontoolkit.jl?filter=Phylopic-*&style=flat-square&label=Phylopic.jl) [![DOC](https://img.shields.io/badge/Manual-teal?style=flat-square)](https://poisotlab.github.io/SpeciesDistributionToolkit.jl/Phylopic/)

