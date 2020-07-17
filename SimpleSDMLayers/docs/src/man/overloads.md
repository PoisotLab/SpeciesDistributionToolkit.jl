# Methods overloaded

To facilitate writing julian code, we have overloaded a number of methods from
`Base`. These methods should remove the need to interact with the `grid` field
directly, and also allow to set and get values using the geographic coordinates
(as opposed to the grid positions).

## From `Base`

```@docs
convert
copy
eltype
size
stride
eachindex
getindex
setindex!
similar
Base.sum
Base.maximum
Base.minimum
Base.extrema
```

## From `Broadcast`

```@docs
broadcast
```

## From `Statistics`

```@docs
Statistics.mean
Statistics.median
Statistics.std
```
