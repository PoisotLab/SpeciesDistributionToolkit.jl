HasHyperParams = Union{<:Classifier, <:Transformer, <:AbstractSDM}

"""
    hyperparameters(::Type{<:HasHyperParams}) = nothing

Returns the hyper-parameters for a type of classifier or transformer
"""
hyperparameters(::Type{<:HasHyperParams}) = nothing

"""
    hyperparameters(::HasHyperParams, ::Symbol)

Returns the value for an hyper-parameter
"""
function hyperparameters(entity::T, hp::Symbol) where {T <: HasHyperParams}
    return hp in hyperparameters(T) ? getfield(entity, hp) : nothing
end

"""
    hyperparameters(::HasHyperParams)

Returns the hyper-parameters for a classifier or a transformer
"""
function hyperparameters(entity::T) where {T <: HasHyperParams}
    if isnothing(hyperparameters(T))
        return nothing
    end
    return Dict([hp => hyperparameters(entity, hp) for hp in hyperparameters(T)])
end

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

"""
    hyperparameters!(tr::HasHyperParams, hp::Symbol, val)

Sets the hyper-parameters for a transformer or a classifier
"""
function hyperparameters!(tr::T, hp::Symbol, val) where {T <: HasHyperParams}
    @assert hp in hyperparameters(T)
    @assert hp in fieldnames(T)
    setfield!(tr, hp, val)
    return tr
end
