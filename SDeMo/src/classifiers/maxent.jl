"""
    Maxent

Maximum entropy, using the `Maxnet.jl` package
"""
Base.@kwdef mutable struct Maxent <: Classifier
    linear::Bool = true
    categorical::Bool = true
    hinge::Bool = false
    product::Bool = false
    regularization::Float64 = 1.0
    linkfunction::Symbol = :CloglogLink
    model::Maxnet.MaxnetModel = Maxnet.maxnet([true, false, true], rand(2, 2, 3))
end
export Maxent

hyperparameters(::Type{Maxent}) =
    (:linear, :categorical, :hinge, :product, :regularization, :linkfunction)

Base.zero(::Type{Maxent}) = 0.5

function train!(
    me::Maxent,
    y::Vector{Bool},
    X::Matrix{T};
    kwargs...,
) where {T <: Number}
    # TODO set hyper-parameters
    me.model = Maxnet.maxnet(y, X)
    return me
end

function StatsAPI.predict(me::Maxent, x::Vector{T}) where {T <: Number}
    return predict(me.model, hcat(x))
end

function StatsAPI.predict(me::Maxent, X::Matrix{T}) where {T <: Number}
    return predict(me.model, X)
end