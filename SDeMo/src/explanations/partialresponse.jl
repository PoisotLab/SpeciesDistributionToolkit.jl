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
    partialresponse(sdm::SDM, i::Integer, args...; kwargs...)

This method returns the partial response of applying the trained model to a
simulated dataset where all variables *except* `i` are set to their mean
value. The different arguments that can follow the variable position are

- nothing, where the unique values for the `i`-th variable are used (sorted)
- a number, in which point that many evenly spaced points within the range of the variable are used
- an array, in which case each value of this array is evaluated

All keyword arguments are passed to `predict`.
"""
function partialresponse(sdm::SDM, i::Integer, args...; kwargs...)
    nx = SDeMo._make_partialresponse_data(sdm, i, args...)
    SDeMo._fill_partialresponse_data!(nx, sdm, i)
    return (nx[i,:], predict(sdm, nx; kwargs...))
end


"""
    partialresponse(sdm::SDM, i::Integer, j::Integer, s::Tuple=(50, 50); kwargs...)

This method returns the partial response of applying the trained model to a
simulated dataset where all variables *except* `i` and `j` are set to their mean
value.

This function will return a grid corresponding to evenly spaced values of `i`
and `j`, the size of which is given by the last argument `s` (defaults to 50 ×
50).

All keyword arguments are passed to `predict`.
"""
function partialresponse(sdm::SDM, i::Integer, j::Integer, s::Tuple=(50, 50); kwargs...)
    irange = LinRange(extrema(features(sdm, i))..., s[1])
    jrange = LinRange(extrema(features(sdm, j))..., s[2])

    nx = zeros(eltype(features(sdm)), size(features(sdm), 1), length(irange)*length(jrange))

    nx[i,:] .= repeat(irange, outer=length(jrange))
    nx[j,:] .= repeat(jrange, inner=length(irange))

    for v in axes(nx, 1)
        if (v != i)&(v != j)
            nx[v,:] .= mean(features(sdm, v))
        end
    end

    return (irange, jrange, reshape(predict(sdm, nx; kwargs...), s))
end