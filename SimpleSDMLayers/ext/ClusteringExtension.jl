module ClusteringExtension

    using SimpleSDMLayers
    using Clustering
    
    function Clustering.kmeans(L::Vector{<:SDMLayer}, args...; kwargs...)
        @assert SimpleSDMLayers._layers_are_compatible(L)
        X = transpose(hcat(values.(L)...))
        return kmeans(X, args...; kwargs...)
    end

    function SDMLayer(result::Clustering.KmeansResult, template::SDMLayer)
        C = assignments(result)
        @assert length(C) == count(template)
        return burnin(template, C)
    end

    function Clustering.fuzzy_cmeans(L::Vector{<:SDMLayer}, args...; kwargs...)
        @assert SimpleSDMLayers._layers_are_compatible(L)
        X = transpose(hcat(values.(L)...))
        return fuzzy_cmeans(X, args...; kwargs...)
    end

    function SDMLayer(result::Clustering.FuzzyCMeansResult, template::SDMLayer)
        @assert size(result.weights, 1) == count(template)
        return [burnin(template, result.weights[:,i]) for i in 1:size(result.centers, 2)]
    end

end