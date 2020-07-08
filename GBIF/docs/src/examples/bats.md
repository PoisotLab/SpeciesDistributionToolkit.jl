# Rank-abundance curves of bats in Europe

If the package `DataFrames.jl` is loaded, `GBIF.jl` will gain additional
capacities, namely the ability to export a `GBIFRecords` as a `DataFrame` --
this may not include the entire information available in a `GBIFRecord`, but
this represents a way to rapidly export the results for further analyses. Note
that the taxonomy of the `GBIFTaxon` for every rows is also expanded.

```@example bt
using GBIF
using DataFrames

bats = GBIF.taxon("Chiroptera"; strict=false)
occ = occurrences(bats, "continent" => "EUROPE")
```
