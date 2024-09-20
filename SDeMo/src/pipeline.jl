"""
    train!(sdm::SDM; threshold=true, training=:, optimality=mcc)

TODO
"""
function train!(sdm::SDM; threshold=true, training=:, optimality=mcc)
    train!(sdm.transformer, sdm.X[sdm.v,training])
    X₁ = predict(sdm.transformer, sdm.X[sdm.v,training])
    train!(sdm.classifier, sdm.y[training], X₁)
    ŷ = predict(sdm.classifier, X₁)
    ŷ[findall(isnan.(ŷ))] .= 0.0
    if threshold
        thr_range = LinRange(extrema(ŷ)..., 200)
        C = [ConfusionMatrix(ŷ, sdm.y[training], thr) for thr in thr_range]
        sdm.τ = thr_range[last(findmax(optimality, C))]
    end
    return sdm
end

"""
    StatsAPI.predict(sdm::SDM, X; threshold = true)

TODO
"""
function StatsAPI.predict(sdm::SDM, X; threshold = true)
    X₁ = predict(sdm.transformer, X[sdm.v,:])
    ŷ = predict(sdm.classifier, X₁)
    ŷ = isone(length(ŷ)) ? ŷ[1] : ŷ
    if length(ŷ) > 1
        ŷ[findall(isnan.(ŷ))] .= 0.0
    else
        ŷ = isnan(ŷ) ? 0.0 : ŷ
    end
    if threshold
        return ŷ .>= sdm.τ
    else
        return ŷ
    end
end

function StatsAPI.predict(sdm::SDM; kwargs...)
    return StatsAPI.predict(sdm::SDM, sdm.X; kwargs...)
end

"""
    reset!(sdm::SDM, τ=0.5)

Resets a model, with a potentially specified value of the threshold. This
amounts to re-using all the variables, and removing the tuned threshold version.
"""
function reset!(sdm::SDM, τ=0.5)
    sdm.v = collect(axes(sdm.X, 1))
    sdm.τ = τ
    return sdm
end

#=
function StatsAPI.predict(sdm::SDM, layers::Vector{T}; kwargs...) where {T <: SimpleSDMLayer}
    pr = convert(Float64, similar(first(layers)))
    F = permutedims(hcat(values.(layers)...))
    pr.grid[findall(!isnothing, layers[1].grid)] .= predict(sdm, F; kwargs...)
    return pr
end

function StatsAPI.predict(ensemble::Bagging, layers::Vector{T}; kwargs...) where {T <: SimpleSDMLayer}
    pr = convert(Float64, similar(first(layers)))
    F = permutedims(hcat(values.(layers)...))
    pr.grid[findall(!isnothing, layers[1].grid)] .= predict(ensemble, F; kwargs...)
    return pr
end
=#