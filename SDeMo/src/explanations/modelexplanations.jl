abstract type ModelExplanation end

struct PartialResponse <: ModelExplanation end
struct PartialDependence <: ModelExplanation end
struct CeterisParibus <: ModelExplanation end

# Version with two variables

function explainmodel(
    ::Type{E},
    model::T,
    variable::Tuple{Integer, Integer},
    n::Integer;
    kwargs...,
) where {E <: ModelExplanation, T <: AbstractSDM}
    x = collect(LinRange(extrema(features(model, variable[1]))..., n))
    y = collect(LinRange(extrema(features(model, variable[2]))..., n))
    return explainmodel(E, model, variable, x, y; kwargs...)
end

function explainmodel(
    ::Type{E},
    model::T,
    variable::Tuple{Integer, Integer};
    kwargs...,
) where {E <: ModelExplanation, T <: AbstractSDM}
    x = sort(unique(features(model, variable[1])))
    y = sort(unique(features(model, variable[2])))
    return explainmodel(E, model, variable, x, y; kwargs...)
end

# Version with one variable

function explainmodel(
    ::Type{E},
    model::T,
    variable::Integer,
    n::Integer;
    kwargs...,
) where {E <: ModelExplanation, T <: AbstractSDM}
    x = collect(LinRange(extrema(features(model, variable))..., n))
    return explainmodel(E, model, variable, x; kwargs...)
end

function explainmodel(
    ::Type{E},
    model::T,
    variable::Integer;
    kwargs...,
) where {E <: ModelExplanation, T <: AbstractSDM}
    x = sort(unique(features(model, variable)))
    return explainmodel(E, model, variable, x; kwargs...)
end

# Partial response

function explainmodel(
    ::Type{PartialResponse},
    model::T,
    variable::Integer,
    x::Vector{<:Real};
    inflated::Bool = false,
    kwargs...,
) where {T <: AbstractSDM}
    X = zeros(eltype(features(model)), size(features(model), 1), length(x))
    μ = vec(mean(features(model); dims = 2))
    for v in axes(X, 1)
        if v != variable
            X[v, :] .= inflated ? rand(features(model, v)) : μ[v]
        else
            X[v, :] .= x
        end
    end
    return (x, predict(model, X; kwargs...))
end

function explainmodel(
    ::Type{PartialResponse},
    model::T,
    variable::Tuple{Integer, Integer},
    x::Vector{<:Real},
    y::Vector{<:Real};
    inflated::Bool = false,
    kwargs...,
) where {T <: AbstractSDM}
    X = zeros(eltype(features(model)), size(features(model), 1), length(x) * length(y))
    X[variable[1], :] .= repeat(x; outer = length(y))
    X[variable[2], :] .= repeat(y; inner = length(x))
    μ = vec(mean(features(model); dims = 2))
    for v in axes(X, 1)
        if !(v in variable)
            X[v, :] .= inflated ? rand(features(model, v)) : μ[v]
        end
    end
    return (x, y, reshape(predict(model, X; kwargs...), (length(x), length(y))))
end

# Ceteris Paribus

"""
    explainmodel()

1D CP plot with `variable` and `instance`
"""
function explainmodel(
    ::Type{CeterisParibus},
    model::T,
    variable::Integer,
    index::Integer,
    x::Vector{<:Real};
    kwargs...,
) where {T <: AbstractSDM}
    X = zeros(eltype(features(model)), size(features(model), 1), length(x))
    for v in axes(X, 2)
        X[:, v] .= instance(model, index; strict = false)
    end
    X[variable, :] .= x
    return (x, predict(model, X; kwargs...))
end

function explainmodel(
    ::Type{CeterisParibus},
    model::T,
    variable::Tuple{Integer, Integer},
    index::Integer,
    x::Vector{<:Real},
    y::Vector{<:Real};
    kwargs...,
) where {T <: AbstractSDM}
    X = zeros(eltype(features(model)), size(features(model), 1), length(x)*length(y))
    for v in axes(X, 2)
        X[:, v] .= instance(model, index; strict = false)
    end
    X[variable[1], :] .= repeat(x; outer = length(y))
    X[variable[2], :] .= repeat(y; inner = length(x))
    return (x, y, reshape(predict(model, X; kwargs...), (length(x), length(y))))
