---
title: 'Fauxcurrences.jl: simulation of realistic joint species distributions'
tags:
  - Julia
  - ecology
  - biodiversity
  - biogeography
  - species distribution models
authors:
  - name: Timothée Poisot
    orcid: 0000-0002-0735-5184
    affiliation: "1, 2" # (Multiple affiliations must be quoted)
affiliations:
 - name: Département de sciences biologiques, Université de Montréal, Montréal QC, Canada
   index: 1
 - name: Québec Centre for Biodiversity Science, McGill University, Montréal QC, Canada
   index: 2
date: 2022-06-30
bibliography: paper.bib
---

# Summary

The analysis of species distribution from document records of observations
(occurrences) is a central activity of the fields of biodiversity sciences and
biogeography. The spatial distribution of species is often highly structured in
space, with strong auto-correlation due to both species dispersal and the
auto-correlated nature of suitable habitats. Therefore, generating pseudo-random
samples of species occurrences is not a trivial task, albeit one that is
emerging as a required to develop null expectations for various predictive
models.

# Statement of need

The `Fauxcurrences.jl` package is a rapid, memory-efficient re-implementation of
`fauxcurrence`, a R package by **REF**. It integrates with the rest of the
EcoJulia ecosystem, notably the `SimpleSDMLayers.jl` package for the
manipulation of geospatial data used in species distribution analysis **REF**,
and the `GBIF.jl` package to programmatically query species occurrence data from
the Global Biodiversity Infomation Facility **REF**. `Fauxcurrences.jl` is built
at an extension of the `SimpleSDMLayers.jl` package, and re-uses most of its
functionalities (notably to ensure that the simulated data are always located
within valued cells of the raster layer serving as a reference).

`Fauxcurrences.jl` was designed to be extremely memory-efficient, in order to
allow multiple runs of simulated data to proceed in parallel even on modest
hardware. In addition, compared to the original `fauxcurrence` package, it
relies on different measures of statistical divergence (with known bounds and no
need for data smoothing), and offer the possibility to introduce a hierarchy in
the pairwise relationship of species by assigning different weights to their
pairwise divergence in the overall scoring.

This last point is particularly important as the distribution of *interacting*
species is emerging as a new area of study in biogeography **REF**. In brief,
when species do interact, there is value in relying on null models that give
more weight to their statistical divergence than to that of pairs of species who
do not **REF**. To that effect, the `Fauxcurrences.jl` package offers various
weighting schemes for the structure of pairwise dependence between species.

The intended audience for `Fauxcurrences.jl` is researchers in biogeography and
macro-ecology, notably those who need to simulate realistic and large ensembles
of species observations datasets. Because the package allows to pick the size of
the simulated dataset to be generated, it is likely to be particularly useful as
a tool to help method development, by investigating which sample size is
required **REF**, and the extent to which differential sampling between species
is impacting the results **REF**. Finally, it can be incorporated in graduate
classes in species distribution analysis, as a way to generate mock datasets to
illustrate the way various species distribution models work.

# Acknowledgements

We thank Owen G. Osborne and Adam A. Algar for discussions about the measure of
statistical divergence.

# References