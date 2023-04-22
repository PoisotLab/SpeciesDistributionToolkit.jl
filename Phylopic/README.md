# Phylopic.jl

This package is a *thin* wrapper around the Phylopic API, which is currently not covering
the entire API.

~~~julia
using Phylopic
"chiroptera" |>
    Phylopics.names |>
    Phylopics.thumbnail
~~~
