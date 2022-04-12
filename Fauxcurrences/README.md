# Fauxcurrences.jl

This package is a *clean-room* re-write in Julia of most of the functionalities
of the [`fauxcurrence` package for R][paper]. The original code is licensed
under the GPL, and this package is licensed under the MIT. For this reason, the
original code, and any document distributed with it, has not been consulted
during the implementation; the work is entirely based on the published article.

[paper]: https://onlinelibrary.wiley.com/doi/full/10.1111/ecog.05880

**Why?** Interoperability: this package uses `SimpleSDMLayers`, `Distances`, and
`GBIF` as backends, making it fit very snuggly with the rest of the (Eco)Julia
ecosystem. Licensing: the package uses the more liberal MIT license, imposing
fewer constraints on contributors and users. Expandability: the package is built
on a lot of modular functions, to ensure that custom workflows can be built.
Performance: by relying on pre-allocated matrices, the package is fairly fast.