end

function explainmodel(
    ::Type{CeterisParibus},
    model::T,
    variable::Integer,
    index::Integer,
    n::Integer;
    kwargs...,
) where {T <: AbstractSDM}
    x = collect(LinRange(extrema(features(model, variable))..., n))
    return explainmodel(CeterisParibus, model, variable, index, x; kwargs...)
end

function explainmodel(
    ::Type{CeterisParibus},
    model::T,
    variable::Integer,
    index::Integer;
    kwargs...,
) where {T <: AbstractSDM}
    x = sort(unique(features(model, variable)))
    return explainmodel(CeterisParibus, model, variable, index, x; kwargs...)
end


function explainmodel(
    ::Type{CeterisParibus},
    model::T,
    variable::Tuple{Integer, Integer},
    index::Integer,
    n::Integer;
    kwargs...,
) where {T <: AbstractSDM}
    x = collect(LinRange(extrema(features(model, variable[1]))..., n))
    y = collect(LinRange(extrema(features(model, variable[2]))..., n))
    return explainmodel(CeterisParibus, model, variable, index, x, y; kwargs...)
end

function explainmodel(
    ::Type{CeterisParibus},
    model::T,
    variable::Tuple{Integer, Integer},
    index::Integer;
    kwargs...,
) where {T <: AbstractSDM}
    x = sort(unique(features(model, variable[1])))
    y = sort(unique(features(model, variable[2])))
    return explainmodel(CeterisParibus, model, variable, index, x, y; kwargs...)
end


# Partial dependence

"""
    explainmodel()

PDP plot with `variable` and `instance`
"""
function explainmodel(
    ::Type{PartialDependence},
    model::T,
    variable::Integer,
    x::Vector{<:Real};
    kwargs...,
) where {T <: AbstractSDM}
    CPs = [
        last(explainmodel(CeterisParibus, model, variable, i, x; kwargs...))
        for i in eachindex(labels(model))
    ]
    y = reduce(.+, CPs) ./ length(CPs)
    return (x, y)
end

function explainmodel(
    ::Type{PartialDependence},
    model::T,
    variable::Tuple{Integer, Integer},
    x::Vector{<:Real},
    y::Vector{<:Real};
    kwargs...,
) where {T <: AbstractSDM}
    CPs = [
        last(explainmodel(CeterisParibus, model, variable, i, x, y; kwargs...))
        for i in eachindex(labels(model))
    ]
    z = reduce(.+, CPs) ./ length(CPs)
    return (x, y, z)
end

@testitem "We can do model explanations with a number of points" begin
    model = SDM(RawData, NaiveBayes, SDeMo.__demodata()...)
    variables!(model, [1, 12])
    train!(model)

    x, y = explainmodel(PartialResponse, model, 1, 10)
    @test length(x) == 10
    @test first(x) == minimum(features(model, 1))
    @test last(x) == maximum(features(model, 1))
end

@testitem "We can do model explanations with all features sorted" begin
    model = SDM(RawData, NaiveBayes, SDeMo.__demodata()...)
    variables!(model, [1, 12])
    train!(model)

    x, y = explainmodel(PartialResponse, model, 1)
    @test length(x) == length(unique(features(model, 1)))
    @test first(x) == minimum(features(model, 1))
    @test last(x) == maximum(features(model, 1))
end

@testitem "We can do model explanations with given points" begin
    model = SDM(RawData, NaiveBayes, SDeMo.__demodata()...)
    variables!(model, [1, 12])
    train!(model)

    x, y = explainmodel(PartialResponse, model, 1, [10., 12., 14.])
    @test length(x) == 3
    @test first(x) == 10.
    @test last(x) == 14.
end