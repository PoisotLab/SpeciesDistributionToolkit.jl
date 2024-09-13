# SpeciesDistributionToolkit

🗺️ `SpeciesDistributionToolkit.jl` is a collection of Julia packages forming a
toolkit meant to deal with (surprise!) species distribution data. Specifically,
the goal of these packages put together is to provide a consistent way to handle
occurrence data, put them on a map, and make it interact with environmental
information.

![GitHub Release](https://img.shields.io/github/v/release/poisotlab/speciesdistributiontoolkit.jl?filter=v*&style=flat-square&label=Main%20package) [![DOC](https://img.shields.io/badge/Manual-teal?style=flat-square)](https://poisotlab.github.io/SpeciesDistributionToolkit.jl) [![Static Badge](https://img.shields.io/badge/Cite_the_paper-10.21105%2Fjoss.02872-orange?style=flat-square)](https://joss.theoj.org/papers/10.21105/joss.02872) ![Lifecycle:Maturing](https://img.shields.io/badge/Lifecycle-Maturing-007EC6?style=flat-square)

> [!IMPORTANT]
> This package is *not* intended to perform any actual modeling,
> but can serve as a robust basis for such models.

## Current component packages

The packages *do* work independently, but they are *designed* to work together.
In particular, when installing `SpeciesDistributionToolkit`, you get access to
all the functions and types exported by the component packages. This is the
*recommended* way to interact with the packages.

> [!NOTE]
> The badges will not pick up old releases of the component packages, and so they will show "no matching release found" until a new release is done. The packages still work.

### Getting occurrence data: `GBIF.jl`

A wrapper around the GBIF API, to retrieve taxa and occurrence datasets, and
perform filtering on these occurrence data based on flags.

![GitHub Release](https://img.shields.io/github/v/release/poisotlab/speciesdistributiontoolkit.jl?filter=GBIF-*&style=flat-square&label=GBIF.jl) [![DOC](https://img.shields.io/badge/Manual-teal?style=flat-square)](https://poisotlab.github.io/SpeciesDistributionToolkit.jl/GBIF/) ![Lifecycle:Stable](https://img.shields.io/badge/Lifecycle-Stable-97ca00?style=flat-square)

### Getting environmental data: `SimpleSDMDatasets.jl`

An efficient way to download and store environmental raster data for consumption
by other packages.

![GitHub Release](https://img.shields.io/github/v/release/poisotlab/speciesdistributiontoolkit.jl?filter=SimpleSDMDatasets-*&style=flat-square&label=SimpleSDMDatasets.jl) [![DOC](https://img.shields.io/badge/Manual-teal?style=flat-square)](https://poisotlab.github.io/SpeciesDistributionToolkit.jl/SimpleSDMDatasets/) ![Lifecycle:Stable](https://img.shields.io/badge/Lifecycle-Stable-97ca00?style=flat-square)

### Using environmental data: `SimpleSDMLayers.jl`

A series of types and common operations on raster data.

![GitHub Release](https://img.shields.io/github/v/release/poisotlab/speciesdistributiontoolkit.jl?filter=SimpleSDMLayers-*&style=flat-square&label=SimpleSDMLayers.jl) [![DOC](https://img.shields.io/badge/Manual-teal?style=flat-square)](https://poisotlab.github.io/SpeciesDistributionToolkit.jl/SimpleSDMLayers/) ![Lifecycle:Maturing](https://img.shields.io/badge/Lifecycle-Maturing-007EC6?style=flat-square)

### Simulating occurrence data: `Fauxcurrences.jl`

A package to simulate realistic species occurrence data from a know series of
occurrences, with additional statistical constraints.

![GitHub Release](https://img.shields.io/github/v/release/poisotlab/speciesdistributiontoolkit.jl?filter=Fauxcurrences-*&style=flat-square&label=Fauxcurrences.jl) [![DOC](https://img.shields.io/badge/Manual-teal?style=flat-square)](https://poisotlab.github.io/SpeciesDistributionToolkit.jl/Fauxcurrences/) ![Lifecycle:Maturing](https://img.shields.io/badge/Lifecycle-Maturing-007EC6?style=flat-square)

### Getting organisms silhouettes: `Phylopic.jl`

A wrapper around the Phylopic API.

![GitHub Release](https://img.shields.io/github/v/release/poisotlab/speciesdistributiontoolkit.jl?filter=Phylopic-*&style=flat-square&label=Phylopic.jl) [![DOC](https://img.shields.io/badge/Manual-teal?style=flat-square)](https://poisotlab.github.io/SpeciesDistributionToolkit.jl/Phylopic/) ![Lifecycle:Stable](https://img.shields.io/badge/Lifecycle-Stable-97ca00?style=flat-square)

## Want to help?

🧑‍💻 To get a sense of the next steps and help with the development, see the 
[issues/bugs tracker](https://github.com/orgs/PoisotLab/projects/3).

🤓 From a technical point of view, this *repository* is a [Monorepo][mnrp]
consisting of several related packages to work with species distribution data.
These packages were formerly independent and tied together with moxie and
`Require`, which was less than ideal. All the packages forming the toolkit share
a version number (which was set based on the version number of the eldest
package, `SimpleSDMLayers`), and the toolkit itself has its own version number.

[mnrp]: https://monorepo.tools/
