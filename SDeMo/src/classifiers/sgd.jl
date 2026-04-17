# Log-loss
#L(X, θ, β, Y) = log(1 + exp(-Y * f(X, θ, β)))

# Hinge
# L(X, θ, β, Y) = max(0, 1 - Y * f(X, θ, β))

"""
    SGD

Stochastic gradient descent classifier.
"""
Base.@kwdef mutable struct SGD <: Classifier
    μ::Vector{Float64} = zeros(2) # Averages
    σ::Vector{Float64} = ones(2) # Standard deviations
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

hyperparameters(::Type{SGD}) = (:η, :λ, :loss, :L2, :L1, :α, :epochs, :intercept)

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

function _sgd_gradient_hinge!(∂, β, X, θ, Y)
    # Make prediction
    ŷ = β
    for i in eachindex(θ)
        ŷ += θ[i] * X[i]
    end
    # Calculate gradient
    for i in eachindex(θ)
        ∂[i] = (Y * ŷ < 1) ? -(Y * X[i]) : 0.0
    end
    ∂β = (Y * ŷ < 1) ? -Y : 0.0
    return ∂β
end

function train!(sgd::SGD, y::Vector{Bool}, X::Matrix{T}; kwargs...) where {T <: Number}
    if sgd.loss == :logloss
        gradient! = _sgd_gradient_logloss!
    elseif sgd.loss == :hinge
        gradient! = _sgd_gradient_hinge!
    end

    if sgd.L1 & sgd.L2
        regul! = elasticnet!
    elseif sgd.L1
        regul! = lasso!
    elseif sgd.L2
        regul! = ridge!
    end 

    sgd.μ = vec(mean(X; dims = 2))
    sgd.σ = vec(std(X; dims = 2))
    Z = (X .- sgd.μ) ./ sgd.σ
    Y = 2 .* y .- 1

    # Starting parameters
    sgd.θ = randn(size(Z, 1)) .* 1e-5

    # Positions for the stochastic update
    positions = collect(eachindex(Y))

    # Temporary arrays for the gradient
    ∂r = zeros(Float64, length(sgd.θ))
    ∂g = zeros(Float64, length(sgd.θ))

    # Main loop
    for epoch in Base.OneTo(sgd.epochs)
        ηₜ = 0.9999^(epoch - 1) * sgd.η / length(Y)
        Random.shuffle!(positions)
        for position in positions
            ∂β = gradient!(∂g, sgd.β, Z[:, position], sgd.θ, Y[position])
            regul!(∂r, sgd.θ, sgd.α)
            for i in eachindex(sgd.θ)
                sgd.θ[i] -= ηₜ * (∂g[i] + sgd.λ * ∂r[i])
            end
            if sgd.intercept
                sgd.β -= ηₜ * ∂β
            end
        end
    end

    # This is trained now
    return sgd
end

_sgd_link_logloss(x) = 1 / (1 + exp(-x))
_sgd_link_hinge(x) = clamp(0.5 * (x + 1), 0, 1)

function StatsAPI.predict(sgd::SGD, X::Matrix{T}) where {T <: Number}
    if sgd.loss == :logloss
        link = _sgd_link_logloss
    elseif sgd.loss == :hinge
        link = _sgd_link_hinge
    end
    Z = (X .- sgd.μ) ./ sgd.σ
    return vec(link.(sgd.θ' * Z .+ sgd.β))
end