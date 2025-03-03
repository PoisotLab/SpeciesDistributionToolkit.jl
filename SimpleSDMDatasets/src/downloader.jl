function _get_file_from_zip(layer_file, zip_file, dir)
    # Extract only the layername
    zip_archive = ZipArchives.ZipReader(read(joinpath(dir, zip_file)))
    for file_in_zip in ZipArchives.zip_names(zip_archive)
        if layer_file == file_in_zip

            # If the zip file had nested folders, we need to make sure the paths exist
            ispath(dirname(joinpath(dir, file_in_zip))) || mkpath(dirname(joinpath(dir, file_in_zip)))
            
            # Write
            out = open(joinpath(dir, layer_file), "w")
            write(out, ZipArchives.zip_readentry(zip_archive, file_in_zip, String))
            close(out)
        end
    end
    return layer_file
end

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

    # Get the layer path
    layer_file = SimpleSDMDatasets.layername(data; kwargs...)

    # Check for the fileinfo
    if isequal(_zip)(SimpleSDMDatasets.downloadtype(data))
        _get_file_from_zip(layer_file, fnm, dir)
        fnm = layer_file
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
    # Get the layer path
    layer_file = SimpleSDMDatasets.layername(data, future; kwargs...)

    # Check for the fileinfo
    if isequal(_zip)(SimpleSDMDatasets.downloadtype(data))
        _get_file_from_zip(layer_file, fnm, dir)
        fnm = layer_file
    end

    # Return everything as a tuple
    return (
        joinpath(dir, fnm),
        SimpleSDMDatasets.filetype(data, future),
        SimpleSDMDatasets.bandnumber(data, future; kwargs...),
        SimpleSDMDatasets.crs(data, future),
    )
end
