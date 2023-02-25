## Simple Layers for Species Distributions Modelling

***MAINTENANCE MODE*** - this repo is being move to a monorepo with better integration between features

**What is this package**? `SimpleSDMLayers` offers a series of types, methods,
and additional helper functions to build species distribution models. It does
*not* implement any species distribution models, although there are a few
examples of how this can be done in the documentation.

**Who is developing this package**? This package is primarily maintained by the
[Quantitative & Computational Ecology][qce] group at Université de Montréal, and
is part of the broader EcoJulia organisation.

[qce]: https://poisotlab.io/

**Can I sponsor this project**? Sure! There is a link in the sidebar on the right.
Any money raised this way will go towards the snacks and coffee fund for students,
or any charitable cause we like to support.

**How can I cite this package**? This repository itself can be cited through its
Zenodo archive ([`4902317`][zendoi]; this will generate a DOI for every
release), and there is a manuscript in *Journal of Open Science Software*
describing the package as well ([`10.21105/joss.02872`][jossdoi]).

[zendoi]: https://zenodo.org/record/4902317
[jossdoi]: https://joss.theoj.org/papers/10.21105/joss.02872

**Is there a manual to help with the package**? Yes. You can read the
documentation for the current [stable release][stable], which includes help on
the functions, as well as a series of tutorials and vignettes ranging from
simple analyses to full-fledged mini-studies.

[stable]: https://ecojulia.github.io/SimpleSDMLayers.jl/stable/

**Don't you have some swanky badges to display**? We do. They are listed at the
very end of this README.

**Can I contribute to this project**? Absolutely. The most immediate way to
contribute is to *use* the package, see what breaks, or where the documentation
is incomplete, and [open an issue]. If you have a more general question, you can
also [start a discussion]. Please read the [Code of Conduct][CoC] and the
[contributing guidelines][contr].

[CoC]: https://github.com/EcoJulia/SimpleSDMLayers.jl/blob/master/CODE_OF_CONDUCT.md
[contr]: https://github.com/EcoJulia/SimpleSDMLayers.jl/blob/master/CONTRIBUTING.md
[open an issue]: https://github.com/EcoJulia/SimpleSDMLayers.jl/issues
[start a discussion]: https://github.com/EcoJulia/SimpleSDMLayers.jl/discussions

**How do I install the package**? The latest tagged released can be installed
just like any Julia package: `]add SimpleSDMLayers`. To get the most of it, we
strongly suggest to also add `StatsPlots` and `GBIF`.

**Why are there no code examples in this README**? In short, because keeping the
code in the README up to date with what the package actually does is tedious;
the documentation is built around many case studies, with richer text, and with
a more narrative style. This is where you will find the code examples and the
figures you are looking for!

---

![GitHub](https://img.shields.io/github/license/EcoJulia/SimpleSDMLayers.jl)

[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active) ![GitHub contributors](https://img.shields.io/github/contributors/EcoJulia/SimpleSDMLayers.jl) ![GitHub commit activity](https://img.shields.io/github/commit-activity/m/EcoJulia/SimpleSDMLayers.jl)

![GitHub last commit](https://img.shields.io/github/last-commit/EcoJulia/SimpleSDMLayers.jl) ![GitHub issues](https://img.shields.io/github/issues-raw/EcoJulia/SimpleSDMLayers.jl) ![GitHub pull requests](https://img.shields.io/github/issues-pr-raw/EcoJulia/SimpleSDMLayers.jl)

![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/EcoJulia/SimpleSDMLayers.jl?sort=semver) ![GitHub Release Date](https://img.shields.io/github/release-date/EcoJulia/SimpleSDMLayers.jl)

![GitHub Workflow Status](https://img.shields.io/github/workflow/status/EcoJulia/SimpleSDMLayers.jl/CI?label=CI%20workflow) ![Codecov](https://img.shields.io/codecov/c/github/EcoJulia/SimpleSDMLayers.jl) ![GitHub Workflow Status](https://img.shields.io/github/workflow/status/EcoJulia/SimpleSDMLayers.jl/Documentation?label=Documentation%20workflow)
