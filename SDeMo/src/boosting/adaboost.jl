"""
    AdaBoost <: AbstractBoostedSDM

A type for `AdaBoost` that contains the `model`, a vector of `learners`, a
vector of learner `weights`, a number of boosting `iterations`, and the weights
`w` of each point.

Note that this type uses training by re-sampling data according to their
weights, as opposed to re-training on all samples and weighting internally.
"""
mutable struct AdaBoost <: AbstractBoostedSDM
    model::SDM
    learners::Vector{<:SDM}
    weights::Vector{<:AbstractFloat} # Model weights
    iterations::Integer # Number of iterations
    w::Vector{<:AbstractFloat} # Data weights
end

function AdaBoost(model::SDM; iterations = 50)
    return AdaBoost(
        deepcopy(model),
        fill(deepcopy(model), iterations),
        zeros(iterations),
        iterations,
        fill(1 / length(labels(model)), length(labels(model))),
    )
end

# Access to the top-level model in AdaBoost
models(b::AdaBoost) = b.learners

# These three will probably be abstracted at some point
labels(b::AdaBoost) = labels(b.model)
features(b::AdaBoost) = features(b.model)
variables(b::AdaBoost) = variables(b.model)
threshold(b::AdaBoost) = 0.5

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
    trainargs = filter(kw -> (kw.first != :threshold) & (kw.first != :training), kwargs)

    for iteration in Base.OneTo(b.iterations)

        # We have pre-allocated the models so we can just refer to it here
        learner = models(b)[iteration]

        # We get the samples that will be used for training at this iteration
        training_samples = sort(
            sample(
                axes(labels(learner), 1),
                Weights(b.w),
                length(labels(learner));
                replace = true,
            ),
        )
        #if iteration == 1
        #    training_samples = eachindex(labels(learner))
        #end

        # We re-train the model for this iteration
        train!(learner; training = training_samples, threshold = true, trainargs...)

        # We get the prediction and outcomes for the model based on this training round
        y = __y_spread(labels(learner)) # Target
        raw_scores = predict(learner)
        #s = __y_spread(raw_scores) # Score (used to update the weight proportionally to the error)
        p = __y_spread(raw_scores .>= threshold(learner)) # Classification (used to decide which weight should be updated)

        # We need to know which samples were not correctly predicted
        m = findall(y .!= p) # Index of missed classifications

        # Weighted error
        ε = sum(b.w[m]) # Sum of weights for missed samples

        # We now calculate the relative weight of this learner in the ensemble so far
        α = 0.5 * log((1 - ε) / ε)

        # The classifier is already in the ensemble, so we update its weight (it
        # has been trained earlier!)
        b.weights[iteration] = α

        # Now we update the weights of the model
        s = __y_spread(raw_scores .- threshold(learner))
        margin = y .* s # Correct prediction time score returned

        # And we update the data weights according to how big the error is
        b.w .*= exp.(-margin .* α)
        b.w ./= sum(b.w)
    end

    return b
end


"""
    TODO
"""
function StatsAPI.predict(
    b::AdaBoost,
    X::Matrix{T};
    kwargs...
) where {T <: Number}
    # We handle the threshold separately here
    y = fill(0.0, size(X, 2)) # Initial prediction is 0
    for i in Base.OneTo(b.iterations)
        y_learner = predict(models(b)[i], X; threshold=false)
        y .+= (__y_spread(y_learner) .* b.weights[i])
    end
    ỹ = __y_gather(y ./ (sum(b.weights)))
    return isone(length(ỹ)) ? only(ỹ) : ỹ
end

"""
    TODO
"""
function StatsAPI.predict(b::AdaBoost; kwargs...)
    return StatsAPI.predict(b, features(b); kwargs...)
end
