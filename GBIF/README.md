# GBIF wrapper for Julia

This is project offers an interface to the [GBIF] search API from
Julia. Current efforts focus on querying and exporting occurrences through the
`occurrence/search` endpoint. There is partial support for the taxonomic API.

[![Build Status](https://travis-ci.org/EcoJulia/GBIF.jl.svg?branch=master)](https://travis-ci.org/EcoJulia/GBIF.jl)
[![codecov](https://codecov.io/gh/EcoJulia/GBIF.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/EcoJulia/GBIF.jl)
[![Latest documentation](https://img.shields.io/badge/documentation-latest-blue.svg)](https://ecojulia.github.io/GBIF.jl/latest/)
[![Example](http://pkg.julialang.org/badges/GBIF_0.6.svg)](http://pkg.julialang.org/?pkg=GBIF)

[GBIF]: http://gbif.org/

## Installation

~~~
Pkg.add("GBIF")
~~~

## Package overview

- get a single occurrence (`occurrence`)
- look for multiple occurrences (`occurrences`)
- paging function (`next!`, `restart!`, `complete!`)
- quality control (`qualitycontrol!`) and arbitrary filters
- export to data frame (`DataFrames`)
- species and taxon lookup (`species`)
- integration with the `Query` package

## How to contribute

Please read the [Code of Conduct][CoC] and the [contributing guidelines][contr].

[CoC]: https://github.com/EcoJulia/GBIF.jl/blob/master/CODE_OF_CONDUCT.md
[contr]: https://github.com/EcoJulia/GBIF.jl/blob/master/CONTRIBUTING.md
