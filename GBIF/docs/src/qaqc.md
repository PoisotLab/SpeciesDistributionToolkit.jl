# Filtering observations

Within a `GBIFRecord` object, the occurrences themselves are stored in a view.
A view is basically an array that can be masked, so it is possible to retain
all of the raw data, while only presenting the data that pass filtering.

## Apply filters to the data

```@docs
filter!
```

## Removing filters

```@docs
allrecords!
```

## List of built-in filters

```@docs
have_both_coordinates
have_neither_zero_coordinates
have_no_zero_coordinates
have_no_issues
have_ok_coordinates
have_a_date
```

## Making your own filters

Filter functions are all sharing the same declaration: they accept a single
`GBIFRecord` object as input, and return a boolean as output. Think of the
filter as a question you ask about the occurrence object. Does it have no know
issues? If this is `true`, then we keep this record. If not, we reject it.

## Filtering occurrences after download

The `GBIFRecords` objects can be used with the `Query.jl` package. For example,
to get the observations from France in the most recent 20 observations, we can
use:

~~~ julia
using Query
o = occurrences()
@from i in o begin
    @where i.country == "France"
    @select {i.key, i.species}
    @collect
end
~~~
