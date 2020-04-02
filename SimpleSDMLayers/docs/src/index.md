# Simple SDM Layers in *Julia*

The `SimpleSDMLayers` provides an interface to facilitate the manipulation of
raster data for species distributions modeling in *Julia*.

The two core types of the package are `SimpleSDMPredictor` and
`SimpleSDMResponse`. The only difference between the two is that predictors are
immutable, but responses are. All types belong to the abstract `SimpleSDMLayer`,
and are organised in the same way: a `grid` field storing a matrix of data (of
any type!), and the `left`, `right`, `bottom`, and `top` coordinates (as
floating point values).

Of course these details are largely irrelevant, since we have overloaded a large
number of methods from `Base`, to make indexing, converting, and modifying data
as easy as possible.
