module ClusteringExtension

    using SpeciesDistributionToolkit
    using Clustering
    
    function Clustering.kmeans(L::Vector{<:SDMLayer}, args...; kwargs...)
        @assert SimpleSDMLayers._layers_are_compatible(L)
        X = transpose(hcat(values.(L)...))
        return kmeans(X, args...; kwargs...)
    end

    function SDMLayer(result::Clustering.KmeansResult, template::SDMLayer)
        output = similar(template, Int64)
        C = assignments(result)
        @assert length(C) == count(template)
        output.grid[output.indices] .= C
        return output
    end

    function Clustering.fuzzy_cmeans(L::Vector{<:SDMLayer}, args...; kwargs...)
        @assert SimpleSDMLayers._layers_are_compatible(L)
        X = transpose(hcat(values.(L)...))
        return fuzzy_cmeans(X, args...; kwargs...)
    end

    function SDMLayer(result::Clustering.FuzzyCMeansResult, template::SDMLayer)
        n_centers = size(result.centers, 2)
        output = [similar(template, Float64) for _ in 1:n_centers]
        memberships = result.weights
        @assert size(memberships, 1) == count(template)
        for i in 1:n_centers
            output[i].grid[output[i].indices] .= memberships[:,i]
        end
        return output
    end

#=
using Revise
using SpeciesDistributionToolkit
using Clustering
using Statistics
using CairoMakie
spatial_extent = (left = 8.412, bottom = 41.325, right = 9.662, top = 43.060)
dataprovider = RasterData(CHELSA1, BioClim)
temperature = 0.1SDMLayer(dataprovider; layer = "BIO1", spatial_extent...)
precipitation = 1.0SDMLayer(dataprovider; layer = "BIO12", spatial_extent...)
L = [temperature, precipitation]
M = (L .- mean.(L)) ./ std.(L)
cl = kmeans(M, 10)
K = SDMLayer(cl, temperature)
fcl = fuzzy_cmeans(M, 3, 2)
F = SDMLayer(fcl, temperature)
=#

end