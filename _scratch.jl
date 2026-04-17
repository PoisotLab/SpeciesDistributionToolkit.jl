# Test
using SpeciesDistributionToolkit
using Statistics
using Random
using CairoMakie

X, y, C = SDeMo.__demodata()

# Center predictors
μ = mean(X; dims = 2)
σ = std(X; dims = 2)
Z = (X .- μ) ./ σ

η = 0.01
λ = 0.1

β = 0.0
θ = randn(size(Z, 1)) .* 1e-3

f(X, θ, β) = θ' * X + β

# Lasso
function lasso!(∂, θ, args...)
    for i in eachindex(θ)
        ∂[i] = sign(θ[i])
    end
    return ∂
end

# Ridge
function ridge!(∂, θ, args...)
    for i in eachindex(θ)
        ∂[i] = 2.0 * θ[i]
    end
    return ∂
end

# Elasticnet
function elasticnet!(∂, θ, α = 0.5)
    for i in eachindex(θ)
        ∂[i] = (1 - α) * (2 * θ[i]) + α * sign(θ[i])
    end
    return ∂
end

# Hinge
# L(X, θ, β, Y) = max(0, 1 - Y * f(X, θ, β))
# ∂θ(X, Ŷ, Y) = Y * Ŷ < 1 ? -(Y * X) : 0.0
# ∂β(X, Ŷ, Y) = Y * Ŷ < 1 ? -Y : 0.0
# relink(x) = clamp(0.5 * (x + 1), 0, 1)

function gradient!(∂, β, X, θ, Y)
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

# Log-loss
#L(X, θ, β, Y) = log(1 + exp(-Y * f(X, θ, β)))
#∂θ(X, θ, β, Y) = -Y * X / (1 + exp(Y * f(X, θ, β)))
#∂β(X, θ, β, Y) = -Y / (1 + exp(Y * f(X, θ, β)))
relink(x) = 1 / (1 + exp(-x))

iters = 50
out = zeros(Float64, iters)
loss = zeros(Float64, iters)
c = 1

Y = 2 .* y .- 1

function foo!(θ, β, Z, Y; epochs = 50, η = 0.01, α = 0.5, λ = 0.1, intercept = true)
    # Positions - they will be shuffled at each iteration
    positions = collect(eachindex(Y))

    # Temporary arrays for the gradients
    ∂r = zeros(Float64, length(θ))
    ∂g = zeros(Float64, length(θ))
    for epoch in Base.OneTo(epochs)

        # Effective learning rate
        ηₜ = 0.9999^(epoch - 1) * η / length(Y)

        Random.shuffle!(positions)
        for position in positions
            ∂β = gradient!(∂g, β, Z[:, position], θ, Y[position])
            elasticnet!(∂r, θ, α)
            for i in eachindex(θ)
                θ[i] -= ηₜ * (∂g[i] + λ * ∂r[i])
            end
            if intercept
                β -= ηₜ * ∂β
            end
        end
    end
end

@profview foo!(θ, β, Z, Y)

foo!(θ, β, Z, Y)

fg = Figure()
a1 = Axis(fg[1, 1]; ylabel = "Intercept")
a2 = Axis(fg[2, 1]; ylabel = "Loss")
lines!(a1, out; color = :black)
lines!(a2, loss; color = :black)
current_figure()

output = vec(θ' * Z .+ β)
pred = relink.(output)

scatter(
    output[sortperm(output)] .+ randn(length(output)) .* 1e-2;
    color = y[sortperm(output)],
)
current_figure()

T = LinRange(0.0, 1.0, 250)
lc = [mcc(pred .> t, y) for t in T]
bestmcc, id = lc |> findmax

bestmcc

lines(T, lc)
vlines!(current_axis(), [T[id]])
current_figure()

scatter(pred[sortperm(pred)] .+ randn(length(pred)) .* 1e-2; color = y[sortperm(pred)])
hlines!(current_axis(), [T[id]])
current_figure()

scatter(X[1, :], pred; color = y)
hlines!(current_axis(), [T[id]])
current_figure()
