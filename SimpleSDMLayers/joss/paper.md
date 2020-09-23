---
title: 'SimpleSDMLayers.jl and GBIF.jl: A Framework for Species 
Distribution Modelling in Julia'
tags:
  - Julia
  - ecology
  - biogeography
  - GBIF
  - species distribution modelling
authors:
  - name: Gabriel Dansereau^[Correspondance to gabriel.dansereau@umontreal.ca]
    orcid: 0000-0002-2212-3584
    affiliation: 1 # (Multiple affiliations must be quoted)
  - name: Timothée Poisot
    orcid: 0000-0002-0735-5184
    affiliation: 1
affiliations:
 - name: Département de sciences biologiques, Université de Montréal
   index: 1
date: 9 September 2020
bibliography: paper.bib

# Optional fields if submitting to a AAS journal too, see this blog post:
# https://blog.joss.theoj.org/2018/12/a-new-collaboration-with-aas-publishing
aas-doi:
aas-journal:
---

<div style="text-align: justify">

# Summary

Many analyses in Ecology and Biogeography require the use of geo-referenced 
data on species distribution, hence a tight integration between environmental  
data, species occurrence data, and spatial coordinates.
Species distribution models (SDMs), for instance, aim to predict where
environmental conditions are suitable for a given species on continuous
geographic scales. 
Thus, it requires an efficient way to access species occurrence and
environmental data, as well as a solid framework on which to build analyses
based on occurrence data. 
Here we present `GBIF.jl` and `SimpleSDMLayers.jl`, two packages in the Julia
language providing access to popular data sources for species occurrence and
environmental conditions, as well as a framework and type-system on which to
build SDM analyses.

# Statement of need 

Analyses in Ecology and Biogeography often require the use of geo-referenced
data on species occurrences and environmental variables.
This is especially true in the Species Distribution Modelling (SDM) field, where
most studies aim at predicting where a species should be found based on
environmental data.
However, such data are complex to handle and often require specialized GIS
(geographic information systems) software, different from the programming
languages used on a common basis for data analyses.
Hence, there is a need for efficient tools to manipulate bioclimatic data within
programming languages themselves.
Here, we present `SimpleSDMLayers.jl`, a package to facilitate manipulation of
geo-referenced data in _Julia_, primarily for species distribution modelling.
This package is also tightly integrated with `GBIF.jl`, which allows easy access
to the GBIF database, a common data source in SDM studies.

- Need for occurrence data
  - Covered by `rgbif` in _R_
  - Popularity of GBIF
- Need for WorldClim & environmental data
  - Covered by `dismo` in _R_
  - (no built-in models though $\rightarrow$ should we add BioClim or not)
  - Popularity of WorldClim variables in the SDM field
- Need for easy-to-manipulate layer format for species distribution modelling
  - ~kinda covered by `layer` in _R_
  - Layer manipulation workflow
  - Simpler & more efficient than `GDAL` or `ArchGDAL` for ecologists
- SDMs also know as HSMs (habitat suitability models)
- GIS functionality --> easier access all in Julia, data preparation, data
  analysis/manipulation/modelling in one place, etc. (better productivity)
- Araujo et al. 2019 for the increase in SDM studies

# Citations

Citations to entries in paper.bib should be in
[rMarkdown](http://rmarkdown.rstudio.com/authoring_bibliographies_and_citations.html)
format.

If you want to cite a software repository URL (e.g. something on GitHub without a preferred
citation) then you can do it with the example BibTeX entry below for @fidgit.

For a quick reference, the following citation commands can be used:
- `@author:2001`  ->  "Author et al. (2001)"
- `[@author:2001]` -> "(Author et al., 2001)"
- `[@author1:2001; @author2:2001]` -> "(Author1 et al., 2001; Author2 et al., 2002)"

# Figures

Figures can be included like this:
![Caption for example figure.\label{fig:example}](figure.png)
and referenced from text using \autoref{fig:example}.

Fenced code blocks are rendered with syntax highlighting:
```python
for n in range(10):
    yield f(n)
```	

# Acknowledgements

We acknowledge contributions from ... during the genesis of this project.

# References