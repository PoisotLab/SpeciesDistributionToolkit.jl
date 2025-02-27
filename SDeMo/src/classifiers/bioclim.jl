"""
    BIOCLIM

BIOCLIM
"""
Base.@kwdef mutable struct BIOCLIM <: Classifier
    ecdf::Vector = [(x) -> 0.0]
end

Base.zero(::Type{BIOCLIM}) = 0.01

function train!(bc::BIOCLIM, y::Vector{Bool}, X::Matrix{T}; kwargs...) where {T <: Number}
    presences = findall(y)
    obs = X[:, presences]
    bc.ecdf = vec(mapslices(ecdf, obs; dims = 2))
    return bc
end

function StatsAPI.predict(bc::BIOCLIM, x::Vector{T}) where {T <: Number}
    s = zeros(length(x))
    for i in eachindex(s)
        s[i] = _bioclim_score(bc.ecdf[i](x[i]))
    end
    return 2.0 * minimum(s)
end

function StatsAPI.predict(bc::BIOCLIM, X::Matrix{T}) where {T <: Number}
    return vec(mapslices(x -> predict(bc, x), X; dims = 1))
end

function _bioclim_score(x::T) where {T <: AbstractFloat}
    if x >= 0.5
        return one(T) - x
    end
    return x
end
