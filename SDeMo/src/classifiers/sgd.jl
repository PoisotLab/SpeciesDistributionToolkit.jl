__l1(w) = 0.5 * sum(w .* w)
__l2(w) = sum(abs.(w))

Base.@kwdef mutable struct SGD <: Classifier
    μ::Vector{<:Real} = zeros(2) # Averages
    σ::Vector{<:Real} = zeros(2) # Standard deviations
    η::Float64 = 0.01
    λ::Float64 = 0.1
    θ::Vector{Float64} = zeros(Float64, 2) # Coefficients
    β::Float64 = 0.0 # Intercept
    loss::Symbol = :logloss
    L2::Bool = true
    L1::Bool = false
    ratio::Float64 = 0.5
end
