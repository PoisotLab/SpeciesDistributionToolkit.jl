function dmad(model, x, xprime)
    Xbar = vec(median(model.X, dims=2))
    MAD = vec(median(abs.(model.X .- Xbar); dims=2))
    dfs = abs.(x .- xprime) ./ MAD
    return sum(dfs[model.v])
end

function loss(model, x, xprime, yhat, λ; kwargs...)
    fhat = predict(model, xprime; kwargs...)
    D1 = λ * (fhat - yhat)^2.0
    D2 = dmad(model, x, xprime)
    return D1 + D2
end

function shrink!(xn, xl; α = 1.0, β = 0.5, γ = 2.0, δ = 0.5)
    for i in eachindex(xn)
        xn[i] = xl .+ δ.*(xn[i] .- xl)
    end
    return xn
end

function neldermead!(xn, L, model, x, yhat, λ; α = 1.0, β = 0.5, γ = 2.0, δ = 0.5, kwargs...)

    best = partialsortperm(L, 1)
    second = partialsortperm(L, length(L) - 1)
    worst = partialsortperm(L, length(L))
    
    xh, xs, xl = xn[worst], xn[second], xn[best]
    fh, fs, fl = L[worst], L[second], L[best]
    
    bestside = filter(!isequal(worst), eachindex(xn))
    centroid = reduce(.+, xn[bestside]) ./ length(bestside)
    

    # Reflection
    xr = centroid .+ α .* (centroid .- xh)
    fr = loss(model, x, xr, yhat, λ; kwargs...)
    if fl <= fr < fs
        xn[worst] = xr
        return xn
    end

    # Expansion
    if fr < fl
        xe = centroid .+ γ .* (xr .- centroid)
        fe = loss(model, x, xe, yhat, λ; kwargs...)
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
            fc = loss(model, x, xc, yhat, λ; kwargs...)
            if fc <= fr
                xn[worst] = xc
                return xn
            else
                return shrink!(xn, xl)
            end
        end
        if fr >= fh
            xc = centroid .+ β .* (xr .- centroid)
            fc = loss(model, x, xc, yhat, λ; kwargs...)
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
    xn = [copy(x) for _ in 1:(length(model.v) + 1)]
    for i in eachindex(model.v)
        xn[i + 1][model.v[i]] = rand(model.X[model.v[i], :]) + randn()
    end
    return xn
end

function xncenter(xn)
    return reduce(.+, xn)./length(xn)
end

function counterfactual(model, x, yhat, λ; kwargs...)
    xn = initialprop(model, x)
    L = [loss(model, x, xp, yhat, λ; kwargs...) for xp in xn]
    L0 = var(L)
    for iter in 1:100
        neldermead!(xn, L, model, x, yhat, λ; kwargs...)
        L = [loss(model, x, xp, yhat, λ; kwargs...) for xp in xn]
        if var(L)/L0 <= 0.00005
            break
        end
    end
    return xn[last(findmin(L))]
end
