"""
    RawData

A transformer that does *nothing* to the data.
"""
struct RawData <: Transformer end

train!(::RawData, args...) = nothing
StatsAPI.predict(::RawData, X) = X

"""
    ZScore

A transformer that scales and centers the data, using only the data that are
avaiable to the model at training time.
"""
Base.@kwdef mutable struct  <: Transformer
    μ::AbstractArray = zeros(1)
    σ::AbstractArray = zeros(1)
end

function train!(zs::ZScore, X; kwdef...)
    zs.μ = vec(mean(X; dims = 2))
    zs.σ = vec(std(X; dims = 2))
    return zs
end
function StatsAPI.predict(zs::ZScore, x::AbstractArray)
    return (x .- zs.μ) ./ (zs.σ)
end