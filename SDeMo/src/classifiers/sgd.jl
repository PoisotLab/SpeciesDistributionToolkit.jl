# Log-loss
#L(X, θ, β, Y) = log(1 + exp(-Y * f(X, θ, β)))

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
    α::Float64 = 0.5
    epochs::Int = 10_000
    intercept::Bool = true
end
export SGD

"""
    lasso!(∂, θ, args...)
"""
function lasso!(∂, θ, args...)
    for i in eachindex(θ)
        ∂[i] = sign(θ[i])
    end
    return ∂
end

"""
    ridge!(∂, θ, args...)
"""
function ridge!(∂, θ, args...)
    for i in eachindex(θ)
        ∂[i] = 2.0 * θ[i]
    end
    return ∂
end

"""
    elasticnet!(∂, θ, α = 0.5)
"""
function elasticnet!(∂, θ, α = 0.5)
    for i in eachindex(θ)
        ∂[i] = (1 - α) * (2 * θ[i]) + α * sign(θ[i])
    end
    return ∂
end

Base.zero(::Type{SGD}) = 0.5

function _sgd_gradient_logloss!(∂, β, X, θ, Y)
    # Make prediction
    ŷ = β
    for i in eachindex(θ)
        ŷ += θ[i] * X[i]
    end
    # Calculate gradient
    for i in eachindex(θ)
        ∂[i] = -Y * X[i] / (1 + exp(Y * ŷ))
    end
    ∂β = -Y / (1 + exp(Y * ŷ))
    return ∂β
end

function train!(sgd::SGD, y::Vector{Bool}, X::Matrix{T}; kwargs...) where {T <: Number}
    if sdg.loss == :logloss
        gradient! = _sgd_gradient_logloss!
    end

    sgd.μ = mean(X; dims = 2)
    sgd.σ = std(X; dims = 2)
    Z = (X .- sgd.μ) ./ sgd.σ
    Y = 2 .* y .- 1

    # Starting parameters
    sdg.θ = randn(size(Z, 1)) .* 1e-3

    # Positions for the stochastic update
    positions = collect(eachindex(Y))

    # Temporary arrays for the gradient
    ∂r = zeros(Float64, length(θ))
    ∂g = zeros(Float64, length(θ))

    # Main loop
    for epoch in Base.OneTo(sdg.epochs)
        ηₜ = 0.9999^(epoch - 1) * sdg.η / length(Y)
        Random.shuffle!(positions)
        for position in positions
            ∂β = gradient!(∂g, sdg.β, Z[:, position], sdg.θ, Y[position])
            elasticnet!(∂r, sdg.θ, sdg.α)
            for i in eachindex(sdg.θ)
                sdg.θ[i] -= ηₜ * (∂g[i] + sdg.λ * ∂r[i])
            end
            if intercept
                sdg.β -= ηₜ * ∂β
            end
        end
    end

    # This is trained now
    return sdg
end

function StatsAPI.predict(sdg::SDG, x::Vector{T}) where {T <: Number}
    if sdg.loss == :logloss
        relink(x) = 1 / (1 + exp(-x))
    end
    z = (x .- sgd.μ) ./ sgd.σ
    return relink.(sdg.θ' * z .+ sdg.β)
end
