"""
    downloader
"""
function SimpleSDMDatasets.downloader(
    data::PolygonData{P,D};
    kw...
) where {P,D}
    SimpleSDMDatasets.keychecker(data; kw...)
    dt = SimpleSDMDatasets.downloadtype(data)
    url, filename, dir = source(data; kw...)
    downloaded_path = _download(dt, url, filename, dir)
    # This bit is important in case the archive is extracted in a folder whose
    # name is the name of the file we want, which happens with OneEarth notably
    if P == OneEarth
        downloaded_path = joinpath(downloaded_path, basename(downloaded_path))
    end
    return postprocess(data, _read(SimpleSDMDatasets.filetype(data), downloaded_path); kw...)
end

function _download(::Type{_File}, url, filename, dir)
    isdir(dir) || mkpath(dir)

    !isfile(joinpath(dir, filename)) && Downloads.download(url, joinpath(dir, filename))

    return joinpath(dir, filename)
end

function _download(::Type{_Zip}, url, filename, dir)
    isdir(dir) || mkpath(dir)

    # Check for file existence, download if not
    !isfile(joinpath(dir, filename)) && Downloads.download(url, joinpath(dir, filename))

    zip_path = joinpath(dir, filename)
    target_dir = joinpath(dir, String(split(zip_path, ".zip")[1]))
    !isdir(target_dir) && _unzip(zip_path, target_dir)
    return target_dir
end

function _unzip(zip_path, target_dir)
    mkdir(target_dir)
    zip_archive = ZipArchives.ZipReader(read(zip_path))
    for file_in_zip in ZipArchives.zip_names(zip_archive)
        if !contains(file_in_zip, "__MACOSX") # BE BETTER FFS
            out = open(joinpath(target_dir, file_in_zip), "w")
            write(out, ZipArchives.zip_readentry(zip_archive, file_in_zip, String))
            close(out)
        end
    end
end
