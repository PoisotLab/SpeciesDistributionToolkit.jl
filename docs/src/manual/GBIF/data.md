# Retrieving data

## Getting taxonomic information

```@docs
taxon
```

## Searching for occurrence data

The most common task is to retrieve many occurrences according to a query. The
core type of this package is `GBIFRecord`, which is a very lightweight type
containing information about the query, and a list of `GBIFRecord` for every
matching occurrence. Note that the GBIF "search" API is limited to 100000
results, and will not return more than this amount.

### Single occurrence

```@docs
occurrence
```

### Multiple occurrences

```@docs
occurrences()
occurrences(t::GBIFTaxon)
```

When called with no arguments, this function will return a list of the latest 20
occurrences recorded in GBIF. Note that the `GBIFRecords` type, which is the
return type of `occurrences`, implements the iteration interface.

### Query parameters

The queries must be given as pairs of values.

```@docs
occurrences(query::Pair...)
occurrences(t::GBIFTaxon, query::Pair...)
```

### Batch-download of occurrences

When calling `occurrences`, the list of possible `GBIFRecord` will be
pre-allocated. Any subsequent call to `occurrences!` (on the `GBIFRecords`
variable) will retrieve the next "page" of results, and add them to the
collection:

```@docs
occurrences!
```
