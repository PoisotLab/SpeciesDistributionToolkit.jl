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
∂Lasso(θ) = sign.(θ)
# Ridge
∂Ridge(θ) = 2 .* θ
# Elasticnet
α = 0.5
∂R(θ) = (1 - α) .* ∂Ridge(θ) .+ α .* ∂Lasso(θ)

# Hinge
# L(X, θ, β, Y) = max(0, 1 - Y * f(X, θ, β))
# ∂θ(X, Ŷ, Y) = Y * Ŷ < 1 ? -(Y * X) : 0.0
# ∂β(X, Ŷ, Y) = Y * Ŷ < 1 ? -Y : 0.0
# relink(x) = clamp(0.5 * (x + 1), 0, 1)

# Log-loss
L(X, θ, β, Y) = log(1 + exp(-Y * f(X, θ, β)))
∂θ(X, θ, β, Y) = -Y * X / (1 + exp(Y * f(X, θ, β)))
∂β(X, θ, β, Y) = -Y / (1 + exp(Y * f(X, θ, β)))
relink(x) = 1 / (1 + exp(-x))

iters = 3000
out = zeros(Float64, iters)
loss = zeros(Float64, iters)
c = 1

Y = 2 .* y .- 1

intercept = true

for it in Base.OneTo(iters)
    ηₜ = 0.99^(it - 1) * η / length(y)
    for i in Random.shuffle(eachindex(y))
        Ŷ = f(Z[:,i], θ, β)
        θ .-= ηₜ .* (∂θ(Z[:, i], Ŷ, Y[i]) .+ λ .* ∂R(θ))
        if intercept
            β -= ηₜ * ∂β(Z[:, i], Ŷ, Y[i])
        end
    end
    loss[c] = sum([L(Z[:, i], θ, β, Y[i]) for i in eachindex(y)]) / length(y)
    out[c] = θ[1]
    c += 1
end

scatter(out; color = :grey50, markersize = 6)

output = vec(θ' * Z .+ β)
pred = relink.(output)

scatter(output[sortperm(output)] .+ randn(length(output)) .* 1e-2; color = y[sortperm(output)])
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

model = SDM(RawData, Logistic, X, y, C)
hyperparameters!(classifier(model), :interactions, :none)
train!(model)

scatter(predict(model; threshold=false), pred)
mcc(predict(model), labels(model))