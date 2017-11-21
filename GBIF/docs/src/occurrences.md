# Retrieving occurrences

The most common task is to retrieve a number of occurrences. The core type of this package is `Occurrence`, which stores a number of data and metadata associated with observations.

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

Note that the `Occurrences` type, returned by `occurrences`, implements all the
necessary methods to iterate over. For example, this allows writing the following:

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
