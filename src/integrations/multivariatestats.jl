function _partial_array_from_layers(layers::Vector{T}; samples::Int=10_000) where {T <: SimpleSDMLayers.SimpleSDMLayer}
    all_keys = unique(vcat(keys.(layers)...))
    samples = max(length(all_keys), samples)
    selected_keys = StatsBase.sample(all_keys, samples; replace=false)
    X = Vector(Float64, (length(selected_keys), length(layers)))
    for i in axes(layers, 1)
        for j in axes(selected_keys, 1)
            X[j,i] = layers[i][selected_keys[j]]
        end
    end
    return X
end

function StatsAPI.fit(MultivariateStats.Whitening, X::Vector{T}; samples::Int=10_000, kwargs...) where {T <: SimpleSDMLayers.SimpleSDMLayer}
    Y = SpeciesDistributionToolkit._partial_array_from_layers(X; samples=samples)
    return StatsAPI.fit(MultivariateStats.Whitening, Y; kwargs...)
end