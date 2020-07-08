# Mammals in Québec

In this example, we will look at the number of observations of the *Cardinalis
cardinalis* observed in Québec in 2012 and 2013, sort the observations by date,
and compare the number of observations over the two years. This will showcase
the integration of the package with `Query.jl`.

```@example qc
using GBIF
using DataFrames
using Query
using StatsPlots
using Dates
```

We can get the taxonomic object for *Cardinalis cardinalis*:

```@example qc
sp_code = taxon("Odocoileus virginianus", rank = :SPECIES)
```

With this object created, we can define a rough bounding box for Québec, and
start defining our query:

```@example qc
lat, lon = (44.0, 62.0), (-80.0, -56.0)

obs_qc = occurrences(
    sp_code,
    "limit" => 300,
    "hasCoordinate" => "true",
    "decimalLatitude" => lat,
    "decimalLongitude" => lon,
    "year" => (2010, 2020)
)
```

Because the query parameters are going to remain within the `obs_qc` variable,
all we need to do is call `occurrences!` on this variable until all occurrences
(of which there are `size(obs_qc)`) are retrieved.

```@example
while length(obs_qc) < size(obs_qc)
    occurrences!(obs_qc)
end
```

```@example
d = obs_qc |>
  @filter(_.rank == "SPECIES") |>
  @filter(_.country == "Canada") |>
  @map({_.key, year=year(_.date), month=month(_.date)}) |>
  @groupby((_.year, _.month)) |>
  @map({year = first(unique(_.year)), month = first(unique(_.month)), obs = length(_)}) |>
  @orderby(_.month) |>
  @thenby(_.year) |>
  DataFrame

theme(:default)
@df d plot(:month, :obs, group=:year, palette=cgrad(:cividis, :year))
```
