# Filtering observations

The filtering of `GBIFRecords` is best done using the `Query.jl` package, on the
`view` of the records object.

This can be one way to generate a `DataFrame`, by selecting the required columns:

```@example
using GBIF
using DataFrames
using Query

t = taxon("Carnivora", strict=false)
set = occurrences(t)
for rep in 1:10
    occurrences!(set)
end

tdf = view(set) |>
    @filter(_.rank == "SPECIES") |>
    @map({_.taxon.name, _.country}) |>
    DataFrame

tdf
```

Alternatively, this can allow to select only some records in an array:

```@example
using GBIF
using DataFrames
using Query

set = occurrences()
for rep in 1:10
    occurrences!(set)
end

tdf = for s in view(set) begin
    @where s.rank == "SPECIES"
    @select s
    @collect
end

tdf
```
