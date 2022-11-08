# Simple SDM Layers in *Julia*

The `SimpleSDMLayers` provides an interface to facilitate the manipulation of
raster data for species distributions modeling in *Julia*.

The two core types of the package are `SimpleSDMPredictor` and
`SimpleSDMResponse`. The only difference between the two is that predictors are
immutable, but responses are. All types belong to the abstract `SimpleSDMLayer`,
and are organised in the same way: a `grid` field storing a matrix of data (of
any type!), and the `left`, `right`, `bottom`, and `top` coordinates (as
floating point values). Of course these details are largely irrelevant, since we
have overloaded a large number of methods from `Base`, to make indexing,
converting, and modifying data as easy as possible.

The aim of the package is to deliver (i) a series of methods to manipulate
raster data, and (ii) facilitated access to common datasets used to train
species distribution models. Despite what the name may suggest, this package
does *not* implement SDMs, but is instead intended as a library usable for this
purpose. Nevertheless, the documentation contains a few example of building
models, and integrating this package with the GBIF API.

The documentations is split in three sections. The **manual** is a fairly
exhaustive documentation of the functions, methods, types, and interfaces, and
it is a good idea to skim it first, and come back for a focused reading when you
have a specific use-case in mind. The **general examples** section is a
collection of mostly disconnected workflows, intended to show how
`SimpleSDMLayers` interacts with other packages. It should give you a better
understanding of you can actually use the package.

Finally, the **SDM case studies** are a more linear series of vignettes,
covering occurrence data, variable selection, bulding a presence-only model,
generating pseudo-absences, and using a machine learning approach to do range
forecasting under climate change. This last section can be used as a template to
develop new analyses, and will use almost all the features in the package. All
of the SDM vignettes use the same species throughout - *Hypomyces lactifluorum*
is a fungus of moderate commerical importance in North America, whose
distribution is probably going to be affected by climate change.