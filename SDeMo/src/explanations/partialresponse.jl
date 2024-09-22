function _make_partialresponse_data(sdm::SDM, variable::Integer, npoints::Integer)
    target = LinRange(extrema(features(sdm, variable))..., npoints)
    nx = zeros(eltype(features(sdm)), size(features(sdm), 1), length(target))
    nx[variable, :] .= target
    return nx
end

function _make_partialresponse_data(sdm::SDM, variable::Integer)
    target = sort(unique(features(sdm, variable)))
    nx = zeros(eltype(features(sdm)), size(features(sdm), 1), length(target))
    nx[variable, :] .= target
    return nx
end

function _make_partialresponse_data(sdm::SDM, variable::Integer, values)
    nx = zeros(eltype(features(sdm)), size(features(sdm), 1), length(values))
    nx[variable, :] .= collect(values)
    return nx
end

function _fill_partialresponse_data!(nx, sdm::SDM, variable)
    for i in axes(nx, 1)
        if i != variable
            nx[i, :] .= mean(features(sdm, i))
        end
    end
    return nx
end

"""
    partialresponse(sdm::SDM, i, args...; kwargs...)

This method returns the partial response of applying the trained model to a
simulated dataset where all variables *except* `variable` are set to their mean
value. The different arguments that can follow the variable position are

- nothing, where the unique values for the `i`-th variable are used (sorted)
- a number, in which point that many evenly spaced points within the range of the variable are used
- an array, in which case each value of this array is evaluated

All keyword arguments are passed to `predict`.
"""
function partialresponse(sdm::SDM, i, args...; kwargs...)
    nx = SDeMo._make_partialresponse_data(sdm, i, args...)
    SDeMo._fill_partialresponse_data!(nx, sdm, i)
    return (nx[i,:], predict(sdm, nx; kwargs...))
end
