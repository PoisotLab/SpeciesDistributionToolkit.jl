function _get_raster(::Type{WorldClim}, ::Type{Elevation}, layer::Integer, resolution=10.0)
    res = Dict(0.5 => "30s", 2.5 => "2.5m", 5.0 => "5m", 10.0 => "10m")
    
    path = joinpath(SimpleSDMLayers._layers_assets_path, _rasterpath(WorldClim), _rasterpath(Elevation), res[resolution])
    isdir(path) || mkpath(path)

    output_file = joinpath(path, "wc2.1_$(res[resolution])_elev.tif")
    zip_file = joinpath(path, "wc2.1_$(res[resolution])_elev.zip")

    if !isfile(path)
        if !isfile(zip_file)
            root = "https://biogeo.ucdavis.edu/data/worldclim/v2.1/base/"
            stem = "wc2.1_$(res[resolution])_elev.zip"
            Downloads.download(root * stem, zip_file)
        end
        zf = ZipFile.Reader(zip_file)
        file_to_read =
            first(filter(f -> joinpath(path, f.name) == output_file, zf.files))

        if !isfile(joinpath(path, file_to_read.name))
            write(joinpath(path, file_to_read.name), read(file_to_read))
        end
        close(zf)
    end

    return joinpath(path, file_to_read.name)
end

function _get_raster(::Type{WorldClim}, ::Type{BioClim}, layer::Integer, resolution=10.0)
    1 ≤ layer ≤ 19 || throw(ArgumentError("The layer must be between 1 and 19"))

    res = Dict(0.5 => "30s", 2.5 => "2.5m", 5.0 => "5m", 10.0 => "10m")

    path = joinpath(SimpleSDMLayers._layers_assets_path, _rasterpath(WorldClim), _rasterpath(BioClim), res[resolution])
    isdir(path) || mkpath(path)

    output_file = joinpath(path, "wc2.1_$(res[resolution])_bio_$(layer).tif")
    zip_file = joinpath(path, "bioclim_2.1_$(res[resolution]).zip")

    if !isfile(path)
        if !isfile(zip_file)
            root = "https://biogeo.ucdavis.edu/data/worldclim/v2.1/base/"
            stem = "wc2.1_$(res[resolution])_bio.zip"
            Downloads.download(root * stem, zip_file)
        end
        zf = ZipFile.Reader(zip_file)
        file_to_read =
            first(filter(f -> joinpath(path, f.name) == output_file, zf.files))

        if !isfile(joinpath(path, file_to_read.name))
            write(joinpath(path, file_to_read.name), read(file_to_read))
        end
        close(zf)
    end

    return joinpath(path, file_to_read.name)
end

function _get_raster(::Type{WorldClim}, ::Type{BioClim}, mod::CMIP6, fut::SharedSocioeconomicPathway, resolution=10.0, year="2021-2040")
    res = Dict(2.5 => "2.5m", 5.0 => "5m", 10.0 => "10m")

    path = joinpath(SimpleSDMLayers._layers_assets_path, _rasterpath(WorldClim), _rasterpath(BioClim), _rasterpath(mod), _rasterpath(fut), year, res[resolution])
    isdir(path) || mkpath(path)

    zip_file = joinpath(path, "$(res[resolution])_$(_rasterpath(mod))_$(_rasterpath(fut)).zip")
    if !isfile(path)
        if !isfile(zip_file)
            root = "https://biogeo.ucdavis.edu/data/worldclim/v2.1/fut/"
            stem = "$(res[resolution])m/wc2.1_$(res[resolution])_bioc_$(_rasterpath(mod))_$(_rasterpath(fut))_$(year).zip"
            Downloads.download(root * stem, zip_file)
        end
        zf = ZipFile.Reader(zip_file)
        file_to_read = only(zf.files)
        if !isfile(joinpath(path, "stack.tif"))
            write(joinpath(path, "stack.tif"), read(file_to_read))
        end
        close(zf)
    end

    return joinpath(path, "stack.tif")
end
