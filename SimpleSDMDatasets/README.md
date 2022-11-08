# SimpleSDMDatasets

This *will* serve as a replacement for the data system in *SimpleSDMLayers.jl*.

![GitHub Workflow Status](https://img.shields.io/github/workflow/status/PoisotLab/SimpleSDMDatasets.jl/Test%20suite?style=flat-square) ![Codecov](https://img.shields.io/codecov/c/github/PoisotLab/SimpleSDMDatasets.jl?style=flat-square)

![GitHub top language](https://img.shields.io/github/languages/top/PoisotLab/SimpleSDMDatasets.jl?style=flat-square&logo=julia)

This package has a smaller mission statement, namely:

1. provide a simple interface to get access to raster data
2. implement this interface for commonly used data
3. ensure that the raster data are downloaded as needed and stored in a central location
4. provide enough checks that users can build on top of it rapidly (for example,
   the wrapper for bioclim in CHELSA2.1 is only about 15 loc)

For now this is a *work in progress*