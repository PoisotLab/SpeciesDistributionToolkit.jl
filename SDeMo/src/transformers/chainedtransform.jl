"""
    ChainedTransform{T1, T2}

A transformer that applies, in sequence, a pair of other transformers. This can
be used to, for example, do a PCA then a z-score on the projected space. This is
limited to two steps because the value of chaining more transformers is
doubtful. We may add support for more complex transformations in future
versions.

The first and second steps are accessible through `first` and `last`.
"""
mutable struct ChainedTransform{T1 <: Transformer, T2 <: Transformer} <: Transformer
    trf1::T1
    trf2::T2
end

Base.first(chain::ChainedTransform) = chain.trf1
Base.last(chain::ChainedTransform) = chain.trf2

function ChainedTransform{T1,T2}() where {T1 <: Transformer, T2 <: Transformer}
    return ChainedTransform(T1(), T2())
end

function train!(chain::ChainedTransform, X; kwdef...)
    train!(chain.trf1, X; kwdef...)
    Xₜ = StatsAPI.predict(chain.trf1, X; kwdef...)
    train!(chain.trf2, Xₜ; kwdef...)
    return chain
end

function StatsAPI.predict(chain::ChainedTransform, X::AbstractArray; kwdef...)
    Xₜ = StatsAPI.predict(chain.trf1, X; kwdef...)
    Xₜ = StatsAPI.predict(chain.trf2, Xₜ; kwdef...)
    return Xₜ
end

@testitem "We can train a chained transform" begin
    X, y = SDeMo.__demodata()
    c1 = ChainedTransform{RawData, ZScore}
    c2 = ChainedTransform{ZScore, RawData}
    S0 = SDM(ZScore, NaiveBayes, X, y)
    S1 = SDM(c1, NaiveBayes, X, y)
    S2 = SDM(c2, NaiveBayes, X, y)
    train!(S0)
    train!(S1)
    train!(S2)
    @test all(predict(S1) .== predict(S2))
    @test all(predict(S0) .== predict(S1))
    @test all(predict(S0) .== predict(S2))
end

@testitem "We can train a Logistic after a PCA using a chained transform" begin
    X, y = SDeMo.__demodata()
    chain = ChainedTransform{PCATransform, ZScore}
    model = SDM(chain, Logistic, X, y)
    hyperparameters!(classifier(model), :η, 1e-3)
    hyperparameters!(classifier(model), :epochs, 10_000)
    train!(model)
    @test eltype(predict(model)) <: Bool
end

@testitem "Variable selection works on a chained transformation" begin
    X, y = SDeMo.__demodata()
    chain = ChainedTransform{PCATransform, ZScore}
    model = SDM(chain, DecisionTree, X, y)
    forwardselection!(model, kfold(model); verbose=true)
    @test length(variables(model)) <= 19
end

@testitem "We can access the first and last element of a chained transformation" begin
    chain = ChainedTransform{PCATransform, ZScore}()
    @test typeof(first(chain)) === PCATransform
    @test typeof(last(chain)) === ZScore
end