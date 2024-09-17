"""
    provides(::Type{P}, ::Type{D}) where {P <: RasterProvider, D <: RasterDataset}

This is the core function upon which the entire interface is built. Its purpose
is to specify whether a specific dataset is provided by a specific provider.
Note that this function takes two arguments, as opposed to a `RasterData`
argument, because it is called in the *inner* constructor of `RasterData`: you
cannot instantiate a `RasterData` with an incompatible provider/dataset
combination.

The default value of this function is `false`, and to allow the use of a dataset
with a provider, it is *required* to overload it for this specific pair so that
it returns `true`.
"""
provides(::Type{P}, ::Type{D}) where {P <: RasterProvider, D <: RasterDataset} = false

"""
    provides(::R, ::F) where {R <: RasterData, F <: Future}

This method for `provides` specifies whether a `RasterData` combination has
support for the value of the `Future` (a combination of a `FutureScenario` and a
`FutureModel`) given as the second argument. Note that this function is not
called as part of the `Future` constructor (because models and scenarios are
messy *and* dataset dependent), but is still called when requesting data.

The default value of this function is `false`, and to allow the use of a future
dataset with a given provider, it is *required* to overload it so that it
returns `true`.
"""
provides(::R, ::F) where {R <: RasterData, F <: Projection} = false

"""
    downloadtype(::R) where {R <: RasterData}

This method returns a `RasterDownloadType` that is used *internally* to be more
explicit about the type of object that is downloaded from the raster source. The
supported values are `_file` (the default, which is an ascii, geotiff, NetCDF,
etc. single file), and `_zip` (a zip archive containing files). This is a trait
because we *cannot* trust file extensions.
"""
downloadtype(::R) where {R <: RasterData} = _file

"""
    downloadtype(data::R, ::F) where {R <: RasterData, F <: Future}

This method provides the type of the downloaded object for a combination of a
raster source and a future scenario as a `RasterDownloadType`.

If no overload is given, this will default to `downloadtype(data)`, as we can
assume that the type of downloaded object is the same for both current and
future scenarios.
"""
downloadtype(data::R, ::F) where {R <: RasterData, F <: Projection} = downloadtype(data)

"""
    filetype(::R) where {R <: RasterData}

This method returns a `RasterFileType` that represents the format of the raster
data. `RasterFileType` is an enumerated type. This overload is particularly
important as it will determine how the returned file path should be read.

The default value is `_tiff`.
"""
filetype(::R) where {R <: RasterData} = _tiff

"""
    filetype(data::R, ::F) where {R <: RasterData, F <: Future}

This method provides the format of the stored raster for a combination of a
raster source and a future scenario as a `RasterFileType`.

If no overload is given, this will default to `filetype(data)`, as we can assume
that the raster format is the same for both current and future scenarios.
"""
filetype(data::R, ::F) where {R <: RasterData, F <: Projection} = filetype(data)

"""
    resolutions(::R) where {R <: RasterData}

This method controls whether the dataset has a *resolution*, *i.e.* a grid size.
If this is `nothing` (the default), it means that the dataset is only given at a
set resolution.

An overload of this method is *required* when there are multiple resolutions
available, and *must* return a `Dict` with numeric keys (for the resolution) and
a string value giving an explanation of the resolution.

Any dataset with a return value that is not `nothing` *must* accept the
`resolution` keyword.
"""
resolutions(::R) where {R <: RasterData} = nothing

"""
    resolutions(data::R, ::F) where {R <: RasterData, F <: Future}

This methods control the `resolutions` for a future dataset. Unless overloaded,
it will return `resolutions(data)`.
"""
resolutions(data::R, ::F) where {R <: RasterData, F <: Projection} = resolutions(data)

"""
    months(::R) where {R <: RasterData}

This method controls whether the dataset has monthly layers. If this is
`nothing` (the default), it means that the dataset is not accessible at a
monthly resolution.

An overload of this method is *required* when there are multiple months
available, and *must* return a `Vector{Dates.Month}`.

Any dataset with a return value that is not `nothing` *must* accept the
`month` keyword.
"""
months(::R) where {R <: RasterData} = nothing
months(data::R, ::F) where {R <: RasterData, F <: Projection} = months(data)

"""
    timespans(data::R, ::F) where {R <: RasterData, F <: Future}

For datasets with a `Future` scenario, this method should return a `Vector` of
`Pairs`, which are formatted as

~~~
Year(start) => Year(end)
~~~

There is a method working on a single `RasterData` argument, defaulting to
returning `nothing`, but it *should never* be overloaded.
"""
timespans(::R, ::F) where {R <: RasterData, F <: Projection} = nothing
timespans(::R) where {R <: RasterData} = nothing

