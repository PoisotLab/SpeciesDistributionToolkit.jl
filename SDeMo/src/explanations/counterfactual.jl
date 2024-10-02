function dmad(model, x, xprime)
    Xbar = vec(median(features(model); dims = 2))
    MAD = vec(median(abs.(features(model) .- Xbar); dims = 2))
    dfs = abs.(x .- xprime) ./ MAD
    return sum(dfs[variables(model)])
end

function nmloss(model, x, xprime, yhat, λ; kwargs...)
    fhat = predict(model, xprime; kwargs...)
    D1 = λ * (fhat - yhat)^2.0
    D2 = dmad(model, x, xprime)
    return D1 + D2
end

function shrink!(xn, xl; α = 1.0, β = 0.5, γ = 2.0, δ = 0.5)
    for i in eachindex(xn)
        xn[i] = xl .+ δ .* (xn[i] .- xl)
    end
    return xn
end

function neldermead!(
    xn,
    L,
    model,
    x,
    yhat,
    λ;
    α = 1.0,
    β = 0.5,
    γ = 2.0,
    δ = 0.5,
    kwargs...,
)
    best = partialsortperm(L, 1)
    second = partialsortperm(L, length(L) - 1)
    worst = partialsortperm(L, length(L))

    xh, xs, xl = xn[worst], xn[second], xn[best]
    fh, fs, fl = L[worst], L[second], L[best]

    bestside = filter(!isequal(worst), eachindex(xn))
    centroid = reduce(.+, xn[bestside]) ./ length(bestside)

    # Reflection
    xr = centroid .+ α .* (centroid .- xh)
    fr = nmloss(model, x, xr, yhat, λ; kwargs...)
    if fl <= fr < fs
        xn[worst] = xr
        return xn
    end

    # Expansion
    if fr < fl
        xe = centroid .+ γ .* (xr .- centroid)
        fe = nmloss(model, x, xe, yhat, λ; kwargs...)
        if fe < fr
            xn[worst] = xe
            return xn
        else
            xn[worst] = xr
            return xn
        end
    end

    # Contraction
    if fr >= fs
        if fs <= fr < fh
            xc = centroid .+ β .* (xr .- centroid)
            fc = nmloss(model, x, xc, yhat, λ; kwargs...)
            if fc <= fr
                xn[worst] = xc
                return xn
            else
                return shrink!(xn, xl)
            end
        end
        if fr >= fh
            xc = centroid .+ β .* (xr .- centroid)
            fc = nmloss(model, x, xc, yhat, λ; kwargs...)
            if fc < fh
                xn[worst] = xc
                return xn
            else
                return shrink!(xn, xl)
            end
        end
    end
end

function initialprop(model, x)
    xn = [copy(x) for _ in 1:(length(variables(model)) + 1)]
    for i in eachindex(variables(model))
        xn[i + 1][variables(model)[i]] =
            rand(features(model)[variables(model)[i], :]) + randn()
    end
    return xn
end

function xncenter(xn)
    return reduce(.+, xn) ./ length(xn)
end

"""
    counterfactual(model::AbstractSDM, x::Vector{T}, yhat, λ; maxiter=100, minvar=5e-5, kwargs...) where {T <: Number}

Generates one counterfactual explanation given an input vector `x`, and a target
rule to reach `yhat`. The learning rate is `λ`. The maximum number of iterations
used in the Nelder-Mead algorithm is `maxiter`, and the variance improvement
under which the model will stop is `minvar`. Other keywords are passed to
`predict`.
"""
function counterfactual(
    model::AbstractSDM,
    x::Vector{T},
    yhat,
    λ;
    maxiter = 100,
    minvar = 5e-5,
    kwargs...,
) where {T <: Number}
    xn = initialprop(model, x)
    L = [nmloss(model, x, xp, yhat, λ; kwargs...) for xp in xn]
    L0 = var(L)
    for _ in Base.OneTo(maxiter)
        neldermead!(xn, L, model, x, yhat, λ; kwargs...)
        L = [nmloss(model, x, xp, yhat, λ; kwargs...) for xp in xn]
        if var(L) / L0 <= minvar
            break
        end
    end
    return xn[last(findmin(L))]
end

@testitem "We can generate a counterfactual" begin
    X, y = SDeMo.__demodata()
    model = SDM(MultivariateTransform{PCA}, NaiveBayes, X, y)
    train!(model)
    c = counterfactual(
        model,
        instance(model, 3; strict = false),
        0.5,
        200.0;
        threshold = false,
    )
    @test length(c) == size(X, 1)
end

@testitem "We can generate a counterfactual from a bagged model" begin
    using Statistics
    X, y = SDeMo.__demodata()
    model = Bagging(SDM(MultivariateTransform{PCA}, DecisionTree, X, y), 10)
    train!(model)
    c = counterfactual(
        model,
        instance(model, 3; strict = false),
        0.5,
        200.0;
        threshold = false,
        consensus = median,
    )
    @test length(c) == size(X, 1)
end
