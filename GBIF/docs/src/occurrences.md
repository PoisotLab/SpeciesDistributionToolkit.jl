# Retrieving occurrences

The most common task is to retrieve a number of occurrences. The core type
of this package is `GBIFRecord`, which stores a number of data and metadata
associated with observations of occurrences.

## Getting a single occurrence

```@docs
occurrence
```

This can be used to retrieve [occurrence `1425976049`][exocc], with

~~~ julia
using GBIF
occurrence(1425976049)
~~~

[exocc]: https://www.gbif.org/occurrence/1425976049

## Getting multiple occurrences

```@docs
occurrences()
```

When called with no arguments, this function will return a list of the latest 20
occurrences recorded in GBIF. Additional arguments can be specified to filter
some occurrences. They are detailed in the "Using queries" section of this
manual.

Note that the `GBIFRecords` type, returned by `occurrences`, implements all
the necessary methods to iterate over collections. For example, this allows
writing the following:

~~~ julia
o = occurrences()
for single_occ in o
  println(o.taxonKey)
end
~~~

## Batch-download of occurrences

```@docs
next!
complete!
```

## Filtering occurrences after download

The `GBIFRecords` objects can be used with the `Query.jl` package. For example,
to get the observations from France in the most recent 20 observations, we can
use:

~~~ julia
using Query
o = occurrences()
@from i in o begin
    @where i.country == "France"
    @select {i.key, i.species}
    @collect
end
~~~
