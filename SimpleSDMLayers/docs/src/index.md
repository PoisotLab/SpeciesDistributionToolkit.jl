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