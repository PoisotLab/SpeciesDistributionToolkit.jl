"""
    AdaBoost <: AbstractBoostedSDM

A type for `AdaBoost` that contains the `model`, a vector of `learners`, a
vector of learner `weights`, a number of boosting `iterations`, and the weights
`w` of each point.

Note that this type uses training by re-sampling data according to their
weights, as opposed to re-training on all samples and weighting internally. Some
learners _may_ have negative weights, in which case their predictions are
flipped at prediction time.

The learning rate `η` defaults to one, but can be lowered to improve stability /
prevent over-fitting. The learning rate _must_ be larger than 0, and decreasing
it should lead to a larger number of iterations.
"""
mutable struct AdaBoost <: AbstractBoostedSDM
    model::SDM
    learners::Vector{<:SDM}
    weights::Vector{<:AbstractFloat} # Model weights
    iterations::Integer # Number of iterations
    w::Vector{<:AbstractFloat} # Data weights
    η::Real
end

function AdaBoost(model::SDM; iterations = 50)
    return AdaBoost(
        deepcopy(model),
        [deepcopy(model) for _ in Base.OneTo(iterations)],
        zeros(iterations),
        iterations,
        fill(1 / length(labels(model)), length(labels(model))),
        1.0
    )
end

AdaBoost(model::SDM, n::Integer) = AdaBoost(model; iterations = n)

# Access to the top-level model in AdaBoost
models(b::AdaBoost) = b.learners

# These three will probably be abstracted at some point
labels(b::AdaBoost) = labels(b.model)
features(b::AdaBoost) = features(b.model)
features(b::AdaBoost, i...) = features(b.model, i...)
variables(b::AdaBoost) = variables(b.model)
threshold(b::AdaBoost) = 0.5

# Hyper parameters
hyperparameters(::Type{AdaBoost}) = (:η, )

@testitem "We can change the hyper-parameters of an AdaBoost classifier" begin
    X, y = SDeMo.__demodata()
    stump = SDM(RawData, DecisionTree, X, y)
    hyperparameters!(classifier(stump), :maxnodes, 2)
    hyperparameters!(classifier(stump), :maxdepth, 1)
    model = AdaBoost(stump, 50)
    @test hyperparameters(model, :η) == 1.0
    hyperparameters!(model, :η, 0.2)
    @test hyperparameters(model, :η) == 0.2
end


# Turn a [0,1] prediction into a [-1,1] prediction
__y_spread(x) = float.(2x .- 1.0)

# Turn a [-1,1] pred into [0,1]
__y_gather(x) = float.(0.5 .* (x .+ 1.0))

"""
    train!(b::AdaBoost; kwargs...)

Trains all the model in an ensemble model - the keyword arguments are passed to
`train!` for each model. Note that this also retrains the *original* model. If
the original model contains transformers, they are re-trained for each learner
that is added to the ensemble. This is crucial as learners are re-trained on
proportionally weighted samples of the training data, and not re-training the
transformers would create data leakage.
"""
function train!(b::AdaBoost; kwargs...)
    # We start by training the initial model
    train!(b.model; kwargs...)

    # The threshold is handled a little differently for boosted models
    trainargs = filter(kw -> kw.first != :training, kwargs)
    
    for iteration in Base.OneTo(b.iterations)

        # We have pre-allocated the models so we can just refer to it here
        learner = models(b)[iteration]

        # We get the samples that will be used for training at this iteration
        training_samples = sample(
                axes(labels(learner), 1),
                Weights(b.w),
                length(labels(learner));
                replace = true,
            )
        
        # We re-train the model for this iteration
        train!(learner; training = training_samples, trainargs...)

        # We get the prediction and outcomes for the model based on this training round
        y = __y_spread(labels(learner)) # Target
        yhat = __y_spread(predict(learner))

        # We need to know which samples were not correctly predicted
        m = findall(y .!= yhat) # Index of missed classifications

        # Weighted error
        ε = sum(b.w[m]) # Sum of weights for missed samples - this essentially measures accuracy

        # We now calculate the relative weight of this learner in the ensemble
        # so far - note that the learning rate is applied here, for the first
        # learner as well!
        α = b.η * 0.5 * log((1 - (ε + eps())) / (ε + eps()))

        # The classifier is already in the ensemble, so we update its weight (it
        # has been trained earlier!)
        b.weights[iteration] = α

        # Now we update the weights of the model
        margin = y .* yhat # Correct prediction x score gives us the margin of error

        # And we update the data weights according to how big the error is
        b.w .*= exp.(-α .* margin)
        b.w ./= sum(b.w)
    end

    return b
end

"""
    predict(::AdaBoost, ::Matrix{T}; kwargs...)

Predicts with a trained AdaBoost model.
"""
function StatsAPI.predict(
    b::AdaBoost,
    X::Matrix{T};
    kwargs...,
) where {T <: Number}

    # We don't use the threshold as part of each tree here
    predictargs = filter(kw -> kw.first != :threshold, kwargs)

    # We do use the threshold to return the boosted prediction, so we will
    # extract it from the keywords if given, and other wise set it to true
    # (binary prediction)
    threshold_argument = filter(kw -> kw.first == :threshold, kwargs)
    threshold = isempty(threshold_argument) ? true : threshold_argument[:threshold]

    # Start with an initial prediction of 0.0 in the -1, 1 space
    y = fill(0.0, size(X, 2))

    # We get the total sum of the weights in the boosted model
    w = sum(abs.(b.weights))

    for i in Base.OneTo(b.iterations)

        # We get the classification from the ith learner
        y_learner = predict(models(b)[i], X; threshold = true, predictargs...)

        # And we multiply it by the weight, again in the -1, 1 space
        y .+= __y_spread(y_learner) .* b.weights[i]
    end

    # And prepare the final prediction
    ỹ = __y_gather(y ./ w)

    if threshold
        ỹ = ỹ .>= 0.5
    end

    return isone(length(ỹ)) ? only(ỹ) : ỹ
end

"""
    TODO
"""
function StatsAPI.predict(b::AdaBoost; kwargs...)
    return StatsAPI.predict(b, features(b); kwargs...)
end