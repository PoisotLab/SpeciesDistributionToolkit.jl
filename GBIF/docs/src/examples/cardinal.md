# Observations of Northern Cardinal over time

In this example, we will use the `GBIF` package to compare the number of
observations of a species over two years. Specifically, we will look at records of the Northern Cardinal (*Cardinalis cardinalis*) in Québec, from 2012 to 2013. This example will allow us to highlight how `GBIFRecords` can be used with `Query`, to select records and transform them.

```@example qc
using GBIF
using DataFrames
using Query
using StatsPlots
using Dates
```

We can get the taxonomic object for *Cardinalis cardinalis*:

```@example qc
sp_code = taxon("Cardinalis cardinalis", rank = :SPECIES)
```

The `rank = :SPECIES` argument is not required, as it is the default behaviour
of the API. Yet, it helps the readability of the code to specify what we should
be expecting. With this object created, we can define a rough bounding box for
Québec:

```@example qc
lat, lon = (44.0, 62.0), (-80.0, -56.0)
```

This bounding box will also include a few parts of the continental USA, but this
is not an issue as we will filter them out when we have done the occurrences
retrieval. It would also be possible to add a `"country" => "CA"` parameter to
the query.

```@example qc
obs_qc = occurrences(
    sp_code,
    "limit" => 300,
    "hasCoordinate" => "true",
    "decimalLatitude" => lat,
    "decimalLongitude" => lon,
    "year" => (2012, 2013)
)
```

The `length` method for this object will tell us how many records we currently
have, and the `size` method will tell us how many we can retrieve in total.
Because the query parameters are going to remain within the `obs_qc` variable
(in the `query` field, specifically), all we need to do is call `occurrences!`
on this variable until all occurrences (of which there are `size(obs_qc)`) are
retrieved.

```@example qc
while length(obs_qc) < size(obs_qc)
    occurrences!(obs_qc)
end
```

At the end of this loop, the `obs_qc` object will have all of the occurrences. Running this loop may take some time, as there are limitations on speed due to interacting with a remote server.

The result is directly iterable, so we do not need to do anything specific to
use it in a `for` loop - but if we want to get an array of `GBIFRecord`, we can
use `collect(view(obs_qc))`. Why `view`? The `GBIFRecords` type always starts
with enough "room" to put all the `GBIFRecord`, but any record that was not
retrieved yet is `#undef`. Calling `view` will give us the records that are
initialized (in versions of Julia starting from 1.5, this has no performance
cost); `collect`ing the view generates a `Vector{GBIFRecord}`. Internally,
iteration methods act on the view, so the unassigned records are invisible to
the user.

The next step is to actually convert the data into a form where we can plot
them, and this showcases how the package can be used with `Query`:

```@example qc
d = obs_qc |>
  @filter(_.rank == "SPECIES") |>
  @filter(_.country == "Canada") |>
  @map({_.key, year=year(_.date), month=month(_.date)}) |>
  @groupby((_.year, _.month)) |>
  @map({year = first(unique(_.year)), month = first(unique(_.month)), obs = length(_)}) |>
  @orderby(_.month) |>
  @thenby(_.year) |>
  DataFrame

@df d plot(:month, :obs, group=:year)
```
