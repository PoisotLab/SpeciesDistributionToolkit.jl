features(model::Bagging) = features(model.model)
features(model::Ensemble) = features(first(model.models))
features(model::Bagging, n) = features(model.model, n)
features(model::Ensemble, n) = features(first(model.models), n)
variables(model::Bagging) = variables(model.model)
labels(model::Bagging) = labels(model.model)
labels(model::Ensemble) = labels(first(model.models))
models(ensemble::Bagging) = ensemble.models
models(ensemble::Ensemble) = ensemble.models
threshold(model::Bagging) = 0.5
threshold(model::Ensemble) = 0.5
instance(model::Bagging, args...; kwargs...) = instance(model.model, args...; kwargs...)

"""
    train!(ensemble::Bagging; kwargs...)

Trains all the model in an ensemble model - the keyword arguments are passed to
`train!` for each model. Note that this retrains the *entire* model, which
includes the transformers.
"""
function train!(ensemble::Bagging; kwargs...)
    # The ensemble model can be given a consensus argument, in which can we drop it for
    # training as it's relevant for prediction only
    trainargs = filter(kw -> kw.first != :consensus, kwargs)
    Threads.@threads for m in eachindex(ensemble.models)
        train!(ensemble.models[m]; training = ensemble.bags[m][1], trainargs...)
    end
    train!(ensemble.model; trainargs...)
    return ensemble
end

"""
    StatsAPI.predict(ensemble::Bagging, X; consensus = median, kwargs...)

Returns the prediction for the ensemble of models a dataset `X`. The function
used to aggregate the outputs from different models is `consensus` (defaults to
`median`). All other keyword arguments are passed to `predict`.

To get a direct estimate of the variability, the `consensus` function can be
changed to `iqr` (inter-quantile range), or any measure of variance.
"""
function StatsAPI.predict(
    ensemble::Bagging,
    X::Matrix{T};
    consensus = median,
    kwargs...,
) where {T <: Number}
    ŷ = [predict(component, X; kwargs...) for component in ensemble.models]
    ỹ = vec(mapslices(consensus, hcat(ŷ...); dims = 2))
    return isone(length(ỹ)) ? only(ỹ) : ỹ
end

"""
    StatsAPI.predict(ensemble::Bagging; kwargs...)

Predicts the ensemble model for all training data.
"""
function StatsAPI.predict(ensemble::Bagging; kwargs...)
    return StatsAPI.predict(ensemble, ensemble.model.X; kwargs...)
end

"""
    train!(ensemble::Ensemble; kwargs...)

Trains all the model in an heterogeneous ensemble model - the keyword arguments
are passed to `train!` for each model. Note that this retrains the *entire*
model, which includes the transformers.

The keywod arguments are passed to `train!` and can include the `training`
indices.
"""
function train!(ensemble::Ensemble; kwargs...)
    Threads.@threads for m in eachindex(ensemble.models)
        train!(ensemble.models[m]; kwargs...)
    end
    return ensemble
end

"""
    StatsAPI.predict(ensemble::Ensemble, X; consensus = median, kwargs...)

Returns the prediction for the heterogeneous ensemble of models a dataset `X`.
The function used to aggregate the outputs from different models is `consensus`
(defaults to `median`). All other keyword arguments are passed to `predict`.

To get a direct estimate of the variability, the `consensus` function can be
changed to `iqr` (inter-quantile range), or any measure of variance.
"""
function StatsAPI.predict(
    ensemble::Ensemble,
    X::Matrix{T};
    consensus = median,
    kwargs...,
) where {T <: Number}
    ŷ = [predict(component, X; kwargs...) for component in ensemble.models]
    ỹ = vec(mapslices(consensus, hcat(ŷ...); dims = 2))
    return isone(length(ỹ)) ? only(ỹ) : ỹ
end

"""
    StatsAPI.predict(ensemble::Ensemble; kwargs...)

Predicts the heterogeneous ensemble model for all training data.
"""
function StatsAPI.predict(ensemble::Ensemble; kwargs...)
    return StatsAPI.predict(ensemble, features(first(ensemble.models)); kwargs...)
end
