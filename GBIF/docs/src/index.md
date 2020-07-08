# Access GBIF data with Julia

This package offers access to biodiversity data through the Global Biodiversity
Information Facility ([GBIF](https://www.gbif.org/)) API. The package currently
supports access to occurrence information, and limited support for taxonomic
information.

## Getting started

The package can be installed from the Julia console:

~~~ julia
Pkg.add("GBIF")
~~~

After installing it, load the package as usual:

~~~ julia
using GBIF
~~~

## Core features

This package is a wrapper around the "search" API for occurrences, as well as
the taxonomy API of GBIF. The core functions are `occurrences` and `taxon`. In
previous releases of the package, there were a number a data cleaning routines -
because the Julia ecosystem has powerful packages to do this, they have been
removed, and we suggest to use either `Query.jl` directly, or to access a subset
of the information through the integration with `DataFrames.jl`.
