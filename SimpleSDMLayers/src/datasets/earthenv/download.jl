function download_layer(l::EarthEnv, layer::Integer)
    1 ≤ layer ≤ 12 || throw(ArgumentError("The layer must be between 1 and 12"))

    path = SimpleSDMLayers.assets_path()

    root = "https://data.earthenv.org/consensus_landcover/"
    stem = l.full ? "with_DISCover/consensus_full_class_$(layer).tif" :
        "without_DISCover/Consensus_reduced_class_$(layer).tif"
    filetype = l.full ? "complete" : "partial"
    filename = "landcover_$(filetype)_$(layer).tif"

    if !isfile(joinpath(path, filename))
        layerrequest = HTTP.request("GET", root * stem)
        open(joinpath(path, filename), "w") do layerfile
            write(layerfile, String(layerrequest.body))
        end
    end

    return joinpath(path, filename)
end