module MultivariateExtension

using SpeciesDistributionToolkit
using MultivariateStats
using StatsAPI

function _layers_to_matrix(X)
    Y = zeros(SimpleSDMLayers._inner_type(X[1]), (length(X), length(X[1])))
    for i in axes(X, 1)
        Y[i, :] .= values(X[i])
    end
    return Y
end

# PCA

function StatsAPI.fit(
    ::Type{MultivariateStats.PCA},
    X::Vector{T};
    kwargs...,
) where {T <: SimpleSDMLayers.SimpleSDMLayer}
    @assert SimpleSDMLayers._layers_are_compatible(X)
    Y = _layers_to_matrix(X)
    return StatsAPI.fit(MultivariateStats.PCA, Y; kwargs...)
end

function StatsAPI.predict(
    M::MultivariateStats.PCA,
    X::Vector{T},
) where {T <: SimpleSDMLayers.SimpleSDMLayer}
    @assert SimpleSDMLayers._layers_are_compatible(X)
    Y = _layers_to_matrix(X)
    D = StatsAPI.predict(M, Y)
    O = [similar(X[1], eltype(D)) for i in 1:MultivariateStats.outdim(M)]
    for i in axes(O, 1)
        for (j, k) in enumerate(keys(O[i]))
            O[i][k] = D[i, j]
        end
    end
    return O
end

# Whitening

function StatsAPI.fit(
    ::Type{MultivariateStats.Whitening},
    X::Vector{T};
    n::Int = 1_000,
    kwargs...,
) where {T <: SimpleSDMLayers.SimpleSDMLayer}
    @assert SimpleSDMLayers._layers_are_compatible(X)
    Y = _layers_to_matrix(X)
    return StatsAPI.fit(MultivariateStats.Whitening, Y; kwargs...)
end

function MultivariateStats.transform(
    W::MultivariateStats.Whitening,
    X::Vector{T},
) where {T <: SimpleSDMLayers.SimpleSDMLayer}
    @assert SimpleSDMLayers._layers_are_compatible(X)
    Y = _layers_to_matrix(X)
    D = MultivariateStats.transform(W, Y)
    O = [similar(X[1], eltype(D)) for i in 1:length(X)]
    for i in axes(O, 1)
        for (j, k) in enumerate(keys(O[i]))
            O[i][k] = D[i, j]
        end
    end
    return O
end

end