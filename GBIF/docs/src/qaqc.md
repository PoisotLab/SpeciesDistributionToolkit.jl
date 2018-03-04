# Filtering observations

Within a `GBIFRecord` object, the occurrences themselves are stored in a view.
A view is basically an array that can be masked, so it is possible to retain
all of the raw data, while only presenting the data that pass filtering.

## Apply filtering to the data

```@docs
qualitycontrol!
```

## List of filters

```@docs
have_both_coordinates
have_neither_zero_coordinates
have_no_zero_coordinates
have_no_issues
have_ok_coordinates
```

## Making your own filters

Filter functions are all sharing the same declaration: they accept a single
`GBIFRecord` object as input, and return a boolean as output. Think of the
filter as a question you ask about the occurrence object. Does it have no
know issues? If this is `true`, then we keep this record. If not, we reject it.

## Removing filters

```@docs
showall!
```
