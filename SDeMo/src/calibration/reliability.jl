function _calibration_bins(x, y, bins)
    qs = LinRange(extrema(x)..., bins)

    X = zeros(bins - 1)
    Y = zeros(bins - 1)
    filled = zeros(Bool, bins - 1)

    for i in 1:(bins-1)
        in_chunk = findall(qs[i] .<= x .< qs[i+1])
        filled[i] = !isempty(in_chunk)
        X[i] = mean(x[in_chunk])
        Y[i] = mean(y[in_chunk])
    end

    return X[findall(filled)], Y[findall(filled)]
end

"""
    reliability(yhat, y; bins=9)

Returns a binned reliability curve for a series of predicted quantitative scores
and a series of truth values.
"""
function reliability(yhat::Vector{<:Real}, y::Vector{Bool}; bins=9)
    return _calibration_bins(yhat, y, bins)
end

"""
    reliability(sdm::AbstractSDM, link::Function=identity; bins=9, kwargs...)

Returns a binned reliability curve for a trained model, where the raw scores are
transformed with a specified `link` function (which defaults to `identity`).
Keyword arguments other than `bins` are passed to `predict`. 
"""
function reliability(sdm::AbstractSDM; link::Function=identity, bins=9, samples=:, kwargs...)
    ŷ = link.(predict(sdm; threshold=false, kwargs...))[samples]
    y = labels(sdm)[samples]
    return reliability(ŷ, y; bins=bins)
end