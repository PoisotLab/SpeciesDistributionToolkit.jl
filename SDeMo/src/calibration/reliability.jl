function _calibration_bins(x, y, bins)
    qs = LinRange(extrema(x)..., bins)

    X = zeros(bins - 1)
    Y = zeros(bins - 1)

    for i in 1:(bins-1)
        in_chunk = findall(qs[i] .<= x .< qs[i+1])
        X[i] = mean(x[in_chunk])
        Y[i] = mean(y[in_chunk])
    end
    return X, Y
end

"""
    reliability(yhat, y; bins=9)

Returns a binned reliability curve for a series of predicted quantitative scores
and a series of truth values.
"""
function reliability(yhat::Vector{<:Real}, y::Vector{Bool}; bins=9)
    cutoffs = LinRange(minimum(yhat), maximum(yhat)+eps(), bins)
    avgpred = zeros(bins-1)
    avgactu = zeros(bins-1)
    for i in eachindex(avgpred)
        inbin = findall(x -> cutoffs[i] < x <= cutoffs[i+1], yhat)
        avgpred[i] = mean(yhat[inbin])
        avgactu[i] = mean(y[inbin])
    end
    return (avgpred, avgactu)
end

"""
    reliability(sdm::AbstractSDM, link::Function=identity; bins=9, kwargs...)

Returns a binned reliability curve for a trained model, where the raw scores are
transformed with a specified `link` function (which defaults to `identity`).
Keyword arguments other than `bins` are passed to `predict`. 
"""
function reliability(sdm::AbstractSDM; link::Function=identity, bins=9, kwargs...)
    ŷ = link.(predict(sdm; threshold=false, kwargs...))
    y = labels(sdm)
    return reliability(ŷ, y; bins=bins)
end