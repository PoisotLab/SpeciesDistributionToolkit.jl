# Base methods overloaded

To facilitate writing julian code, we have overloaded a number of methods from
`Base`. These methods should remove the need to interact with the `grid` field
directly, and also allow to set and get values using the geographic coordinates
(as opposed to the grid positions).

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
```
