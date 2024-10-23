# SimpleSDMDatasets

The purpose of this package is to get raster datasets for use in biogeography
work, retrieve them from online locations, and store them in a central location
to avoid data duplication. Datasets are downloaded *upon request*, and only the
required files are downloaded.

The package is built around two "pillars":

1. An *interface* based on traits, which specifies where the data live (remotely
   and locally), what the shape of the data is, and which keyword arguments are
   usable to query the data.

2. A *type system* to identify which datasets are accessible through various
   providers, and which future scenarios are available.

The combination of the interface and the type system means that adding a new
dataset is relatively straightforward, and in particular that there is no need
to write dataset-specific code to download the files (beyond specifying where
the data live).

The purpose of the documentation is to (i) provide a high-level overview of how
to get data from a user point of view, (ii) list the datasets that are
accessible for users through the package alongside their most important features
and (iii) give a comprehensive overview of the way the interface works, to
facilitate the addition of new data sources.
