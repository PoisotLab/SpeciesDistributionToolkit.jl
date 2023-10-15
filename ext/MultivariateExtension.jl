module MultivariateExtension

using SpeciesDistributionToolkit
using MultivariateStats
using StatsAPI

function StatsAPI.fit(
    ::Type{MultivariateStats.PCA},
    X::Vector{T};
    kwargs...,
) where {T <: SimpleSDMLayers.SimpleSDMLayer}
    @assert SimpleSDMLayers._layers_are_compatible(X)
    return StatsAPI.fit(MultivariateStats.PCA, Array(X); kwargs...)
end

function StatsAPI.predict(
    M::MultivariateStats.PCA,
    X::Vector{T},
) where {T <: SimpleSDMLayers.SimpleSDMLayer}
    @assert SimpleSDMLayers._layers_are_compatible(X)
    D = StatsAPI.predict(M, Array(X))
    O = [similar(X[1], eltype(D)) for i in 1:MultivariateStats.outdim(M)]
    for i in axes(O, 1)
        for (j, k) in enumerate(keys(O[i]))
            O[i][k] = D[i, j]
        end
    end
    return O
end

function StatsAPI.fit(
    ::Type{MultivariateStats.Whitening},
    X::Vector{T};
    kwargs...,
) where {T <: SimpleSDMLayers.SimpleSDMLayer}
    @assert SimpleSDMLayers._layers_are_compatible(X)
    return StatsAPI.fit(MultivariateStats.Whitening, Array(X); kwargs...)
end

function MultivariateStats.transform(
    W::MultivariateStats.Whitening,
    X::Vector{T},
) where {T <: SimpleSDMLayers.SimpleSDMLayer}
    @assert SimpleSDMLayers._layers_are_compatible(X)
    D = MultivariateStats.transform(W, Array(X))
    O = [similar(X[1], eltype(D)) for i in 1:length(X)]
    for i in axes(O, 1)
        for (j, k) in enumerate(keys(O[i]))
            O[i][k] = D[i, j]
        end
    end
    return O
end

end