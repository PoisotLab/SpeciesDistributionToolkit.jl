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

Z = vcat(ones(1, length(y)), Z)

η = 0.01

θ = randn(size(Z, 1)) .* 1e-3
θ[1] = 0.0

__hinge(w, x, y) = max(0, 1 - y * (w' * x))
__hinge_gradient(w, x, y) = y * (w' * x) < 1 ? -y * x : 0.0

pred = vec(θ' * Z)

iters =1000
out = zeros(Float64, iters)
L = zeros(Float64, iters)
c = 1

Y = 2 .* y .- 1

intercept = true

for it in Base.OneTo(iters)
    for i in Random.shuffle(eachindex(y))
        θ .-= η*0.999^(it-1) .* __hinge_gradient(θ, Z[:,i], Y[i]) ./ length(y)
        if !intercept
            θ[1] = 0.0
        end
    end
    L[c] = sum([__hinge(θ, Z[:,i], Y[i]) for i in eachindex(y)]) / length(y)
    out[c] = θ[2]
    c += 1
end

scatter(L, color=:grey50, markersize=6)

output = vec(θ' * Z)

pred = clamp.((output .+ 1) ./ 2, 0, 1)


#pred = SDeMo.__sigmoid.(vec(θ' * Z))

T = LinRange(0.0, 1.0, 120)
lc = [mcc(pred .>= t, y) for t in T]
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