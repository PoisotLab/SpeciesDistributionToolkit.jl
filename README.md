# SpeciesDistributionToolkit

🗺️ `SpeciesDistributionToolkit.jl` is a collection of Julia packages forming a
toolkit meant to deal with (surprise!) species distribution data.

> [!TIP]
> All of the packages are installed automatically, so you can simply do
> `import Pkg; Pkd.add("SpeciesDistributionToolkit")` and get started.

Specifically, the goal of these packages put together is to provide a consistent way to handle
occurrence data, put them on a map, and make it interact with environmental
information. The package also contains a full-featured library for species distribution models.

> [!IMPORTANT]
> If you use this package, please cite:
> 
> Poisot, T., Bussières-Fournel, A., Dansereau, G., and Catchen, M. D. (2025). A Julia toolkit for species distribution data. _Peer Community Journal_ 5(e101). doi: [10.24072/pcjournal.589](https://peercommunityjournal.org/articles/10.24072/pcjournal.589/)
>
> Dansereau, G., and Poisot, T. (2021). SimpleSDMLayers.jl and GBIF.jl: A Framework for Species Distribution Modeling in Julia. _Journal of Open Source Software_ 6(57), 2872, doi: [10.21105/joss.02872](https://doi.org/10.21105/joss.02872)

<p align="center">
  <img src="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/main/structure.drawio.png?raw=true" alt="Package overview"/>
</p>

The up-to-date documentation for the most recent version can be found
[here](https://poisotlab.github.io/SpeciesDistributionToolkit.jl/dev/). It
contains tutorials showcasing the package in action, how-to guides to serve as a
quick reference, and links to the documentation for all methods in the component
packages.

> [!NOTE] 
> 🧑‍💻 To get a sense of the next steps and help with the development, see the
[issues and bugs tracker](https://github.com/orgs/PoisotLab/projects/3).   
> 💬 Reach out using the
[Discussions](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/discussions)
tab on this repo!

## Overview

### Species Distribution Toolkit

![GitHub Release](https://img.shields.io/github/v/release/PoisotLab/SpeciesDistributionToolkit.jl?sort=semver&filter=v*&display_name=release&style=flat-square&logo=julia&logoColor=%23ffffff&label=Full%20toolkit&labelColor=%23000000&color=%23ffffff)

This is the top-level package, and the only one you need to install explicitely.

### Species distribution modeling

![GitHub Release](https://img.shields.io/github/v/release/PoisotLab/SpeciesDistributionToolkit.jl?sort=semver&filter=SDeMo*&display_name=release&style=flat-square&logo=julia&logoColor=%23ffffff&label=SDM%20functions&labelColor=%23000000&color=%23ffffff)

This package provides an explainable ML series of methods to model species distribution.

### Occurrences Interface

![GitHub Release](https://img.shields.io/github/v/release/PoisotLab/SpeciesDistributionToolkit.jl?sort=semver&filter=Occurrences*&display_name=release&style=flat-square&logo=julia&logoColor=%23ffffff&label=Occurrences%20interface&labelColor=%23000000&color=%23ffffff)

This package provides a lightweight interface for occurrence data.

### Pseudo-absences generation

![GitHub Release](https://img.shields.io/github/v/release/PoisotLab/SpeciesDistributionToolkit.jl?sort=semver&filter=PseudoAbsences*&display_name=release&style=flat-square&logo=julia&logoColor=%23ffffff&label=Pseudo-absence%20generation&labelColor=%23000000&color=%23ffffff)

This package generates pseudo-absences based on geospatial information about the
layers and occurrence data.

### GBIF API and download wrapper

![GitHub Release](https://img.shields.io/github/v/release/PoisotLab/SpeciesDistributionToolkit.jl?sort=semver&filter=GBIF*&display_name=release&style=flat-square&logo=julia&logoColor=%23ffffff&label=GBIF%20wrapper&labelColor=%23000000&color=%23ffffff)

This package offers a wrapper on the GBIF API, as well as download functions to
retrieve data based on their DOI.

### Raster data retrieval

![GitHub Release](https://img.shields.io/github/v/release/PoisotLab/SpeciesDistributionToolkit.jl?sort=semver&filter=SimpleSDMDatasets*&display_name=release&style=flat-square&logo=julia&logoColor=%23ffffff&label=Raster%20data%20access&labelColor=%23000000&color=%23ffffff)

This package offers access to standard datasets like WorldClim, EarthEnv, CHELSA, etc.

### Polygon data retrieval

![GitHub Release](https://img.shields.io/github/v/release/PoisotLab/SpeciesDistributionToolkit.jl?sort=semver&filter=SimpleSDMPolygons*&display_name=release&style=flat-square&logo=julia&logoColor=%23ffffff&label=Polygon%20data%20access&labelColor=%23000000&color=%23ffffff)

This package offers access to standard polygon datasets like ESRI, GADM, Natural Earth, etc.

### Phylopic silhouette download

![GitHub Release](https://img.shields.io/github/v/release/PoisotLab/SpeciesDistributionToolkit.jl?sort=semver&filter=Phylopic*&display_name=release&style=flat-square&logo=julia&logoColor=%23ffffff&label=Phylopic%20integration&labelColor=%23000000&color=%23ffffff)

This package offers a way to get silhouettes from Phylopic.

### Fauxcurrences creation

![GitHub Release](https://img.shields.io/github/v/release/PoisotLab/SpeciesDistributionToolkit.jl?sort=semver&filter=Fauxcurrences*&display_name=release&style=flat-square&logo=julia&logoColor=%23ffffff&label=Fauxcurrences%20generation&labelColor=%23000000&color=%23ffffff)

This package offers a way to generate occurrence data with a constrained
statistical structure.