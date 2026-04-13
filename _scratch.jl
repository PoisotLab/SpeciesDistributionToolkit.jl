# Test
using SpeciesDistributionToolkit
using Statistics
using Random

X, y, C = SDeMo.__demodata()

# Center predictors
μ = mean(X; dims = 2)
σ = std(X; dims = 2)
Z = (X .- μ) ./ σ

Z = vcat(ones(1, length(y)), Z)

η = 0.001

θ = randn(size(Z, 1)) .* 1e-3

__hinge(w, x, y) = max(0, 1 - y * (w' * x))
__hinge_gradient(w, x, y) = y * (w' * x) < 1 ? -y * x : 0.0

pred = vec(θ' * Z)

iters = 50
out = zeros(Float64, length(y)*iters)
c = 1

Y = 2 .* y .- 1

for it in Base.OneTo(iters)
    for i in Random.shuffle(eachindex(y))
        θ .-= η .* __hinge_gradient(θ, Z[:,i], Y[i])
        out[c] = θ[1]
        c += 1
    end
end

scatter(out, color=:grey50, markersize=6)

output = vec(θ' * Z)
pred = SDeMo.__sigmoid.(vec(θ' * Z))


T = LinRange(0.0, 1.0, 120)
lc = [mcc(pred .> t, y) for t in T]
id = lc |> findmax |> last

mcc(pred, y, T[id])

lines(T, lc)
vlines!(current_axis(), [T[id]])
current_figure()

scatter(pred[sortperm(pred)] .+ randn(length(pred)).*1e-2, color=y[sortperm(pred)])
hlines!(current_axis(), [T[id]])
current_figure()

scatter(X[1,:], pred, color=y)
hlines!(current_axis(), [T[id]])
current_figure()