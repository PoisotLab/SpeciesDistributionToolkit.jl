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

As an example, we can retrieve the occurrence with the key `1258202889`, using the following code:

```@example
using GBIF
occurrence(1258202889)
```

### Multiple occurrences

```@docs
occurrences()
occurrences(t::GBIFTaxon)
```

When called with no arguments, this function will return a list of the latest 20
occurrences recorded in GBIF. Note that the `GBIFRecords` type, which is the
return type of `occurrences`, implements the iteration interface. For example,
this allows writing the following:

```@example
using GBIF
o = occurrences()
for single_occ in o
  print(single_occ.taxon.name)
end
```

### Query parameters

The queries must be given as pairs of 

```@docs
occurrences(query::Pair...)
occurrences(t::GBIFTaxon, query::Pair...)
```

For example, we can get the data on observations of bats between -30 and 30 of
latitude using the following syntax:

```@example
using GBIF
bats = GBIF.taxon("Chiroptera"; rank=:ORDER)
for occ in occurrences(bats, "decimalLatitude" => (-30.0, 30.0))
  println("$(occ.scientific) -- latitude = $(occ.latitude)")
end
```

### Batch-download of occurrences

When calling `occurrences`, the list of possible `GBIFRecord` will be
pre-allocated. Any subsequent call to `occurrences!` (on the `GBIFRecords`
variable) will retrieve the next "page" of results, and add them to the
collection:

```@docs
occurrences!
```

```@example
using GBIF
can_most_recent = occurrences("hasCoordinate" => true, "country" => "CA")
occurrences!(can_most_recent)
```
