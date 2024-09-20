"""
    NaiveBayes

Naive Bayes Classifier
"""
Base.@kwdef mutable struct NaiveBayes <: Classifier
    presences::Vector{Normal} = Normal[]
    absences::Vector{Normal} = Normal[]
    prior::Float64 = 0.5
end
export NaiveBayes

function train!(
    nbc::NaiveBayes,
    y::Vector{Bool},
    X::Matrix{T};
    prior = nothing,
) where {T <: Number}
    nbc.prior = isnothing(prior) ? mean(y) : 0.5 # We set the P(+) as the prevalence if it is not specified
    X₊ = X[:, findall(y)]
    X₋ = X[:, findall(.!y)]
    nbc.presences = vec(mapslices(x -> Normal(mean(x), std(x)), X₊; dims = 2))
    nbc.absences = vec(mapslices(x -> Normal(mean(x), std(x)), X₋; dims = 2))
    return nbc
end

function StatsAPI.predict(nbc::NaiveBayes, x::Vector{T}) where {T <: Number}
    p₊ = prod(pdf.(nbc.presences, x))
    p₋ = prod(pdf.(nbc.absences, x))
    pₓ = nbc.prior * p₊ + (1.0 - nbc.prior) * p₋
    return (p₊ * nbc.prior) / pₓ
end

function StatsAPI.predict(nbc::NaiveBayes, X::Matrix{T}) where {T <: Number}
    return vec(mapslices(x -> predict(nbc, x), X; dims = 1))
end
