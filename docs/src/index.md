# Species Distributions Toolkit

This package is a wrapper around a series of tools that are meant to simplify the building
of species distribution models. The models themselves are *not* part of this package, which
is intended to take the tedium out of data preparation. In particular, the package offers

- a wrapper around the GBIF occurrences API to access occurrence data
- ways to generate pseudo-absences based on a series of heuristics
- a simple way to represent layers as either mutable or immutable objects
- a way to collect historic and future climate and land-use data to feed into the models

This documentation is therefore pretty vast: it offers an in-depth explanation of what the
component packages are doing and how they work, discusses the interactions between these
packages, and offers a series of illustrations which includes some examples of models of
species distributions.
