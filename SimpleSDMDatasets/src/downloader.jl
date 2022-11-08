function downloader(
    data::RasterData{P, D};
    kwargs...,
) where {P <: RasterProvider, D <: RasterDataset}
    keychecker(data; kwargs...)

    url, fnm, dir = SimpleSDMDatasets.source(data; kwargs...)

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
    )
end

function downloader(
    data::RasterData{P, D},
    future::Future{S, M};
    kwargs...,
) where {P <: RasterProvider, D <: RasterDataset, S <: FutureScenario, M <: FutureModel}
    keychecker(data, future; kwargs...)

    url, fnm, dir = SimpleSDMDatasets.source(data, future; kwargs...)

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
    )
end