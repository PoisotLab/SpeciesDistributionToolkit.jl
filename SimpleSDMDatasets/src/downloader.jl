function _drop_package_name_from_path(path)
    # Module name with a dot
    _target = "$(@__MODULE__)."
    path = replace(path, _target => "")
    path = replace(path, lowercase(_target) => "")
    path = replace(path, uppercase(_target) => "")
    return path
end

"""
    SimpleSDMDatasets.downloader

...
"""
function downloader(
    data::RasterData{P, D};
    kwargs...,
) where {P <: RasterProvider, D <: RasterDataset}
    keychecker(data; kwargs...)

    url, fnm, dir = SimpleSDMDatasets.source(data; kwargs...)

    # Remove the package name from the path strings if present
    url = _drop_package_name_from_path(url)
    fnm = _drop_package_name_from_path(fnm)
    dir = _drop_package_name_from_path(dir)

    # Check for path existence
    isdir(dir) || mkpath(dir)

    # Check for file existence, download if not
    if ~isfile(joinpath(dir, fnm))
        Downloads.download(url, joinpath(dir, fnm))
    end

    # Check for the fileinfo
    if isequal(_zip)(SimpleSDMDatasets.downloadtype(data))
        # Extract only the layername
        r = ZipFile.Reader(joinpath(dir, fnm))
        for f in r.files
            if isequal(layername(data; kwargs...))(f.name)
                fnm = layername(data; kwargs...)
                write(joinpath(dir, f.name), read(f, String))
            end
        end
        close(r)
    end

    # Return everything as a tuple
    return (
        joinpath(dir, fnm),
        SimpleSDMDatasets.filetype(data),
        SimpleSDMDatasets.bandnumber(data; kwargs...),
        SimpleSDMDatasets.crs(data),
    )
end

function downloader(
    data::RasterData{P, D},
    future::Projection{S, M};
    kwargs...,
) where {P <: RasterProvider, D <: RasterDataset, S <: FutureScenario, M <: FutureModel}
    keychecker(data, future; kwargs...)

    url, fnm, dir = SimpleSDMDatasets.source(data, future; kwargs...)

    # Remove the package name from the path strings if present
    url = _drop_package_name_from_path(url)
    fnm = _drop_package_name_from_path(fnm)
    dir = _drop_package_name_from_path(dir)

    # Check for path existence
    isdir(dir) || mkpath(dir)

    # Check for file existence, download if not
    if ~isfile(joinpath(dir, fnm))
        Downloads.download(url, joinpath(dir, fnm))
    end

    # Check for the fileinfo
    if isequal(_zip)(SimpleSDMDatasets.downloadtype(data, future))
        # Extract only the layername
        r = ZipFile.Reader(joinpath(dir, fnm))
        for f in r.files
            if isequal(SimpleSDMDatasets.layername(data, future; kwargs...))(f.name)
                fnm = SimpleSDMDatasets.layername(data, future; kwargs...)
                write(joinpath(dir, f.name), read(f, String))
            end
        end
        close(r)
    end

    # Return everything as a tuple
    return (
        joinpath(dir, fnm),
        SimpleSDMDatasets.filetype(data, future),
        SimpleSDMDatasets.bandnumber(data, future; kwargs...),
        SimpleSDMDatasets.crs(data, future),
    )
end
