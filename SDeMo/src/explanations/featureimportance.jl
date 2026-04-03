struct PermutationImportance end

"""
    featureimportance(PermutationImportance, model, variable; kwargs...)

Returns the feature importance of a `variable` for a `model` over the entire
model training data. Note that to avoid overfitting, it is better to use a
different testing set to evaluate the importance of features.
"""
function featureimportance(
    ::Type{PermutationImportance},
    model::T,
    variable::Integer;
    kwargs...,
) where {T <: AbstractSDM}
    return featureimportance(
        PermutationImportance,
        model,
        variable,
        features(model),
        labels(model);
        kwargs...,
    )
end

"""
    featureimportance(PermutationImportance, model, variable, X, y; kwargs...)

Returns the feature importance of a `variable` for a `model` by predicting over
features `X` with a ground truth vector `y` .

The `samples` keyword (defaults to 50) is the number of samples to use to
evaluate the average importance.

When the `ratio` keyword is `true`, the importance is evaluated as the permuted
performance divided by the original performance (values lower than 1 indicate
that the variable is increasingly important). When it is `false`, the
performance is measured as a difference (values above 0 indicate that the
variable is increasingly important).

The `optimality` keyword takes a function (defaults to `mcc`) that operates on a
a vector of predictions and a vector of correct labels. The interpretation of
feature importance assumes that higher values of this measure correspond to a
better model.

The other `kwargs...` are passed to `predict`. For example, `threshold=false, optimality=crossentropyloss` is the way to measure the importance of variables
based on their effect on cross-entropy loss.
"""
function featureimportance(
    ::Type{PermutationImportance},
    model::T,
    variable::Integer,
    X::Matrix,
    y::Vector{Bool};
    samples = 50,
    ratio::Bool = true,
    optimality = mcc,
    kwargs...,
) where {T <: AbstractSDM}
    O₀ = optimality(predict(model, X; kwargs...), y)
    Oᵢ = zeros(Float64, samples)
    for i in Base.OneTo(samples)
        Xₚ = copy(X)
        Xₚ[variable, :] .= Random.shuffle!(Xₚ[variable, :])
        yₚ = predict(model, Xₚ; kwargs...)
        Oᵢ[i] = optimality(yₚ, y)
    end
    O = sum(Oᵢ) / samples
    return ratio ? O / O₀ : O - O₀
end

"""
    featureimportance(PartialDependence, model, variable; kwargs...)

Measures the feature importance of a `variable` by measuring the distance of all
points in the partial dependence curve to all other points in the curve, and
then averaging it. Low values indicates a flat PDP (feature is less important).
This method can be applied on a fully trained model as it focuses on the
_response_, not the individual predictions.
"""
function featureimportance(
    ::Type{PartialDependence},
    model::T,
    variable;
    kwargs...,
) where {T <: AbstractSDM}
    x, y = explainmodel(PartialDependence, model, variable; kwargs...)
    K = length(y)
    I = sqrt(1 / (K - 1) * sum((y .- sum(y) / K) .^ 2.0))
    return I
end

@testitem "We can measure feature importance for the entire model" begin
    model = SDM(RawData, NaiveBayes, SDeMo.__demodata()...)
    variables!(model, [1, 12])
    train!(model)

    for t in [true, false]
        @test featureimportance(
            PermutationImportance,
            model,
            2;
            threshold = t,
            ratio = true,
        ) ≈ 1.0
        @test featureimportance(
            PermutationImportance,
            model,
            2;
            threshold = t,
            ratio = false,
        ) ≈ 0.0
        @test featureimportance(
            PermutationImportance,
            model,
            1;
            threshold = t,
            ratio = true,
        ) != 1.0
        @test featureimportance(
            PermutationImportance,
            model,
            1;
            threshold = t,
            ratio = true,
        ) != 0.0

        @test featureimportance(PartialDependence, model, 2; threshold = t) < 10eps()
        @test featureimportance(PartialDependence, model, 8; threshold = t) < 10eps()
        @test featureimportance(PartialDependence, model, 1; threshold = t) > 0.0
        @test featureimportance(PartialDependence, model, 12; threshold = t) > 0.0
    end
end

@testitem "We can measure permutation feature importance for a subset of the entire model" begin
    model = SDM(RawData, NaiveBayes, SDeMo.__demodata()...)
    folds = holdout(model)

    variables!(model, [1, 12])
    X, y = features(model)[:, folds[2]], labels(model)[folds[2]]

    train!(model; training = folds[1])

    @test featureimportance(
        PermutationImportance,
        model,
        2,
        X,
        y;
        threshold = true,
        ratio = true,
        optimality = accuracy,
    ) == 1.0
    @test featureimportance(
        PermutationImportance,
        model,
        12,
        X,
        y;
        threshold = true,
        ratio = true,
        optimality = accuracy,
    ) != 1.0
end

"""
    featureimportance(PermutationImportance, model, variable, training, testing; kwargs...)

Calculates the feature importance of a model by _re-training_ a copy of the
model using the `training` instances, then evaluating the feature importance on
the `testing` instances.

Other `kwargs...` are passed to `featureimportance`.
"""
function featureimportance(
    ::Type{PermutationImportance},
    model::T,
    variable::Integer,
    training::Vector{Int64},
    testing::Vector{Int64};
    kwargs...,
) where {T <: AbstractSDM}
    nm = copy(model)
    train!(nm; training = training)
    return featureimportance(
        PermutationImportance,
        nm,
        variable,
        features(model)[:, testing],
        labels(model)[testing];
        kwargs...,
    )
end

@testitem "We can measure permutation feature importance with a given fold" begin
    model = SDM(RawData, NaiveBayes, SDeMo.__demodata()...)
    folds = holdout(model)

    variables!(model, [1, 12])

    @test featureimportance(
        PermutationImportance,
        model,
        2,
        folds...;
        threshold = true,
        ratio = true,
        optimality = accuracy,
    ) == 1.0
    @test featureimportance(
        PermutationImportance,
        model,
        12,
        folds...;
        threshold = true,
        ratio = true,
        optimality = accuracy,
    ) != 1.0
end

@testitem "We can measure feature importance with cross-entropy loss" begin
    model = SDM(RawData, NaiveBayes, SDeMo.__demodata()...)
    variables!(model, [1, 12])
    train!(model)

    @test featureimportance(
        PermutationImportance, model, 2;
        threshold = false, optimality = crossentropyloss
    ) ≈ 1.0

    @test featureimportance(
        PermutationImportance, model, 1;
        threshold = false, optimality = crossentropyloss
    ) > 1.0
end