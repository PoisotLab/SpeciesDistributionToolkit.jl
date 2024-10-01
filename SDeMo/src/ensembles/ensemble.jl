"""
    Ensemble

An heterogeneous ensemble model is defined as a vector of `SDM`s.
"""
mutable struct Ensemble <: AbstractEnsembleSDM
    models::Vector{<:SDM}
end

Ensemble(m::T...) where {T <: SDM} = Ensemble([m...])

@testitem "We can setup an ensemble" begin
    X, y = SDeMo.__demodata()
    m1 = SDM(MultivariateTransform{PCA}, NaiveBayes, X, y)
    m2 = SDM(ZScore, BIOCLIM, X, y)
    ens = Ensemble([m1, m2])
    @test ens isa Ensemble
end

@testitem "We can setup an ensemble the other way" begin
    X, y = SDeMo.__demodata()
    m1 = SDM(MultivariateTransform{PCA}, NaiveBayes, X, y)
    m2 = SDM(ZScore, BIOCLIM, X, y)
    ens = Ensemble(m1, m2)
    @test ens isa Ensemble
end

Base.push!(ens::Ensemble, model::SDM) = push!(ens.models, model)
Base.pop!(ens::Ensemble) = pop!(ens.models)
Base.popat!(ens::Ensemble, i) = popat!(ens.models, i)
Base.deleteat!(ens::Ensemble, i) = deleteat!(ens.models, i)

@testitem "We can add and remove models from an ensemble" begin
    X, y = SDeMo.__demodata()
    m1 = SDM(MultivariateTransform{PCA}, NaiveBayes, X, y)
    ens = Ensemble([m1])
    @test ens isa Ensemble
    m2 = SDM(ZScore, BIOCLIM, X, y)
    push!(ens, m2)
    @test length(ens.models) == 2
    outmod = popat!(ens, 1)
    @test outmod isa SDM
    @test length(ens.models) == 1
end
