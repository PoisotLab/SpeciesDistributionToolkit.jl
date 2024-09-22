"""
    NaiveBayes

Naive Bayes Classifier

By default, upon training, the prior probability will be set to the prevalence
of the training data.
"""
Base.@kwdef mutable struct NaiveBayes <: Classifier
    presences::Vector{Normal} = Normal[]
    absences::Vector{Normal} = Normal[]
    prior::Float64 = 0.5
end
export NaiveBayes

Base.zero(::Type{NaiveBayes}) = 0.5

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

@testitem "We can declare a NBC SDM" begin
    X, y = SDeMo.__demodata()
    sdm = SDM(RawData(), NaiveBayes(), 0.5, X, y, 1:size(X,1))
    @test threshold(sdm) == 0.5
    @test variables(sdm) == 1:size(X, 1)
end

@testitem "We can train a NBC SDM" begin
    X, y = SDeMo.__demodata()
    sdm = SDM(RawData(), NaiveBayes(), 0.5, X, y, 1:size(X,1))
    train!(sdm)
    @test threshold(sdm) != 0.5
end

@testitem "We can train a NBC SDM with some indices only" begin
    X, y = SDeMo.__demodata()
    sdm = SDM(RawData(), NaiveBayes(), 0.5, X, y, 1:size(X,1))
    train!(sdm; training=rand(axes(X,2), 150))
    @test threshold(sdm) != 0.5
end

@testitem "We can train a NBC SDM without thresholding" begin
    X, y = SDeMo.__demodata()
    sdm = SDM(RawData(), NaiveBayes(), 0.5, X, y, 1:size(X,1))
    train!(sdm; threshold=false)
    @test threshold(sdm) == 0.5
end

@testitem "We can predict with a NBC SDM" begin
    X, y = SDeMo.__demodata()
    sdm = SDM(RawData(), NaiveBayes(), 0.5, X, y, 1:size(X,1))
    train!(sdm)
    @test eltype(predict(sdm)) <: Bool
    @test eltype(predict(sdm; threshold=false)) <: Float64
    @test length(predict(sdm, X[:,rand(axes(X, 2), 100)])) == 100
end

@testitem "We can get the confusion matrix of a trained NBC SDM" begin
    X, y = SDeMo.__demodata()
    sdm = SDM(RawData(), NaiveBayes(), 0.5, X, y, 1:size(X,1))
    train!(sdm)
    cm = ConfusionMatrix(sdm)
    @test sum(Matrix(cm)) == length(y)
end