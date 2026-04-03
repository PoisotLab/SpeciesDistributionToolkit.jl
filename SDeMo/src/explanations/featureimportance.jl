struct PermutationImportance end

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

function featureimportance(
    ::Type{PermutationImportance},
    model::T,
    variable::Integer,
    X::Matrix,
    y::Vector{Bool};
    samples = 10,
    ratio::Bool = true,
    optimality = mcc,
    kwargs...,
) where {T <: AbstractSDM}
    O₀ = optimality(ConfusionMatrix(predict(model, X), y))
    Oᵢ = zeros(Float64, samples)
    for i in Base.OneTo(samples)
        Xₚ = copy(X)
        Xₚ[variable, :] .= Random.shuffle!(Xₚ[variable, :])
        yₚ = predict(model, Xₚ; kwargs...)
        Oᵢ[i] = optimality(ConfusionMatrix(yₚ, y))
    end
    O = sum(Oᵢ) / samples
    return ratio ? O / O₀ : O - O₀
end

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
        @test featureimportance(PartialDependence, model, 12; threshold = t) > 10.0
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
