"""
    ModelExplanation

This abstract type collects the various types that can be used to generate model
explanations. This is currently `PartialResponse`, `CeterisParibus`, and
`PartialDependence`.
"""
abstract type ModelExplanation end

"""
    PartialResponse

This type is used as the first argument of `explainmodel` to generate a partial
response curve. Using the `inflated` Boolean keyword of `explainmodel` will
generate the inflated partial response.
"""
struct PartialResponse <: ModelExplanation end

"""
    PartialDependence

This type is used as the first argument of `explainmodel` to generate data for
the partial dependence plot, which is the mean of all the individual conditional
expectations, themselves generated with `CeterisParibus`.

This type can also be used as the first argument of `featureimportance`, to
measure the variation within the partial dependence curve as a proxy for the
importance of a feature.
"""
struct PartialDependence <: ModelExplanation end

"""
    CeterisParibus

This type is used as the first argument of `explainmodel` to generate data the
_ceteris paribus_ curve for a single observation. The _ceteris paribus_ response
is measured by maintaining the value of all other variables, and measuring the
model prediction on all possible values of the variable of interest. The
superposition of all _ceteris paribus_ curves is the individual conditional
expectation plot.
"""
struct CeterisParibus <: ModelExplanation end

"""
    ShapleyMC

This type is used as the first argument of `explainmodel` to generate an
explanation based on the Monte-Carlon approximation of Shapley values.

This type can also be used as the first argument of `featureimportance`, to
measure the variation based on the absolute change created by each variable.
"""
struct ShapleyMC <: ModelExplanation end

"""
    explainmodel(ModelExplanation, model, variable::Tuple{Int,Int}, n::Int; kwargs...)

Generates an `n` by `n` grid to measure the _surface_ representing the joint
explanation for two variables. `ModelExplanation` is any type that can be used
as the first argument for `explainmodel`. Other `kwargs...` are passed to
`explainmodel`.
"""
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

"""
    explainmodel(ModelExplanation, model, variable::Tuple{Int,Int}, n::Int; kwargs...)

Generates a grid to measure the _surface_ representing the joint explanation for
two variables, where the entries of the grid are the sorted unique values for
the pair of variables to consider. `ModelExplanation` is any type that can be
used as the first argument for `explainmodel`. Other `kwargs...` are passed to
`explainmodel`.
"""
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

"""
    explainmodel(ModelExplanation, model, variable::Int, n::Int; kwargs...)

Generates `n` equally spaced values over the range of values for the variable of
interest, on which the requested explanation will be measured. `ModelExplanation`
is any type that can be used as the first argument for `explainmodel`. Other
`kwargs...` are passed to `explainmodel`.
"""
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

"""
    explainmodel(ModelExplanation, model, variable::Int, n::Int; kwargs...)

Sorts the unique values for the variable of interest, on which the requested
explanation will be measured. `ModelExplanation` is any type that can be used as
the first argument for `explainmodel`. Other `kwargs...` are passed to
`explainmodel`.
"""
function explainmodel(
    ::Type{E},
    model::T,
    variable::Integer;
    kwargs...,
) where {E <: ModelExplanation, T <: AbstractSDM}
    x = sort(unique(features(model, variable)))
    return explainmodel(E, model, variable, x; kwargs...)
end

"""
    explainmodel(PartialResponse, model, variable, x; inflated=false, kwargs...)

Returns the partial response of the model for a given variable, which is
evaluated at all values given by `x`. The partial response is the prediction
made using the given value of `variable`, when all other variables take the
average value. When `inflated` is true, the response is measured against a
randomly sampled value in the entire range of possible values for the other
variables.

The result is returned as a tuple `x, response`.

All other `kwargs...` are passed to `predict`.
"""
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

"""
    explainmodel(PartialResponse, model, variable, x, y; inflated=false, kwargs...)

Returns the partial response of the model for a given pair of `variable` given
as a tuple, which are evaluated at all values given by vectors `x` and `y`.

The result is returned as a tuple `x, y, response`.

All other `kwargs...` are passed to `predict`.
"""
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

"""
    explainmodel(CeterisParibus, model, variable, index, x; kwargs...)

Returns the _ceteris paribus_ explanation for a given `instance` (given as an
index: the _n_-th instance of the model) and a given `variable`, whose values
are evaluated at all positions in the vector `x`.

Additional `kwargs...` are passed to `predict`.

This function returns a tuple `x, response`.
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

"""
    explainmodel(CeterisParibus, model, variable, index, x, y; kwargs...)

