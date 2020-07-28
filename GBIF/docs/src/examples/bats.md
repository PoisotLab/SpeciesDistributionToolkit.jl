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
  @filter(!ismissing(_.species)) |>
  @filter(!ismissing(_.country)) |>
  @groupby((_.country, _.species)) |>
  @map({country = first(unique(_.country)), species = first(unique(_.species)), count = length(_)}) |>
  @groupby(_.country) |>
  @map({country = key(_), abundance = sort(_.count, rev=true), rank = 1:length(_)}) |>
  @filter(length(_.abundance) > 5) |>
  DataFrame |>
  (d) -> flatten(d, [:abundance, :rank]) |>
  (d) -> sort(d, :rank)

theme(:wong)
@df by_country plot(:rank, :abundance, group = :country, m=:circle, legend=:outertopright)
xaxis!("Rank", :log)
yaxis!("Observations", :log)
```
