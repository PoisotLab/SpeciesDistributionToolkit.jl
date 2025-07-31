"""
    bootstrap(y, X; n = 50)
"""
function bootstrap(y, X; n = 50)
    @assert size(y, 1) == size(X, 2)
    pos, neg = __classsplit(y)
    bags = Vector{Tuple{typeof(pos), typeof(pos)}}[]
    for _ in 1:n
        inbag_pos = unique(sample(pos, length(pos); replace=true))
        inbag_neg = unique(sample(neg, length(neg); replace=true))
        inbag = Random.shuffle!(vcat(inbag_pos, inbag_neg))
        outbag = setdiff(axes(y, 1), inbag)
        push!(bags, (inbag, outbag))
    end
    return bags
end

"""
    bootstrap(sdm::SDM; kwargs...)
"""
function bootstrap(sdm::SDM; kwargs...)
    return bootstrap(labels(sdm), features(sdm); kwargs...)
end

"""
    Bagging
"""
mutable struct Bagging <: AbstractEnsembleSDM
    model::SDM
    bags::Vector{Tuple{Vector{Int64}, Vector{Int64}}}
    models::Vector{SDM}
end

"""
    Bagging(model::SDM, bags::Vector)

blah
"""
function Bagging(model::SDM, bags::Vector)
    return Bagging(model, bags, [deepcopy(model) for _ in eachindex(bags)])
end

"""
    Bagging(model::SDM, n::Integer)

Creates a bag from SDM
"""
function Bagging(model::SDM, n::Integer)
    bags = bootstrap(labels(model), features(model); n = n)
    return Bagging(model, bags, [deepcopy(model) for _ in eachindex(bags)])
end

"""
    outofbag(ensemble::Bagging; kwargs...)

This method returns the confusion matrix associated to the out of bag error,
wherein the succes in predicting instance *i* is calculated on the basis of all
models that have not been trained on *i*. The consensus of the different models
is a simple majority rule.

The additional keywords arguments are passed to `predict`.
"""
function outofbag(ensemble::Bagging; kwargs...)
    done_instances = Int64[]
    outcomes = Bool[]

    for instance in eachindex(labels(ensemble.model))
        valid_models = findall(x -> !(instance in x[1]), ensemble.bags)
        if !isempty(valid_models)
            push!(done_instances, instance)
            pred = [
                predict(ensemble.models[i], ensemble.model.X[:, instance]; kwargs...)
                for
                i in valid_models
            ]
            push!(outcomes, majority(pred))
        end
    end

    return ConfusionMatrix(outcomes, ensemble.model.y[done_instances])
end

bagfeatures!(ensemble::Bagging) =
    bagfeatures!(ensemble, ceil(Int64, sqrt(length(variables(ensemble)))))

function bagfeatures!(ensemble::Bagging, n::Integer)
    for model in ensemble.models
        sampled_variables = StatsBase.sample(variables(model), n; replace = false)
        variables!(model, sampled_variables)
    end
    return ensemble
end

"""
    variables!(ensemble::Bagging, v::Vector{Int})

Sets the variable of the top-level model, and then sets the variables of each
model in the ensemble.
"""
function variables!(ensemble::Bagging, v::Vector{Int})
    variables!(ensemble.model, v)
    for model in models(ensemble)
        variables!(model, v)
    end
    return ensemble
end

@testitem "We can bag the features of an ensemble model" begin
    X, y = SDeMo.__demodata()
    model = SDM(MultivariateTransform{PCA}, DecisionTree, X, y)
    ensemble = Bagging(model, 10)
    bagfeatures!(ensemble)
    for model in ensemble.models
        @test length(variables(model)) == ceil(Int64, sqrt(size(X, 1)))
    end
end

majority(pred::Vector{Bool}) = sum(pred) > length(pred) // 2
majority(pred::BitVector) = sum(pred) > length(pred) // 2
export majority

"""
    classifier(model::Bagging)

Returns the classifier used by the model that is used as a template for the bagged model
"""
classifier(model::Bagging) = classifier(model.model)

"""
    transformer(model::Bagging)

Returns the transformer used by the model that is used as a template for the bagged model
"""
transformer(model::Bagging) = transformer(model.model)
