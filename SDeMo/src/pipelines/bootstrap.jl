function bootstrap(y, X; n = 50)
    @assert size(y, 1) == size(X, 2)
    bags = []
    for _ in 1:n
        inbag = sample(1:size(X, 2), size(X, 2); replace = true)
        outbag = setdiff(axes(X, 2), inbag)
        push!(bags, (inbag, outbag))
    end
    return bags
end

mutable struct Bagging
    model::SDM
    bags::Vector{Tuple{Vector{Int64}, Vector{Int64}}}
    models::Vector{SDM}
end

function Bagging(model::SDM, bags::Vector)
    return Bagging(model, bags, [deepcopy(model) for _ in eachindex(bags)])
end

function train!(ensemble::Bagging; kwargs...)
    Threads.@threads for m in eachindex(ensemble.models)
        train!(ensemble.models[m]; training=ensemble.bags[m][1], kwargs...)
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

function outofbag(ensemble::Bagging; kwargs...)
    instance = rand(eachindex(y))
    done_instances = Int64[]
    outcomes = Bool[]

    for instance in eachindex(y)
        valid_models = findall(x -> !(instance in x[1]), ensemble.bags)
        if !isempty(valid_models)
            push!(done_instances, instance)
            pred = [
                predict(ensemble.models[i], ensemble.model.X[:, instance]; kwargs...) for
                i in valid_models
            ]
            push!(outcomes, count(pred) > count(pred) // 2)
        end
    end

    return ConfusionMatrix(outcomes, ensemble.model.y[done_instances])
end