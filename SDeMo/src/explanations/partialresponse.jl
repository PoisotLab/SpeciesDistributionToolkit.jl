function _make_partialresponse_data(sdm::SDM, variable::Integer, npoints::Integer)
    target = LinRange(extrema(features(sdm, variable))..., npoints)
    nx = zeros(eltype(features(sdm)), size(features(sdm), 1), length(target))
    nx[variable, :] .= target
    return nx
end

function _make_partialresponse_data(sdm::SDM, variable::Integer)
    target = sort(unique(features(sdm, variable)))
    nx = zeros(eltype(features(sdm)), size(features(sdm), 1), length(target))
    nx[variable, :] .= target
    return nx
end

function _make_partialresponse_data(sdm::SDM, variable::Integer, values)
    nx = zeros(eltype(features(sdm)), size(features(sdm), 1), length(values))
    nx[variable, :] .= collect(values)
    return nx
end

function _fill_partialresponse_data!(nx, sdm::SDM, variable, inflated)
    for i in axes(nx, 1)
        if i != variable
            reducer = inflated ? rand([mean, median, maximum, minimum, rand]) : mean
            nx[i, :] .= reducer(features(sdm, i))
        end
    end
    return nx
end

"""
    partialresponse(sdm::SDM, i::Integer, args...; inflated::Bool, kwargs...)

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
function partialresponse(sdm::SDM, i::Integer, args...; inflated::Bool=false, kwargs...)
    nx = SDeMo._make_partialresponse_data(sdm, i, args...)
    SDeMo._fill_partialresponse_data!(nx, sdm, i, inflated)
    return (nx[i,:], predict(sdm, nx; kwargs...))
end

"""
    partialresponse(sdm::SDM, i::Integer, j::Integer, s::Tuple=(50, 50); inflated::Bool, kwargs...)

This method returns the partial response of applying the trained model to a
simulated dataset where all variables *except* `i` and `j` are set to their mean
value.

This function will return a grid corresponding to evenly spaced values of `i`
and `j`, the size of which is given by the last argument `s` (defaults to 50 ×
50).

All keyword arguments are passed to `predict`.
"""
function partialresponse(sdm::SDM, i::Integer, j::Integer, s::Tuple=(50, 50); inflated::Bool=false, kwargs...)
    irange = LinRange(extrema(features(sdm, i))..., s[1])
    jrange = LinRange(extrema(features(sdm, j))..., s[2])

    nx = zeros(eltype(features(sdm)), size(features(sdm), 1), length(irange)*length(jrange))

    nx[i,:] .= repeat(irange, outer=length(jrange))
    nx[j,:] .= repeat(jrange, inner=length(irange))

    for v in axes(nx, 1)
        if (v != i)&(v != j)
            reducer = inflated ? rand([mean, median, maximum, minimum, rand]) : mean
            nx[v,:] .= reducer(features(sdm, v))
        end
    end

    return (irange, jrange, reshape(predict(sdm, nx; kwargs...), s))
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
