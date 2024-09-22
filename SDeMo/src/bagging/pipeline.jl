"""
    train!(ensemble::Bagging; kwargs...)

Trains all the model in an ensemble model - the keyword arguments are passed to
`train!` for each model. Note that this retrains the *entire* model, which
includes the transformers.
"""
function train!(ensemble::Bagging; kwargs...)
    Threads.@threads for m in eachindex(ensemble.models)
        train!(ensemble.models[m]; training = ensemble.bags[m][1], kwargs...)
    end
    train!(ensemble.model; kwargs...)
    return ensemble
end

"""
    StatsAPI.predict(ensemble::Bagging, X; consensus = median, kwargs...)

Returns the prediction for the ensemble of models a dataset `X`. The function
used to aggregate the outputs from different models is `consensus` (defaults to
`median`). All other keyword arguments are passed to `predict`.
"""
function StatsAPI.predict(ensemble::Bagging, X; consensus = median, kwargs...)
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