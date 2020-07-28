# Access GBIF data with Julia

This package offers access to biodiversity data stored by the Global
Biodiversity Information Facility ([GBIF](https://www.gbif.org/)). The package
currently offers a wrapper around the search API (to retrieve information on
occurrences), and a limited wrapper around the species API (to retrieve the
identifier of taxa).

The focus on the package is on retrieving data; filtering and data analysis
should be done using other packages from the Julia ecosystem. In particular, we
provide support for `DataFrames` and `Query` (and therefore the rest of the
"queryverse").

## Getting started

The latest release of the package can be installed from the Julia console:

~~~ julia
Pkg.add("GBIF")
~~~

After installing it, load the package as usual:

~~~ julia
using GBIF
~~~

## Core features

- get taxonomic information using the `taxon` function
- retrieve a single occurrence as a `GBIFRecord` using `occurrence`
- search for multiple occurrences as a `GBIFRecords` according to a query using the `occurrences` function, and page through the results with `occurrences!`
- `GBIFRecords` are fully iterable