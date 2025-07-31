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
  - `absences`: defaults to `false`, and indicates whether the (pseudo) absences are used to train the transformer; when using actual absences, this should be set to `true`

Internally, this function trains the transformer, then projects the data, then
trains the classifier. If `threshold` is ` true`, the threshold is then
optimized.
"""
function train!(
    sdm::SDM;
    threshold = true,
    training = :,
    optimality = mcc,
    absences = false,
)
    # These are all the possible instances to train on
    data_axes = axes(features(sdm), 2)

    # For the transformer, we may only want to train the presence data
    transformer_training_idx = absences ? data_axes[training] : findall(labels(sdm)[training])
    
    # This trains the transformer
    train!(transformer(sdm), features(sdm)[variables(sdm), transformer_training_idx])

    # We can now use the transformer to project the input data
    X₁ = predict(transformer(sdm), features(sdm)[variables(sdm), training])

    # The validation data is whatever is available and not explicitely used for
    # training. This may be empty.
    validation = setdiff(data_axes, data_axes[training]) 

    # We can now get the predictions for the transformer using the validation data
    Xₜ = predict(transformer(sdm), features(sdm)[variables(sdm), validation])
    # And same with the labels
    yₜ = labels(sdm)[validation]

    # This is the final training step
    train!(classifier(sdm), labels(sdm)[training], X₁; Xt = Xₜ, yt = yₜ)

    # When the training is done, we can set the threshold
    if threshold
        # List of indices to compare - we use the validation if there are at
        # least 100, otherwise we use the training data
        idx = length(validation) < 100 ? training : validation
        ŷ = predict(sdm; threshold=false)[idx]
        ŷ[isnan.(ŷ)] .= zero(eltype(ŷ))
        
        # This is the ground truth for our thresholding data
        yₛ = labels(sdm)[idx]
        
        # We look at a range of 100 values
        thresholds = LinRange(extrema(ŷ)..., 150)

        best_threshold = minimum(thresholds)
        best = -Inf

        for i in eachindex(thresholds)
            score = optimality(ConfusionMatrix(ŷ, yₛ, thresholds[i]))
            if score > best
                best = score
                best_threshold = thresholds[i]
            end
        end

        threshold!(sdm, best_threshold)
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

@testitem "We can train a model without the absences" begin
    using Statistics
    X, y = SDeMo.__demodata()
    model = SDM(ZScore, NaiveBayes, X, y)
    train!(model)
    tf = transformer(model)
    pr_mean = vec(mean(features(model)[:, findall(labels(model))]; dims = 2))
    for i in eachindex(pr_mean)
        @test pr_mean[i] ≈ tf.μ[i]
    end
    cv = crossvalidate(model, kfold(model); absences = false)
end

@testitem "We can train a model with the absences" begin
    using Statistics
    X, y = SDeMo.__demodata()
    model = SDM(ZScore, NaiveBayes, X, y)
    train!(model; absences = true)
    tf = transformer(model)
    pr_mean = vec(mean(features(model)[:, findall(labels(model))]; dims = 2))
    for i in eachindex(pr_mean)
        @test pr_mean[i] != tf.μ[i]
    end
    cv = crossvalidate(model, kfold(model); absences = true)
end
