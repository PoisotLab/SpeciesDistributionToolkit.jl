__sigmoid(z::Number) = 1.0 / (1.0 + exp(-z))
__sigmoid(z::AbstractVector{<:Number}) = __sigmoid.(z)

function __interactions(X)
    XiXi = X.^2
    nfeat = size(X, 1)
    intft = round(Int64, nfeat*(nfeat-1)/2)
    XiXj = zeros(eltype(X), intft, size(X, 2))
    cursor = 1
    for i in Base.OneTo(nfeat)
        for j in (i+1):nfeat
            XiXj[cursor, : ] = X[i,:] .* X[j,:]
            cursor += 1
        end
    end
    return XiXi, XiXj
end

"""
    Logistic

Logistic regression with default learning rate of 0.01, penalization (L2) of
0.1, and 2000 epochs - note that this classifier uses all interactions between
the features, turning some of them off will be added to future releases.
"""
Base.@kwdef mutable struct Logistic <: Classifier
    λ::Float64 = 0.1 # Regularization
    η::Float64 = 0.01 # Learning rate
    epochs::Int64 = 2_000 # Epochs
    θ::Vector{Float64} = zeros(Float64, 2)
end

Base.zero(::Type{Logistic}) = 0.5

function SDeMo.train!(lreg::Logistic, y::Vector{Bool}, X::Matrix{T}) where {T<:Number}
    XiXi, XiXj = __interactions(X)
    
    num_samples = size(X, 2)
    num_features = size(X, 1)
    num_squares = size(XiXi, 1)
    num_interactions = size(XiXj, 1)
    
    θ₀ = zeros(1)
    θᵢ = zeros(num_features)
    θᵢᵢ = zeros(num_squares)
    θᵢⱼ = zeros(num_interactions)

    𝐗 = vcat(ones(num_samples)', X, XiXi, XiXj)
    𝐗t = transpose(𝐗)
    lreg.θ = vcat(θ₀, θᵢ, θᵢᵢ, θᵢⱼ)

    for epoch in 1:lreg.epochs
        z = 𝐗t * lreg.θ
        h = __sigmoid(z)
        gradient = (1/length(lreg.θ)) * 𝐗 * (h - y) + (lreg.λ/length(lreg.θ)) * lreg.θ
        lreg.θ -= lreg.η * gradient
        #h = clamp.(h, eps(), 1 - eps())
        #loss = -mean(y .* log.(h) .+ (1 .- y) .* log.(1 .- h)) + (λ/(2*length(θ))) * sum(θ[2:end].^2)
        #println("Epoch $epoch: Loss = $loss")
    end

    return lreg
end

function StatsAPI.predict(lreg::Logistic, x::Vector{T}) where {T<:Number}
    return predict(lreg, reshape(x, :, 1))
end

function StatsAPI.predict(lreg::Logistic, X::Matrix{T}) where {T<:Number}
    XiXi, XiXj = __interactions(X)
    num_samples = size(X, 2)
    𝐗 = vcat(ones(num_samples)', X, XiXi, XiXj)
    z = transpose(𝐗) * lreg.θ
    return __sigmoid(z)
end

function __equation(sdm::SDM)
    n_features = length(variables(sdm))
    Θ = round.(sdm.classifier.θ; digits=2)
    terms = ["$(Θ[1])"]
    idx = 2
    for i in 1:n_features
        push!(terms, "$(Θ[idx]) 𝐗($i)")
        idx += 1
    end
    for i in 1:n_features
        for j in i+1:n_features
            if Θ[idx] != 0
                vars = i == j ? "𝐗($i)²" : "𝐗($i)⋅𝐗($j)"
                push!(terms, "$(Θ[idx]) $(vars)")
            end
            idx += 1
        end
    end
    return replace(join(terms, " + "), "+ -" => "- ")
end