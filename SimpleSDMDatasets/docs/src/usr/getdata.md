# Getting data

The point of this package is to be simple; if you want to get the data for the
CHELSA dataset, specifically the BIO8 BioClim variable, in the years 2041 to
2070, under SSP126 according to the UKESM1-0-LL model, you really only need two
things.

The first is a description of the dataset to query, which is simply:

~~~julia
data = RasterData(CHELSA2, BioClim)
~~~

The second is a description of the scenario for which you want this data:

~~~julia
future = Future(SSP126, UKESM1_0_LL)
~~~

Why? The package relies on a series of checks to make sure that you only query
the files that exist, and there are various places in the package where this is
checked (the very first is when calling `RasterData`, in fact).

The range of years to be queried is given by the `timespan` argument, which is a
`Pair` of `Year`s (so you will need to load `Dates`):

~~~julia
using Dates
ts = Year(2041) => Year(2070)
~~~

The BioClim variable BIO8 is called a *layer*; you can use
`SimpleSDMDatasets.layers(data, future)` to see the list of possible layers. We
can use the string `"BIO8"` directly.

To get the data themselves, the one function to call is `downloader`:

~~~julia
downloader(data, future; timespan=ts, layer="BIO8")
~~~

Calling this function will first start a series of checks, in order to avoid
requesting data that do not exist. Should these checks fail, they will do so
with an informative error message (for example, if some keywords arguments are
given that are not relevant). The next step is to download the data, and store
them in a central location.

The central location is determined when loading the package, and will *default*
to a sub-folder within your Julia folder (the `DEPOT_PATH`), or your home
directory if there is no `DEPOT_PATH`. This can also be over-ruled by giving a
`SDMLAYERS_PATH` environmental variable (if it points to a directory that does
not exist, the package will create it).

The dataset you requested will then be downloaded, named, and the `downloader`
function will return a `Tuple` with three elements:

~~~
(
    "/some/absolute/path/to/data/CHELSA2/BioClim/SSP126/UKESM1-0-LL/chelsa_bio8_2041-2070_ukesm1-0-ll_ssp126_v.2.1.tif",
    SimpleSDMDatasets._tiff, 
    1
)
~~~

The first element of this tuple points to the file. The second element is the
type of the file, according to the `RasterFileType` enum, which will let you
know how to read this file. The last element is the band number to read (this
defaults to `1`, even if there is a single band in the raster).

**That's it**. This package is not *reading* the data, it is managing and
retrieving them for you. Next time you will request the same data, by calling
the same `downloader` function, they will already be downloaded, and ready to
use.