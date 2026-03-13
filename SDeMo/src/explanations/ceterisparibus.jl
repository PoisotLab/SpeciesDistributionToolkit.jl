"""
    ceterisparibus(model::T, instance::Integer, feature::Integer; bins=50, kwargs...)

TODO

All keyword arguments are passed to `predict`.
"""
function ceterisparibus(model::T, i::Integer, feature::Integer, args...; bins::Integer=50, kwargs...) where {T <: AbstractSDM}
    X = instance(model, i; strict = false)
    x = collect(LinRange(extrema(features(model, feature))..., bins))
    Y = permutedims(repeat(X', length(x)))
    Y[feature, :] .= x
    y = predict(model, Y; kwargs...)
    return (x, y)
end

"""
    ceterisparibus(model::T, instance::Integer, feature1::Integer, feature2::Integer; bins=50, kwargs...)

TODO

All keyword arguments are passed to `predict`.
"""
function ceterisparibus(model::T, i::Integer, feature1::Integer, feature2::Integer, args...; bins::Integer=50, kwargs...) where {T <: AbstractSDM}
    x1 = collect(LinRange(extrema(features(model, feature1))..., bins))
    x2 = collect(LinRange(extrema(features(model, feature2))..., bins))
    Y = zeros(bins, bins)
    X = instance(model, i; strict = false)
    for i in eachindex(x1)
        X[f1] = x1[i]
        for j in eachindex(x2)
            X[f2] = x2[j]
            Y[i,j] = predict(model, X; kwargs...)
        end
    end
    return (x1, x2, Y)
end
