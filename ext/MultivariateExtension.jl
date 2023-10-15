module MultivariateExtension

using SpeciesDistributionToolkit
using MultivariateStats
using StatsAPI

# These types have a fit method
types_to_fit = [:PCA, :PPCA, :KernelPCA, :Whitening, :MDS, :MetricMDS]

# These types have a transform method
types_to_transform = [:Whitening]

# These types have a predict method
types_to_predict = [:PCA, :PPCA, :KernelPCA, :MDS, :MetricMDS]

for tf in types_to_fit
    eval(
        quote
            function StatsAPI.fit(::Type{MultivariateStats.$tf}, X::Vector{T}; kwargs...) where {T <: SimpleSDMLayers.SimpleSDMLayer}
                @assert SimpleSDMLayers._layers_are_compatible(X)
                return StatsAPI.fit(MultivariateStats.$tf, Array(X); kwargs...)
            end
        end
    )
end

for tf in types_to_transform
    eval(
        quote
            function MultivariateStats.transform(f::MultivariateStats.$tf, X::Vector{T}; kwargs...) where {T <: SimpleSDMLayers.SimpleSDMLayer}
                @assert SimpleSDMLayers._layers_are_compatible(X)
                D = MultivariateStats.transform(f, Array(X); kwargs...)
                O = [similar(X[1], eltype(D)) for i in 1:length(X)]
                for i in axes(O, 1)
                    for (j, k) in enumerate(keys(O[i]))
                        O[i][k] = D[i, j]
                    end
                end
                return O
            end
        end
    )
end

for tf in types_to_predict
    eval(
        quote
            function StatsAPI.predict(f::MultivariateStats.$tf, X::Vector{T}; kwargs...) where {T <: SimpleSDMLayers.SimpleSDMLayer}
                @assert SimpleSDMLayers._layers_are_compatible(X)
                D = StatsAPI.predict(f, Array(X); kwargs...)
                O = [similar(X[1], eltype(D)) for i in 1:MultivariateStats.outdim(M)]
                for i in axes(O, 1)
                    for (j, k) in enumerate(keys(O[i]))
                        O[i][k] = D[i, j]
                    end
                end
                return O
            end
        end
    )
end

end