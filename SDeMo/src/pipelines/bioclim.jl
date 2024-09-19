Base.@kwdef mutable struct BIOCLIM <: Classifier
    ecdf::Vector = [(x) -> 0.0]
end

function train!(bc::BIOCLIM, y::Vector{Bool}, X::Matrix{T}) where {T <: Number}
    presences = findall(y)
    obs = X[:, presences]
    bc.ecdf = vec(mapslices(ecdf, obs; dims = 2))
    return bc
end

function StatsAPI.predict(bc::BIOCLIM, x::Vector{T}) where {T <: Number}
    s = [_bioclim_score(bc.ecdf[i](x[i])) for i in eachindex(x)]
    return 2minimum(s)
end

function StatsAPI.predict(bc::BIOCLIM, X::Matrix{T}) where {T <: Number}
    return vec(mapslices(x -> predict(bc, x), X; dims = 1))
end

_bioclim_score(x) = x > 0.5 ? 1.0 - x : x