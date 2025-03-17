"""
    ChainedTransform

A transformer that applies, in sequence, several other transformers. This can be
used to, for example, do a PCA then a z-score on the projected space.
"""
mutable struct ChainedTransform{Tuple{Vararg{Transformer}}} <: Transformer
    transformers::Tuple{Vararg{Transformer}}
end

function ChainedTransform(steps::Type{<:Transformer}...)
    return ChainedTransform(tuple([step() for step in steps]...))
end

function Base.getindex(chain::ChainedTransform, i::Integer)
    return chain.transformers[i]
end

function train!(chain::ChainedTransform, X; kwdef...)
    train!(chain[1], X; kwdef...)
    Xₜ = predict(chain[1], Xₜ; kwdef...)
    for i in 2:length(chain.transformers)
        train!(chain[i], Xₜ)
        Xₜ = predict(chain[i], Xₜ; kwdef...)
    end
    return chain
end

function predict(chain::ChainedTransform, X::AbstractArray)
    Xₜ = predict(chain[1], X; kwdef...)
    for i in 2:length(chain.transformers)
        Xₜ = predict(chain[i], Xₜ; kwdef...)
    end
    return Xₜ
end

@testitem "We can train a chained transform" begin
    X, y = SDeMo.__demodata()
    chain = ChainedTransform(RawData, ZScore)
    S1 = SDM(ZScore, NaiveBayes, X, y)
    S2 = SDM(chain, NaiveBayes, X, y)
    train!(S1)
    train!(S2)
    @test all(predict(S1) .== predict(S2))
end
