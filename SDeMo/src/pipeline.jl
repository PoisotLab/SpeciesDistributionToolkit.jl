"""
    train!(sdm::SDM; threshold=true, training=:, optimality=mcc)

This is the main training function to train a SDM.

The three keyword arguments are:

  - `training`: defaults to `:`, and is the range (or alternatively the indices)
    of the data that are used to train the model
  - `threshold`: defaults to `true`, and performs moving threshold by evaluating
    200 possible values between the minimum and maximum output of the model, and
    returning the one that is optimal
  - `optimality`: defaults to `mcc`, and is the function applied to the
    confusion matrix to evaluate which value of the threshold is the best

Internally, this function trains the transformer, then projects the data, then
trains the classifier. If `threshold` is ` true`, the threshold is then
optimized.
"""
function train!(sdm::SDM; threshold = true, training = :, optimality = mcc)
    train!(sdm.transformer, sdm.X[sdm.v, training])
    X₁ = predict(sdm.transformer, sdm.X[sdm.v, training])
    train!(sdm.classifier, sdm.y[training], X₁)
    ŷ = predict(sdm.classifier, X₁)
    ŷ[findall(isnan.(ŷ))] .= 0.0
    if threshold
        thr_range = LinRange(extrema(ŷ)..., 200)
        C = [ConfusionMatrix(ŷ, sdm.y[training], thr) for thr in thr_range]
        sdm.τ = thr_range[last(findmax(optimality, C))]
    end
    return sdm
end

"""
    StatsAPI.predict(sdm::SDM, X; threshold = true)

This is the main prediction function, and it takes as input an SDM and a matrix
of features. The only keyword argument is `threshold`, which determines whether
the prediction is returned raw or as a binary value (default is `true`).
"""
function StatsAPI.predict(sdm::SDM, X::Matrix{T}; threshold = true) where {T <: Number}
    X₁ = predict(sdm.transformer, X[sdm.v, :])
    ŷ = predict(sdm.classifier, X₁)
    ŷ = isone(length(ŷ)) ? ŷ[1] : ŷ
    if length(ŷ) > 1
        ŷ[findall(isnan.(ŷ))] .= 0.0
    else
        ŷ = isnan(ŷ) ? 0.0 : ŷ
    end
    if threshold
        return ŷ .>= sdm.τ
    else
        return ŷ
    end
end

function StatsAPI.predict(
    sdm::S,
    v::Vector{T},
    args...;
    kwargs...,
) where {S <: AbstractSDM, T <: Number}
    X = reshape(v, length(v), 1)
    return predict(sdm, X, args...; kwargs...)
end

"""
    StatsAPI.predict(sdm::SDM; kwargs...)

This method performs the prediction on the entire set of training data available
for the training of an SDM.
"""
function StatsAPI.predict(sdm::SDM; kwargs...)
    return StatsAPI.predict(sdm, features(sdm); kwargs...)
end

"""
    reset!(sdm::SDM, thr=0.5)

Resets a model, with a potentially specified value of the threshold. This
amounts to re-using all the variables, and removing the tuned threshold version.
"""
function reset!(sdm::SDM, thr = 0.5)
    sdm.v = collect(axes(sdm.X, 1))
    sdm.τ = thr
    return sdm
end
