"""
    ChainedTransform{T1, T2}

A transformer that applies, in sequence, a pair of other transformers. This can
be used to, for example, do a PCA then a z-score on the projected space. This is
limited to two steps because the value of chaining more transformers is
doubtful.
"""
mutable struct ChainedTransform{T1 <: Transformer, T2 <: Transformer} <: Transformer
    trf1::T1
    trf2::T2
end

function ChainedTransform(::Type{T1}, ::Type{T2}) where {T1 <: Transformer, T2 <: Transformer}
    return ChainedTransform{T1, T2}(T1(), T2())
end

function train!(chain::ChainedTransform, X; kwdef...)
    train!(chain.trf1, X; kwdef...)
    Xₜ = predict(chain.trf1, Xₜ; kwdef...)
    train!(chain.trf2, Xₜ; kwdef...)
    return chain
end

function predict(chain::ChainedTransform, X::AbstractArray)
    Xₜ = predict(chain.trf1, X; kwdef...)
    Xₜ = predict(chain.trf2, Xₜ; kwdef...)
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