Returns the _ceteris paribus_ explanation for a given `instance` (given as an
index: the _n_-th instance of the model) and a given `variable` pair, whose
values are evaluated at all positions in the vectors `x` and `y.

Additional `kwargs...` are passed to `predict`.

This function returns a tuple `x, y, response`, where the response is a matrix.
"""
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

"""
    explainmodel(CeterisParibus, model, variable, index, n; kwargs...)

Returns the _ceteris paribus_ explanation for a given `instance` (given as an
index: the _n_-th instance of the model) and a given `variable`, whose values
are evaluated at `n` equally spaced positions across the range of the variable
in the training data.

Additional `kwargs...` are passed to `predict`.

This function returns a tuple `x, response`.
"""
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

"""
    explainmodel(CeterisParibus, model, variable, index; kwargs...)

Returns the _ceteris paribus_ explanation for a given `instance` (given as an
index: the _n_-th instance of the model) and a given `variable`, whose values
are evaluated at all the (sorted) unique values of the variable in the training
data.

Additional `kwargs...` are passed to `predict`.

This function returns a tuple `x, response`.
"""
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

"""
    explainmodel(CeterisParibus, model, variable::Tuple{Int,Int}, index, n; kwargs...)

Returns the _ceteris paribus_ explanation for a given `instance` (given as an
index: the _n_-th instance of the model) and a given `variable` pair, whose
values are evaluated at `n` evenly spaced position across the range of both
variables.

Additional `kwargs...` are passed to `predict`.

This function returns a tuple `x, y, response`, where the response is a matrix.
"""
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

"""
    explainmodel(CeterisParibus, model, variable::Tuple{Int,Int}, index; kwargs...)

Returns the _ceteris paribus_ explanation for a given `instance` (given as an
index: the _n_-th instance of the model) and a given `variable` pair, whose
values are evaluated at the (sorted) unique pairs of both variables.

Additional `kwargs...` are passed to `predict`.

This function returns a tuple `x, y, response`, where the response is a matrix.
"""
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

"""
    explainmodel(PartialDependence, model, variable, x; kwargs...)

Returns the partial dependence curve of the model for a given variable, which is
evaluated at all values given by `x`.

The result is returned as a tuple `x, response`.

All other `kwargs...` are passed to `predict`.
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

"""
    explainmodel(PartialDependence, model, variable::Tuple{Int, Int}, x, y; kwargs...)

Returns the partial dependence curve of the model for a given pair of variables,
which is evaluated at all values given by `x` and `y`.

The result is returned as a tuple `x, y, response`.

All other `kwargs...` are passed to `predict`.
"""
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

@testitem "We can measure inflated partial responses" begin
    model = SDM(RawData, NaiveBayes, SDeMo.__demodata()...)
    variables!(model, [1, 12])
    train!(model)

    x, y = explainmodel(PartialResponse, model, 1; inflated=true)
    @test first(x) == minimum(features(model, 1))
    @test last(x) == maximum(features(model, 1))
end

@testitem "We can measure partial responses without thresholding" begin
    model = SDM(RawData, NaiveBayes, SDeMo.__demodata()...)
    variables!(model, [1, 12])
    train!(model)

    x, y = explainmodel(PartialResponse, model, 1; inflated=false, threshold=false)
    @test first(x) == minimum(features(model, 1))
    @test last(x) == maximum(features(model, 1))
end

"""
    explainmodel(ShapleyMC, model, variable::Int; kwargs...)

Returns the Shapley values (approximation) for the given variable. All other
arguments are passed to `predict`.

The result is returned as a tuple `feature, explanation`.
"""
function explainmodel(::Type{ShapleyMC}, model::T, variable::Int; kwargs...) where {T <: AbstractSDM}
    return (features(model, variable), explain(model, variable; kwargs...))
end

"""
    explainmodel(ShapleyMC, model, variable::Int, index::Int; kwargs...)

Returns the Shapley values (approximation) for the given variable for the given
`index` observation. All other arguments are passed to `predict`.

The result is returned as a tuple `feature, explanation`.
"""
function explainmodel(::Type{ShapleyMC}, model::T, variable::Int, index::Integer; kwargs...) where {T <: AbstractSDM}
    return (features(model, variable)[index], explain(model, variable; observation=index, kwargs...))
end

"""
    explainmodel(ShapleyMC, model, variable::Int, X::Matrix; kwargs...)

Returns the Shapley values (approximation) for the given feature matrix `X`.
"""
function explainmodel(::Type{ShapleyMC}, model::T, variable::Int, X::Matrix; kwargs...) where {T <: AbstractSDM}
    return (X[variable, :], explain(model, variable; instances=X, kwargs...))
end

@testitem "We can get the Shapley values for a single instance" begin
    model = SDM(RawData, NaiveBayes, SDeMo.__demodata()...)
    variables!(model, [1, 12])
    train!(model)

    @test first(explainmodel(ShapleyMC, model, 1, 1)) == features(model, 1)[1]

    @test last(explainmodel(ShapleyMC, model, 1, 1)) != 0.0
    @test last(explainmodel(ShapleyMC, model, 2, 1)) ≈ 0.0
    @test last(explainmodel(ShapleyMC, model, 12, 1)) != 0.0
end

@testitem "We can get the Shapley values for all training instances" begin
    model = SDM(RawData, NaiveBayes, SDeMo.__demodata()...)
    variables!(model, [1, 12])
    train!(model)

    @test length(last(explainmodel(ShapleyMC, model, 1))) == length(labels(model))
    @test length(last(explainmodel(ShapleyMC, model, 2))) == length(labels(model))
end

@testitem "We can get the Shapley values for another instance matrix" begin
    model = SDM(RawData, NaiveBayes, SDeMo.__demodata()...)
    variables!(model, [1, 12])
    train!(model)

    n = 15
    v, e = explainmodel(ShapleyMC, model, 1, features(model)[:, 1:n])

    @test v[1] == features(model, 1)[1]
    @test v[n] == features(model, 1)[n]
    @test length(v) == length(e)
    @test length(e) == n
end