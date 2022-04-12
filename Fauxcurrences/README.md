# Fauxcurrences.jl

This package is a *clean-room* re-write in Julia of most of the functionalities
of the [`fauxcurrence` package for R][paper]. The original code is licensed
under the GPL, and this package is licensed under the MIT. For this reason, the
original code, and any document distributed with it, has not been consulted
during the implementation; the work is entirely based on the published article.

[paper]: https://onlinelibrary.wiley.com/doi/full/10.1111/ecog.05880

This package uses `SimpleSDMLayers`, `Distances`, and `GBIF` as backends.