"""
    SimpleSDMLayers.SimpleSDMPredictor(data::R; kwargs...) where {R <: RasterData}

Read a layer as a `SimpleSDMPredictor` (immutable) from a `RasterData` and a source of keywords. The allowed keywors are listed for each `RasterData`.
"""
function SimpleSDMLayers.SimpleSDMPredictor(data::R; kwargs...) where {R <: RasterData}
    # Split the bounding box from the rest of the data
    boundingbox, arguments = _boundingbox_out_of_kwargs(kwargs)

    # Get the data
    filepath, filetype, bandnumber, _ = downloader(data; arguments...)

    if isequal(SimpleSDMDatasets._tiff)(filetype)
        return SimpleSDMPredictor(filepath, "tiff"; bandnumber = bandnumber, boundingbox...)
    end

    return nothing
end

"""
    SimpleSDMLayers.SimpleSDMPredictor(data::R, future::F; kwargs...) where {R <: RasterData, F <: Projection}

Read a layer as a `SimpleSDMPredictor` (immutable) from a `RasterData`, a future `Projection`, and a source of keywords. The allowed keywors are listed for each `RasterData`.
"""
function SimpleSDMLayers.SimpleSDMPredictor(
    data::R,
    future::F;
    kwargs...,
) where {R <: RasterData, F <: Projection}
    # Split the bounding box from the rest of the data
    boundingbox, arguments = _boundingbox_out_of_kwargs(kwargs)

    # Get the data
    filepath, filetype, bandnumber, _ = downloader(data, future; arguments...)

    if isequal(SimpleSDMDatasets._tiff)(filetype)
        return SimpleSDMPredictor(filepath, "tiff"; bandnumber = bandnumber, boundingbox...)
    end

    return nothing
end

"""
    _boundingbox_out_of_kwargs(kwargs)

Takes the input to a function and split the bounding box from the actual arguments
"""
function _boundingbox_out_of_kwargs(kwargs)
    _bbox_keys = Symbol[]
    _bbox_vals = []
    _args_keys = Symbol[]
    _args_vals = []
    for k in keys(kwargs)
        if k in [:left, :right, :bottom, :top]
            push!(_bbox_keys, k)
            push!(_bbox_vals, kwargs[k])
        else
            push!(_args_keys, k)
            push!(_args_vals, kwargs[k])
        end
    end
    return NamedTuple{Tuple(_bbox_keys)}(_bbox_vals),
    NamedTuple{Tuple(_args_keys)}(_args_vals)
end
