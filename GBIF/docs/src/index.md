# Access GBIF data with Julia

This package offers access to biodiversity data through the Global Biodiversity
Information Facility ([GBIF]) API. The package currently supports access to
occurrence information, and limited support for taxonomic information. There are
a limited number of cleaning routines built-in, but more can easily be added.

## How to install

The package can be installed from the Julia console:

~~~ julia
Pkg.add("GBIF")
~~~

## How to use

After installing it, load the package as usual:

~~~ julia
using GBIF
~~~

This documentation will walk you through the various features.

[GBIF]: https://www.gbif.org/
