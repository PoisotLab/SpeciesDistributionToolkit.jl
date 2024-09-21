"""
    ConfusionMatrix{T <: Number}

A structure to store the true positives, true negatives, false positives, and
false negatives counts (or proportion) during model evaluation. Empty confusion
matrices can be created using the `zero` method.
"""
struct ConfusionMatrix{T <: Number}
    tp::T
    tn::T
    fp::T
    fn::T
end

"""
    ConfusionMatrix(pred::Vector{Bool}, truth::Vector{Bool})

Given a vector of binary predictions and a vector of ground truths, returns the
confusion matrix.
"""
function ConfusionMatrix(pred::Vector{Bool}, truth::Vector{Bool})
    @assert length(pred) == length(truth)
    tp = sum(pred .& truth)
    tn = sum(.!pred .& .!truth)
    fp = sum(pred .& .!truth)
    fn = sum(.!pred .& truth)
    return ConfusionMatrix(tp, tn, fp, fn)
end

"""
    ConfusionMatrix(pred::Vector{T}, truth::Vector{Bool}, τ::T) where {T <: Number}

Given a vector of scores and a vector of ground truths, as well as a threshold,
transforms the score into binary predictions and returns the confusion matrix.
"""
function ConfusionMatrix(pred::Vector{T}, truth::Vector{Bool}, τ::T) where {T <: Number}
    return ConfusionMatrix(convert(Vector{Bool}, pred .>= τ), truth)
end

"""
    ConfusionMatrix(pred::Vector{T}, truth::Vector{Bool}) where {T <: Number}

Given a vector of scores and a vector of truth, returns the confusion matrix
under the assumption that the score are probabilities and that the threshold is
one half.
"""
function ConfusionMatrix(pred::Vector{T}, truth::Vector{Bool}) where {T <: Number}
    return ConfusionMatrix(pred, truth, 0.5)
end

function ConfusionMatrix(pred::BitVector, args...)
    return ConfusionMatrix(convert(Vector{Bool}, pred), args...)
end

function ConfusionMatrix(pred::BitVector, truth::BitVector, args...)
    return ConfusionMatrix(
        convert(Vector{Bool}, pred),
        convert(Vector{Bool}, truth),
        args...,
    )
end

"""
    ConfusionMatrix(sdm::SDM; kwargs...)

Performs the predictions for an SDM, and compare to the labels used for
training. The keyword arguments are passed to the `predict` method. 
"""
function ConfusionMatrix(sdm::SDM; kwargs...)
    ŷ = predict(sdm; kwargs...)
    return ConfusionMatrix(ŷ, labels(sdm))
end

"""
    ConfusionMatrix(sdm::SDM; kwargs...)

Performs the predictions for an SDM, and compare to the labels used for
training. The keyword arguments are passed to the `predict` method. 
"""
function ConfusionMatrix(ensemble::Bagging; kwargs...)
    return [ConfusionMatrix(m; kwargs...) for m in ensemble.models]
end

Base.Matrix(c::ConfusionMatrix) = [c.tp c.fp; c.fn c.tn]
Base.zero(ConfusionMatrix) = ConfusionMatrix(0, 0, 0, 0)
