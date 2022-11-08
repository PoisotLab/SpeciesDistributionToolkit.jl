# GBIF wrapper for Julia

This is project offers an interface to the [GBIF] search API from
Julia. Current efforts focus on querying and exporting occurrences through the
`occurrence/search` endpoint. There is partial support for the taxonomic API.

![CI](https://github.com/EcoJulia/GBIF.jl/workflows/CI/badge.svg?branch=master)
![TagBot](https://github.com/EcoJulia/GBIF.jl/workflows/TagBot/badge.svg?branch=master)
[![codecov](https://codecov.io/gh/EcoJulia/GBIF.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/EcoJulia/GBIF.jl)
[![Latest documentation](https://img.shields.io/badge/documentation-latest-blue.svg)](https://ecojulia.github.io/GBIF.jl/latest/)
[![DOI](https://zenodo.org/badge/97337048.svg)](https://zenodo.org/badge/latestdoi/97337048)

[GBIF]: http://gbif.org/

## Installation

~~~
Pkg.add("GBIF")
~~~

## Package overview

- get a single occurrence (`occurrence`)
- look for multiple occurrences (`occurrences`)
- paging function to get the next batch of occurrences (`occurrences!`)
- species and taxon lookup (`species`)

## How to contribute

Please read the [Code of Conduct][CoC] and the [contributing guidelines][contr].

[CoC]: https://github.com/EcoJulia/GBIF.jl/blob/master/CODE_OF_CONDUCT.md
[contr]: https://github.com/EcoJulia/GBIF.jl/blob/master/CONTRIBUTING.md
