module MultivariateStatsExtension

using SimpleSDMLayers
using MultivariateStats

function MultivariateStats.fit(::Type{MultivariateStats.PCA}, X::Vector{<:SimpleSDMLayers.SDMLayer}; kwargs...)
    return MultivariateStats.fit(PCA, Matrix(X); kwargs...)
end

function MultivariateStats.predict(M::MultivariateStats.PCA, X::Vector{<:SimpleSDMLayers.SDMLayer}; kwargs...)
    Y = MultivariateStats.predict(M, Matrix(X); kwargs...)
    L = [burnin(X[i], Y[i,:]) for i in axes(Y, 1)]
    return L
end

function MultivariateStats.reconstruct(M::MultivariateStats.PCA, X::Vector{<:SimpleSDMLayers.SDMLayer}; kwargs...)
    Y = MultivariateStats.reconstruct(M, Matrix(X); kwargs...)
    L = [burnin(X[i], Y[i,:]) for i in axes(Y, 1)]
    return L
end

end