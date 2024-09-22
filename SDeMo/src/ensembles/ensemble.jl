"""
    Ensemble

An heterogeneous ensemble model is defined as a vector of `SDM`s.
"""
mutable struct Ensemble
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