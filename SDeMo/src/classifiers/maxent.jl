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
    linkfunction::Symbol = :default
    model = nothing
end
export Maxent

hyperparameters(::Type{Maxent}) =
    (:linear, :categorical, :hinge, :product, :regularization, :linkfunction)

Base.zero(::Type{Maxent}) = 0.5

function _featurevector(me::Maxent)
    n = Maxnet.AbstractFeatureClass[]
    if me.linear
        push!(n, Maxnet.LinearFeature())
    end
    if me.categorical
        push!(n, Maxnet.CategoricalFeature())
    end
    if me.hinge
        push!(n, Maxnet.HingeFeature())
    end
    if me.product
        push!(n, Maxnet.ProductFeature())
    end
    return n
end

function train!(
    me::Maxent,
    y::Vector{Bool},
    X::Matrix{T};
    kwargs...,
) where {T <: Number}
    feat_vec = _featurevector(me)
    if isempty(feat_vec)
        feat_vec = Maxnet.default_features(sum(y))
    end
    me.model = Maxnet.maxnet(convert(BitVector, y), Tables.table(permutedims(X)); features=feat_vec, regularization_multiplier=me.regularization)
    return me
end

function _maxent_link_function(me::Maxent)
    fncs = Dict(
        :default => Maxnet.CloglogLink(),
        :logit => Maxnet.LogitLink(),
        :log => Maxnet.LogLink(),
        :identity => Maxnet.IdentityLink
    )
    if !(me.linkfunction in keys(fncs))
        throw(ArgumentError("""The link function $(me.linkfunction) does not exist

        Possible values are $(join(keys(fncs), ", "))
        """))
    else
        return fncs[me.linkfunction]
    end
end

function StatsAPI.predict(me::Maxent, x::Vector{T}) where {T <: Number}
    return predict(me.model, hcat(x))
end

function StatsAPI.predict(me::Maxent, X::Matrix{T}) where {T <: Number}
    return Maxnet.predict(me.model, Tables.table(permutedims(X)); link=_maxent_link_function(me))
end