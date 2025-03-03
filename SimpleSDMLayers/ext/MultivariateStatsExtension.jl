module MultivariateStatsExtension

using SimpleSDMLayers
using MultivariateStats

# Returns matrices for
function _X(L::Vector{<:SDMLayer})
    @assert SimpleSDMLayers._layers_are_compatible(L)
    return permutedims(hcat(values.(L)...))
end

function MultivariateStats.fit(::Type{MultivariateStats.PCA}, X::Vector{<:SimpleSDMLayers.SDMLayer}; kwargs...)
    return MultivariateStats.fit(PCA, _X(X); kwargs...)
end

function MultivariateStats.predict(M::MultivariateStats.PCA, X::Vector{<:SimpleSDMLayers.SDMLayer}; kwargs...)
    Y = MultivariateStats.predict(M, _X(X); kwargs...)
    L = [burnin(X[i], Y[i,:]) for i in axes(Y, 1)]
    return L
end

end