"""
    layers(::R) where {R <: RasterData}

This method controls whether the dataset has named layers. If this is `nothing`
(the default), it means that the dataset will have a single layer.

An overload of this method is *required* when there are multiple layers
available, and *must* return a `Vector`, usually of `String`. Note that by
default, the layers can also be accessed by using an `Integer`, in which case
`layer=i` will be the *i*-th entry in `layers(data)`.

Any dataset with a return value that is not `nothing` *must* accept the `layer`
keyword.
"""
layers(::R) where {R <: RasterData} = nothing
layers(data::R, ::F) where {R <: RasterData, F <: Projection} = layers(data)

"""
    layerdescriptions(data::R) where {R <: RasterData}

Human-readable names the layers. This *must* be a dictionary mapping the layer names (as returned by `layers`) to a string explaining the contents of the layers.
"""
layerdescriptions(data::R) where {R <: RasterData} = Dict(zip(layers(data), layers(data)))
layerdescriptions(data::R, ::F) where {R <: RasterData, F <: Projection} =
    layerdescriptions(data)

"""
    extrakeys(::R) where {R <: RasterData}

This method controls whether the dataset has additional keys. If this is
`nothing` (the default), it means that the dataset can be accessed using only
the default keys specified in this interface.

An overload of this method is *required* when there are additional keywords
needed to access the data (*e.g.* `full=true` for the `EarthEnv` land-cover
data), and *must* return a `Dict`, with `Symbol` keys and `Tuple`s of pairs as
values.

The key is the keyword argument passed to `downloader` and the tuple lists all
accepted values, in the format `value => explanation`.

Any dataset with a return value that is not `nothing` *must* accept the keyword
arguments specified in the return value.
"""
extrakeys(::R) where {R <: RasterData} = nothing
extrakeys(data::R, ::F) where {R <: RasterData, F <: Projection} = extrakeys(data)

"""
    destination(::RasterData{P, D}; kwargs...) where {P <: RasterProvider, D <: RasterDataset}

This method specifies where the data should be stored *locally*. By default, it
is the `_LAYER_PATH`, followed by the provider name, followed by the dataset
name.
"""
destination(::RasterData{P, D}; kwargs...) where {P <: RasterProvider, D <: RasterDataset} =
    joinpath(SimpleSDMDatasets._LAYER_PATH, string(P), string(D))

destination(
    ::RasterData{P, D},
    ::Projection{S, M};
    kwargs...,
) where {P <: RasterProvider, D <: RasterDataset, S <: FutureScenario, M <: FutureModel} =
    joinpath(
        SimpleSDMDatasets._LAYER_PATH,
        string(P),
        string(D),
        replace(string(S), "_" => "-"),
        replace(string(M), "_" => "-"),
    )

"""
    source(::RasterData{P, D}; kwargs...) where {P <: RasterProvider, D <: RasterDataset}

This method specifies the URL for the data. It defaults to `nothing`, so this
method *must* be overloaded.
"""
source(::RasterData{P, D}; kwargs...) where {P <: RasterProvider, D <: RasterDataset} =
    nothing

source(
    ::RasterData{P, D},
    ::Projection{S, M};
    kwargs...,
) where {P <: RasterProvider, D <: RasterDataset, S <: FutureScenario, M <: FutureModel} =
    nothing

layername(::R; kwargs...) where {R <: RasterData} = ""
layername(::R, ::F; kwargs...) where {R <: RasterData, F <: Projection} = ""

bandnumber(::R; kwargs...) where {R <: RasterData} = 1
bandnumber(::R, ::F; kwargs...) where {R <: RasterData, F <: Projection} = 1

crs(::R) where {R <: RasterData} = _wgs84
crs(data::R, ::F) where {R <: RasterData, F <: Projection} = crs(data)

"""
    url(::P) where {P <: DataProvider}

The URL for the data provider - if there is no specific URL for each dataset, it
is enough to define this one.
"""
url(::Type{P}) where {P <: RasterProvider} = ""
url(::RasterData{P, D}) where {P <: RasterProvider, D <: RasterDataset} = url(P)
url(data::R, ::F) where {R <: RasterData, F <: Projection} = url(data)

"""
    blurb(::Type{P}) where {P <: RasterProvider}
"""
blurb(::Type{P}) where {P <: RasterProvider} = ""
blurb(::RasterData{P, D}) where {P <: RasterProvider, D <: RasterDataset} = blurb(P)