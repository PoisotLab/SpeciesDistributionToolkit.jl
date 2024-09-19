# No transformation
struct RawData <: Transformer end
train!(::RawData, args...) = nothing
StatsAPI.predict(::RawData, X) = X

# z-score
Base.@kwdef mutable struct ZScore <: Transformer
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