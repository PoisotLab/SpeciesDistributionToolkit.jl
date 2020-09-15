---
title: 'GBIF.jl and SimpleSDMLayers.jl: Data and Framework for Species 
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

# Summary

Many analyses in Ecology and Biogeography require the use of geo-referenced 
data on species distribution, hence a tight integration between environmental  
data, species occurrence data, and spatial coordinates. Species distribution
models (SDMs), for instance, aim to predict where environmental conditions
are suitable for a given species on continuous geographic scales. Thus, it
requires an efficient way to access species occurrence and environmental data,
as well as a solid framework on which to build analyses based on occurrence
data. Here we present GBIF.jl and SimpleSDMLayers.jl, two packages in the Julia
language providing access to popular data sources for species occurrence and
environmental conditions, as well as a framework and type-system on which to
build SDM analyses.

# Statement of need 

# Mathematics

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