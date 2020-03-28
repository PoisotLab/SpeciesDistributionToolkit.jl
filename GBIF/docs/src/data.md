# Retrieving data

## Getting taxonomic information

```@docs
taxon
```

## Getting occurrence data

The most common task is to retrieve a number of occurrences. The core type
of this package is `GBIFRecord`, which stores a number of data and metadata
associated with observations of occurrences.

### Single occurrence

```@docs
occurrence
```

This can be used to retrieve occurrence `1425976049`, with

~~~ julia
using GBIF
occurrence(1425976049)
~~~

### Multiple occurrences

```@docs
occurrences()
occurrences(t::GBIFTaxon)
```

When called with no arguments, this function will return a list of the latest 20
occurrences recorded in GBIF. Note that the `GBIFRecords` type, returned by
`occurrences`, implements all the necessary methods to iterate over collections.
For example, this allows writing the following:

~~~ julia
o = occurrences()
for single_occ in o
  println(o.taxonKey)
end
~~~

### Query parameters

```@docs
occurrences(query::Pair...)
occurrences(t::GBIFTaxon, query::Pair...)
```

### Batch-download of occurrences

```@docs
occurrences!
```
