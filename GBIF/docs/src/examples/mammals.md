# Mammals in Québec

In this example, we will look at the number of species of *Carnivora* observed
in Québec in 2019, sort the observations by date, and plot a
simple species discovery curve. This will showcase the integration of the
package with `Query.jl`.

```@example qc
using GBIF
using DataFrames
using Query
using StatsPlots
using Dates
```

We can get the taxonomic object for *Carnivora* by specifying that this is an
order (or as GBIF wants us to shout, an ORDER):

```@example qc
mammalia = taxon("Mammalia", rank = :CLASS)
```

With this object created, we can define a rough bounding box for Québec, and
start defining our query:

```@example qc
lat, lon = (44.0, 62.0), (-80.0, -56.0)


obs_qc = occurrences(
    mammalia,
    "limit" => 300,
    "hasCoordinate" => "true",
    "decimalLatitude" => lat,
    "decimalLongitude" => lon,
    "year" => (2017, 2018)
)
```

Because the query parameters are going to remain within the `obs_qc` variable,
all we need to do is call `occurrences!` on this variable until all occurrences
(of which there are `occurrences.count`) are retrieved.

```@example
while length(obs_qc) < obs_qc.count
    occurrences!(obs_qc)
end
```

```@example
d = obs_qc |>
  @filter(_.rank == "SPECIES") |>
  @filter(_.country == "Canada") |>
  @map({_.key, _.date, _.taxon.name}) |>
  @mutate(date = Date(_.date)) |>
  @groupby(_.date) |>
  @map({date=key(_), observations=length(_)}) |>
  @orderby(_.date) |>
  DataFrame

@df d plot(:date, :observations)
```
