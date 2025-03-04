"""
    hyperparameters(::Type{<:Classifier}) = nothing

Returns the hyper-parameters for a type of classifier (defaults to nothing)
"""
hyperparameters(::Type{<:Classifier}) = nothing

"""
    hyperparameters(::Classifier) = nothing

Returns the hyper-parameters for a classifier (defaults to nothing)
"""
hyperparameters(::Classifier) = nothing

"""
    hyperparameters(::Type{<:Transformer}) = nothing

Returns the hyper-parameters for a type of transformer (defaults to nothing)
"""
hyperparameters(::Type{<:Transformer}) = nothing

"""
    hyperparameters(::Transformer) = nothing

Returns the hyper-parameters for a transformer (defaults to nothing)
"""
hyperparameters(::Transformer) = nothing

@testitem "The RawData transformer has no hyper-parameters" begin
    @test isnothing(hyperparameters(RawData))
end

@testitem "An instantiated RawData transformer has no hyper-parameters" begin
    @test isnothing(hyperparameters(RawData()))
end

@testitem "The BIOCLIM classifer has no hyper-parameters" begin
    @test isnothing(hyperparameters(BIOCLIM))
end

@testitem "An instantiated BIOCLIM classifier has no hyper-parameters" begin
    @test isnothing(hyperparameters(BIOCLIM()))
end