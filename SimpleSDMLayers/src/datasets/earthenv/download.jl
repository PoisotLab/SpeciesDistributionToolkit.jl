function _get_raster(::Type{EarthEnv}, ::Type{LandCover}, layer::Integer, full::Bool=false)
    1 ≤ layer ≤ 12 || throw(ArgumentError("The layer must be between 1 and 12"))

    filetype = full ? "complete" : "partial"
    path = joinpath(SimpleSDMLayers._layers_assets_path, _rasterpath(EarthEnv), _rasterpath(LandCover), filetype)
    isdir(path) || mkpath(path)

    root = "https://data.earthenv.org/consensus_landcover/"
    stem = full ? "with_DISCover/consensus_full_class_$(layer).tif" :
        "without_DISCover/Consensus_reduced_class_$(layer).tif"
    filename = "landcover_$(filetype)_$(layer).tif"

    if !isfile(joinpath(path, filename))
        layerrequest = HTTP.request("GET", root * stem)
        open(joinpath(path, filename), "w") do layerfile
            write(layerfile, String(layerrequest.body))
        end
    end

    return joinpath(path, filename)
end

function _get_raster(::Type{EarthEnv}, ::Type{HabitatHeterogeneity}, layer::Integer, resolution::Int64=25)
    1 ≤ layer ≤ 14 || throw(ArgumentError("The layer must be between 1 and 14"))

    path = joinpath(SimpleSDMLayers._layers_assets_path, _rasterpath(EarthEnv), _rasterpath(HabitatHeterogeneity), string(resolution))
    isdir(path) || mkpath(path)

    # Layer names
    layernames = ["cv", "evenness", "range", "shannon", "simpson", "std", "Contrast", "Correlation", "Dissimilarity", "Entropy", "Homogeneity", "Maximum", "Uniformity", "Variance"]

    # Get the correct value for the numerical precision
    res = 16
    if resolution == 1
        if layer in [7, 9, 14]
            res = 32
        end
    end
    if resolution == 5
        if layer in [1, 7, 9, 14]
            res = 32
        end
    end
    if resolution == 25
        if layer in [7, 9, 10, 14]
            res = 32
        end
    end

    root = "https://data.earthenv.org/habitat_heterogeneity/"
    stem = "$(resolution)km/$(layernames[layer])_01_05_$(resolution)km_uint$(res).tif"
    filename = "$(layernames[layer])_$(resolution)km.tif"

    if !isfile(joinpath(path, filename))
        layerrequest = HTTP.request("GET", root * stem)
        open(joinpath(path, filename), "w") do layerfile
            write(layerfile, String(layerrequest.body))
        end
    end

    return joinpath(path, filename)
end