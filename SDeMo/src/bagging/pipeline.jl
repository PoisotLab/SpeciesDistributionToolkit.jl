function train!(ensemble::Bagging; kwargs...)
    Threads.@threads for m in eachindex(ensemble.models)
        train!(ensemble.models[m]; training = ensemble.bags[m][1], kwargs...)
    end
    train!(ensemble.model; kwargs...)
    return ensemble
end

function StatsAPI.predict(ensemble::Bagging, X; consensus = median, kwargs...)
    ŷ = [predict(component, X; kwargs...) for component in ensemble.models]
    ỹ = vec(mapslices(consensus, hcat(ŷ...); dims = 2))
    return isone(length(ỹ)) ? only(ỹ) : ỹ
end

function StatsAPI.predict(ensemble::Bagging; kwargs...)
    return StatsAPI.predict(ensemble, ensemble.model.X; kwargs...)
end