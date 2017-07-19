# GBIF wrapper for Julia

This is a (work in progress) project to provide an interface to the [GBIF] API
from Julia. Current efforts focus on querying and exporting occurrences through
the `occurrence/search` endpoint. Taxonomic API support will come later.

[![Build Status](https://travis-ci.org/EcoJulia/GBIF.jl.svg?branch=master)](https://travis-ci.org/EcoJulia/GBIF.jl)
[![codecov](https://codecov.io/gh/EcoJulia/GBIF.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/EcoJulia/GBIF.jl)

## Vignettes

| Example                       |                           Link |
|:------------------------------|-------------------------------:|
| Mapping bird occurrences      |   [Jupyter notebook][nb_birds] |
| Integration with `DataFrames` | [Jupyter notebook][nb_species] |

[nb_birds]: https://nbviewer.jupyter.org/github/EcoJulia/GBIF.jl/blob/master/docs/notebooks/ukbirds.ipynb
[nb_species]: https://nbviewer.jupyter.org/github/EcoJulia/GBIF.jl/blob/master/docs/notebooks/species.ipynb

## Package overview

- get a single occurrence (`occurrence`)
- look for multiple occurrences (`occurrences`)
- paging function (`next!`, `restart!`, `complete!`)
- quality control (`qualitycontrol!`)
- export to data frame (`DataFrames`)
- species and taxon lookup (`species`)

## How to contribute

Please read the [Code of Conduct][CoC] and the [contributing guidelines][contr].

[CoC]: https://github.com/EcoJulia/GBIF.jl/blob/master/CODE_OF_CONDUCT.md
[contr]: https://github.com/EcoJulia/GBIF.jl/blob/master/CONTRIBUTING.md
