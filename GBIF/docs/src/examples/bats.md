# Rank-abundance curves of bats in Europe

In this example, we will use the `GBIF` package to produce a rank-abundance
curve of Chiroptera species in Europe, based on data from 2000 to 2005.

```@example bt
using GBIF
using DataFrames
using Query
using StatsPlots

bats = GBIF.taxon("Chiroptera"; strict=false)
occ = occurrences(bats, "continent" => "EUROPE", "year" => (2000, 2005), "limit" => 300)
while length(occ) < size(occ)
occurrences!(occ)
end
```

```@example bt
by_country = occ |>
  @filter(_.rank == "SPECIES") |>
  @map({_.key, _.country, species=_.taxon.name}) |>
  @groupby((_.country, _.species)) |>
  @map({country = first(unique(_.country)), species = first(unique(_.country)), count = length(_)}) |>
  DataFrame
```
