function SimpleSDMLayers.SimpleSDMPredictor(data::R; kwargs...) where {R <: RasterData}
    # TODO: remove the bounding box information (left/right/top/bottom) from kwargs...

    # Get the data
    filepath, filetype, bandnumber, crs = downloader(data;)

    if isequal(SimpleSDMDatasets._tiff)(filetype)
        return geotiff(SimpleSDMPredictor, filepath, bandnumber)
    end

    return nothing
end

function SimpleSDMLayers.SimpleSDMPredictor(
    data::R,
    future::F;
    kwargs...,
) where {R <: RasterData, F <: Future}
    # TODO: remove the bounding box information (left/right/top/bottom) from kwargs...

    # Get the data
    filepath, filetype, bandnumber, crs = downloader(data;)

    if isequal(SimpleSDMDatasets._tiff)(filetype)
        return geotiff(SimpleSDMPredictor, filepath, bandnumber)
    end

    return nothing
end
