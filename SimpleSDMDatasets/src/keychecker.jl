"""
    SimpleSDMDatasets.keychecker(data::R; kwargs...) where {R <: RasterData}

Checks that the keyword arguments passed to a downloader are correct, *i.e.* the
data provider / source being retrieved supports them.
"""
function keychecker(data::R; kwargs...) where {R <: RasterData}

    # Check for month
    if :month in keys(kwargs)
        if isnothing(months(data))
            error("The $(R) dataset does not allow for month as a keyword argument")
        end
        if ~(values(kwargs).month in months(data))
            error("The month $(values(kwargs).month) is not supported by the $(R) dataset")
        end
    end

    # Check for layer
    if :layer in keys(kwargs)
        if isnothing(layers(data))
            error("The $(R) dataset does not allow for layer as a keyword argument")
        end
        if values(kwargs).layer isa Integer
            if ~(1 <= values(kwargs).layer <= length(layers(data)))
                error("The $(R) dataset only has $(length(layers(data))) layers")
            end
        elseif ~(values(kwargs).layer in layers(data))
            error("The layer $(values(kwargs).layer) is not supported by the $(R) dataset")
        end
    end

    # Check for resolution
    if :resolution in keys(kwargs)
        if isnothing(resolutions(data))
            error("The $(R) dataset does not support multiple resolutions")
        end
        if ~(values(kwargs).resolution in keys(resolutions(data)))
            error(
                "The resolution $(values(kwargs).resolution) is not supported by the $(R) dataset",
            )
        end
    end

    # Check for allowed extra keys
    for k in keys(kwargs)
        if ~(k in [:month, :layer, :resolution])
            if isnothing(extrakeys(data))
                error("The keyword argument $(k) is not supported by the $(R) dataset")
            end
            if k in keys(extrakeys(data))
                if ~(values(kwargs)[k] in first.(extrakeys(data)[k]))
                    error(
                        "The value $(values(kwargs)[k]) is not supported for the keyword argument $(k) to $(R)",
                    )
                end
            end
        end
    end

    return nothing
end

function keychecker(data::R, future::F; kwargs...) where {R <: RasterData, F <: Projection}
    @assert SimpleSDMDatasets.provides(data, future)

    # Check for month
    if :month in keys(kwargs)
        if isnothing(months(data, future))
            error(
                "The $(R) dataset does not allow for month as a keyword argument under $(F)",
            )
        end
        if ~(values(kwargs).month in months(data))
            error(
                "The month $(values(kwargs).month) is not supported by the $(R) dataset under $(F)",
            )
        end
    end

    # Check for timespan
    if :timespan in keys(kwargs)
        if isnothing(timespans(data, future))
            error(
                "The $(R) dataset does not allow for timespan as a keyword argument under $(F)",
            )
        end
        if ~(values(kwargs).timespan in timespans(data, future))
            error(
                "The timespan $(values(kwargs).month) is not supported by the $(R) dataset under $(F)",
            )
        end
    end

    # Check for layer
    if :layer in keys(kwargs)
        if isnothing(layers(data))
            error(
                "The $(R) dataset does not allow for layer as a keyword argument under $(F)",
            )
        end
        if values(kwargs).layer isa Integer
            if ~(1 <= values(kwargs).layer <= length(layers(data)))
                error("The $(R) dataset only has $(length(layers(data))) layers under $(F)")
            end
        elseif ~(values(kwargs).layer in layers(data))
            error(
                "The layer $(values(kwargs).layer) is not supported by the $(R) dataset under $(F)",
            )
        end
    end

    # Check for resolution
    if :resolution in keys(kwargs)
        if isnothing(resolutions(data))
            error("The $(R) dataset does not support multiple resolutions under $(F)")
        end
        if ~(values(kwargs).resolution in keys(resolutions(data)))
            error(
                "The resolution $(values(kwargs).resolution) is not supported by the $(R) dataset under $(F)",
            )
        end
    end

    # Check for allowed extra keys
    for k in keys(kwargs)
        if ~(k in [:month, :layer, :resolution, :timespan])
            if isnothing(extrakeys(data))
                error("The keyword argument $(k) is not supported by the $(R) dataset")
            end
            if k in keys(extrakeys(data))
                if ~(values(kwargs)[k] in first.(extrakeys(data)[k]))
                    error(
                        "The value $(values(kwargs)[k]) is not supported for the keyword argument $(k) to $(R) under $(F)",
                    )
                end
            end
        end
    end

    return nothing
end
