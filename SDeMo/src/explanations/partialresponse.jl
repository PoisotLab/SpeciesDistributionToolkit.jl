function _make_partialresponse_data(model::T, variable::Integer, npoints::Integer) where {T <: AbstractSDM}
    target = LinRange(extrema(features(model, variable))..., npoints)
    nx = zeros(eltype(features(model)), size(features(model), 1), length(target))
    nx[variable, :] .= target
    return nx
end

function _make_partialresponse_data(model::T, variable::Integer) where {T <: AbstractSDM}
    target = sort(unique(features(model, variable)))
    nx = zeros(eltype(features(model)), size(features(model), 1), length(target))
    nx[variable, :] .= target
    return nx
end

function _make_partialresponse_data(model::T, variable::Integer, values) where {T <: AbstractSDM}
    nx = zeros(eltype(features(model)), size(features(model), 1), length(values))
    nx[variable, :] .= collect(values)
    return nx
end

function _fill_partialresponse_data!(nx, model::T, variable, inflated) where {T <: AbstractSDM}
    for i in axes(nx, 1)
        if i != variable
            reducer = inflated ? rand([mean, median, maximum, minimum, rand]) : mean
            nx[i, :] .= reducer(features(model, i))
        end
    end
    return nx
end

"""
    partialresponse(model::T, i::Integer, args...; inflated::Bool, kwargs...)

This method returns the partial response of applying the trained model to a
simulated dataset where all variables *except* `i` are set to their mean value.
The `inflated` keywork, when set to `true`, will randomize the function used to
aggregate the other variables, in which case this method needs to be ran
multiple times.

The different arguments that can follow the variable position are

- nothing, where the unique values for the `i`-th variable are used (sorted)
- a number, in which point that many evenly spaced points within the range of
  the variable are used
- an array, in which case each value of this array is evaluated

All keyword arguments are passed to `predict`.
"""
function partialresponse(model::T, i::Integer, args...; inflated::Bool=false, kwargs...) where {T <: AbstractSDM}
    nx = SDeMo._make_partialresponse_data(model, i, args...)
    SDeMo._fill_partialresponse_data!(nx, model, i, inflated)
    return (nx[i,:], predict(model, nx; kwargs...))
end

"""
    partialresponse(model::T, i::Integer, j::Integer, s::Tuple=(50, 50); inflated::Bool, kwargs...)

This method returns the partial response of applying the trained model to a
simulated dataset where all variables *except* `i` and `j` are set to their mean
value.

This function will return a grid corresponding to evenly spaced values of `i`
and `j`, the size of which is given by the last argument `s` (defaults to 50 ×
50).

All keyword arguments are passed to `predict`.
"""
function partialresponse(model::T, i::Integer, j::Integer, s::Tuple=(50, 50); inflated::Bool=false, kwargs...) where {T <: AbstractSDM}
    irange = LinRange(extrema(features(model, i))..., s[1])
    jrange = LinRange(extrema(features(model, j))..., s[2])

    nx = zeros(eltype(features(model)), size(features(model), 1), length(irange)*length(jrange))

    nx[i,:] .= repeat(irange, outer=length(jrange))
    nx[j,:] .= repeat(jrange, inner=length(irange))

    for v in axes(nx, 1)
        if (v != i)&(v != j)
            reducer = inflated ? rand([mean, median, maximum, minimum, rand]) : mean
            nx[v,:] .= reducer(features(model, v))
        end
    end

    return (irange, jrange, reshape(predict(model, nx; kwargs...), s))
end

@testitem "We can get partial responses for a model" begin
    X, y = SDeMo.__demodata()
    model = SDM(MultivariateTransform{PCA}, NaiveBayes, X, y)
    train!(model)
    pr = partialresponse(model, 1)
    @test eltype(pr[2]) <: Bool
end

@testitem "We can get inflated partial responses for a model" begin
    X, y = SDeMo.__demodata()
    model = SDM(MultivariateTransform{PCA}, NaiveBayes, X, y)
    train!(model)
    pr = partialresponse(model, 1; inflated=true)
    @test eltype(pr[2]) <: Bool
end

@testitem "We can get inflated partial responses for an ensemble" begin
    X, y = SDeMo.__demodata()
    model = Bagging(SDM(MultivariateTransform{PCA}, NaiveBayes, X, y), 5)
    train!(model)
    pr = partialresponse(model, 1; inflated=true, threshold=false)
    @test eltype(pr[2]) <: Float64
end