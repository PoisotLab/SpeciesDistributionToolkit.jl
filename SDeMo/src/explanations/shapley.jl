"""
    _mcsample(x::Vector{T}, X::Matrix{T}, j::Int64, n::Int64) where {T <:Number}

This generates a Monte-Carlo sample for Shapley values. The arguments are, in
order

x: a single instance (as a vector) to explain

X: a matrix of training data providing the samples for explanation

j: the index of the variable to explain

n: the number of samples to generate for evaluation
"""
function _mcsample(x::Vector{<:AbstractFloat}, X::Matrix{<:AbstractFloat}, j::Int64, n::Int64)
    # Initial sample matrix
    T = promote_type(eltype(x), eltype(X))
    ξ = zeros(T, length(x), n)
    for instance in axes(ξ, 2)
        ξ[:, instance] = x
    end
    # Observations for boostrap
    p = rand(axes(X, 2), n)
    # And now we shuffle
    shuffling = rand(Bool, size(ξ))
    for ob in axes(shuffling, 2)
        for va in axes(shuffling, 1)
            if va != j
                if shuffling[va, ob]
                    ξ[va, ob] = X[va, p[ob]]
                end
            end
        end
    end
    ζ = copy(ξ)
    ζ[j, :] .= X[j, p]
    return ξ, ζ
end

"""
    _explain_one_instance(f, instance, X, j, n)

This method returns the explanation for the instance at variable j, based on
training data X. This is the most granular version of the Shapley values
algorithm.
"""
function _explain_one_instance(f, instance, X, j, n)
    ξ, ζ = _mcsample(instance, X, j, n)
    ϕ = f(ξ) - f(ζ)
    return sum(ϕ) / length(ϕ)
end

"""
    _explain_many_instances(f, Z, X, j, n)

Applies _explain_one_instance on the matrix Z
"""
function _explain_many_instances(f, Z, X, j, n)
    # We run a single instance to make sure we get the correct return type
    T = typeof(_explain_one_instance(f, Z[:,1], X, 1, 2))
    output = zeros(T, size(Z, 2))
    chunk_size = max(1, length(output) ÷ (5 * Threads.nthreads()))
    data_chunks = Base.Iterators.partition(eachindex(output), chunk_size)
    tasks = map(data_chunks) do chunk
        Threads.@spawn begin
            for i in chunk
                output[i] = _explain_one_instance(f, Z[:, i], X, j, n)
            end
        end
    end
    fetch.(tasks)
    return output
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
    # This is our function f
    predictor(x) = predict(model, x; kwargs...)
    # 
    instances = isnothing(instances) ? features(model) : instances
    if isnothing(observation)
        return _explain_many_instances(predictor, instances, features(model), j, samples)
    else
        return _explain_one_instance(
            predictor,
            instances[:, observation],
            features(model),
            j,
            samples,
        )
    end
end

@testitem "We can calculate Shapley values" begin
    X, y = SDeMo.__demodata()
    sdm = SDM(RawData, NaiveBayes, X, y)
    variables!(sdm, [1, 2])
    train!(sdm)
    expl = explain(sdm, 1)
    @test expl isa Vector{Float64}
    @test length(expl) == length(labels(sdm))
    expl_null = explain(sdm, 10)
    @test all(expl_null .≈ 0.0)
end

@testitem "We can calculate Shapley values on non-training data" begin
    X, y = SDeMo.__demodata()
    sdm = SDM(RawData, NaiveBayes, X, y)
    variables!(sdm, [1, 2])
    train!(sdm)
    expl_indices = sort(unique(rand(axes(X, 2), 100)))
    eX = X[:, expl_indices]
    @test explain(sdm, 1; instances = eX) isa Vector{Float64}
    @test length(explain(sdm, 1; instances = eX)) == length(expl_indices)
    @test all(explain(sdm, 10; instances = eX) .≈ 0.0)
end

@testitem "We can calculate Shapley values for a single observation" begin
    X, y = SDeMo.__demodata()
    sdm = SDM(RawData, NaiveBayes, X, y)
    variables!(sdm, [1, 3, 4, 17, 11, 2])
    train!(sdm)
    expl_1 = explain(sdm, 1; observation=1)
    @test expl_1 != 0.0
    expl_10 = explain(sdm, 10; observation=1)
    @test expl_10 ≈ 0.0
end

@testitem "We can calculate Shapley values on differently-typed data" begin
    X, y = SDeMo.__demodata()
    sdm = SDM(RawData, NaiveBayes, X, y)
    train!(sdm)
    expl_indices = sort(unique(rand(axes(X, 2), 100)))
    eX = convert(Matrix{Float16}, X[:, expl_indices])
    @test explain(sdm, 1; instances = eX) isa Vector{<:AbstractFloat}
    @test length(explain(sdm, 1; instances = eX)) == length(expl_indices)
    @test all(explain(sdm, 10; instances = eX) .≈ 0.0)
end