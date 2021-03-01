# Working with DataFrames

Both `SimpleSDMLayers.jl` and `GBIF.jl` offer an optional integration with the
`DataFrames.jl` package. Hence, the example above could also be approached with
a `DataFrame`-centered workflow.

For example, after getting occurrences through `GBIF.jl`, we can convert them
to a `DataFrame`:

```@example temp
using DataFrames
kf_df = DataFrame(kf_occurrences);
last(kf_df, 5)
```

We can then extract the temperature values for all the occurrences:

```@example temp
temperature[kf_df]
```

Or we can clip the layers according to the occurrences:

```@example temp
clip(temperature, kf_df)
```

We can also export all the values from a layer to a `DataFrame` with their
corresponding coordinates: 

```@example temp
temperature_df = DataFrame(temperature_clip);
last(temperature_df, 5)
```

Or do so with multiple layers at the same time:

```@example temp
climate_clip = [temperature_clip, precipitation_clip]
climate_df = DataFrame(climate_clip);
rename!(climate_df, :x1 => :temperature, :x2 => :precipitation);
last(climate_df, 5)
```

We can finally plot the values in a similar way:

```@example temp
filter!(x -> !isnothing(x.temperature) && !isnothing(x.precipitation), climate_df);
histogram2d(climate_df.temperature, climate_df.precipitation, c=:viridis)
scatter!(temperature_clip[kf_df], precipitation_clip[kf_df], lab="", c=:white, msc=:orange)
```