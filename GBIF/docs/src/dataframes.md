# Integration with DataFrames.jl

If the package `DataFrames.jl` is loaded, `GBIF.jl` will gain additional
capacities, namely the ability to export a `GBIFRecords` as a `DataFrame`.

```@example
using GBIF
using DataFrames

bats = GBIF.taxon("Chiroptera"; strict=false)
first(DataFrame(bats), 5)
```
