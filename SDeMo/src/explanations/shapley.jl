function mcsample(X, Z, i, j, n)
    # Initial sample matrix
    ξ = zeros(eltype(X), size(X, 1), n)
    for instance in axes(ξ, 2)
        ξ[:, instance] = X[:, i]
    end
    # Observations for boostrap
    p = rand(axes(Z, 2), n)
    # And now we shuffle
    shuffling = rand(Bool, size(ξ))
    for ob in axes(shuffling, 2)
        for va in axes(shuffling, 1)
            if va != j
                if shuffling[va, ob]
                    ξ[va, ob] = Z[va, p[ob]]
                end
            end
        end
    end
    ζ = copy(ξ)
    ζ[j, :] .= X[j, p]
    return ξ, ζ
end

mcsample(X, i, j, n) = mcsample(X, X, i, j, n)

function shap_one_point(f, X, Z, i, j, n)
    ξ, ζ = mcsample(X, Z, i, j, n)
    ϕ = f(ξ) - f(ζ)
    return sum(ϕ) / length(ϕ)
end

function shap_list_points(f, X, Z, i, j, n)
    p0 = shap_one_point(f, X, Z, first(i), j, n)
    vals = Vector{typeof(p0)}(undef, length(i))
    vals[begin] = p0
    chunks = ceil.(Int, LinRange(1, length(i), Threads.nthreads() + 1))
    Threads.@threads for thr in 1:Threads.nthreads()
        bg, nd = chunks[thr] + 1, chunks[thr + 1]
        for smpl in bg:nd
            vals[smpl] = shap_one_point(f, X, Z, i[smpl], j, n)
        end
    end
    return vals
end

function shap_all_points(f, X, Z, j, n)
    return shap_list_points(f, X, Z, axes(X, 2), j, n)
end

"""
    explain(model::AbstractSDM, j; observation = nothing, instances = nothing, samples = 100, kwargs..., )

Uses the MCMC approximation of Shapley values to provide explanations to
specific predictions. The second argument `j` is the variable for which the
explanation should be provided.

The `observation` keywords is a row in the `instances` dataset for which
explanations must be provided. If `instances` is `nothing`, the explanations
will be given on the training data.

All other keyword arguments are passed to `predict`.
"""
function explain(
    model::T,
    j;
    observation = nothing,
    instances = nothing,
    samples = 200,
    kwargs...,
) where {T <: AbstractSDM}
    function predictor(x)
        return predict(model, x; kwargs...)
    end
    instances = isnothing(instances) ? features(model) : instances
    if isnothing(observation)
        return shap_all_points(predictor, instances, features(model), j, samples)
    else
        return shap_one_point(predictor, instances, features(model), observation, j, samples)
    end
end