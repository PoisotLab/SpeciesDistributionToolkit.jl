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

This can be used to retrieve occurrence `1258202889`, with

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
occurrences recorded in GBIF. Note that the `GBIFRecords` type, returned by
`occurrences`, implements all the necessary methods to iterate over collections.
For example, this allows writing the following:

```@example
using GBIF
o = occurrences()
for single_occ in o
  print(single_occ)
end
```

### Query parameters

```@docs
occurrences(query::Pair...)
occurrences(t::GBIFTaxon, query::Pair...)
```

For example, we can get the data on observations of bats between -30 and 30 of
latitudes using the following syntax:

```@example
using GBIF
bats = GBIF.taxon("Chiroptera"; strict=false)
for oc in occurrences(bats, "decimalLatitude" => (-30.0, 30.0))
  println("$(occ.taxon) -- latitude = $(occ.latitude)")
end
```

### Batch-download of occurrences

```@docs
occurrences!
```

```@example
using GBIF
can_most_recent = occurrences("hasCoordinate" => true, "country" => "CA")
occurrences!(can_most_recent)
```
