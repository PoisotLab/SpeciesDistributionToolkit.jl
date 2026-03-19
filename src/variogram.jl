function _generate_point_pairs(L::SDMLayer, n::Integer)
    Es, Ns = eastings(L), northings(L)
    z = Tuple{Float64, Float64}[]

    for _ in Base.OneTo(n)
        s = rand(keys(L), 2)
        sᵢ = (Es[s[1].I[2]], Ns[s[1].I[1]])
        sⱼ = (Es[s[2].I[2]], Ns[s[2].I[1]])
        δ = Fauxcurrences._distancefunction(sᵢ, sⱼ)
        push!(z, (δ, abs(L[sᵢ...] - L[sⱼ...])))
    end
    return z
end

function variogram(pairs::Vector{Tuple{Float64, Float64}}, n::Integer; α::Float64 = 2.0)
    x = first.(pairs)
    y = last.(pairs)
    bins = LinRange(extrema(x)..., n + 1)
    X = zeros(n + 1)
    Y = zeros(n + 1)
    N = zeros(n + 1)
    for i in eachindex(bins)
        if i > 1
            vx = findall(s -> bins[i - 1] <= s <= bins[i], x)
            if !isnothing(vx)
                X[i - 1] = Statistics.mean(x[vx])
                Y[i - 1] = Statistics.mean(y[vx] .^ α) / 2
                N[i - 1] = length(vx)
            end
        end
    end
    val = findall(!iszero, N)
    return X[val], Y[val], N[val]
end

"""
    variogram(L::SDMLayer; samples::Integer=2000, bins::Integer=100; kwargs...)

Generates the raw data to look at an empirical semivariogram from a layer. This
method will draw `samples` pairs of points at random, then aggregate them in
`bins` bins.

This returns three vectors: the empirical center of the bin, the semivariance
within this bin, and the number of samples that compose this bin.
"""
function variogram(L::SDMLayer; samples::Integer = 2000, bins::Integer = 100, kwargs...)
    Z = _generate_point_pairs(L, samples)
    return variogram(Z, bins; kwargs...)
end

# Functions to fit
function __variogram_gaussian(sill, nugget, range)
    function __mod(h)
        unit = (1 - exp(-(3 * h * h) / (range * range)))
        return unit * (sill - nugget) + nugget
    end
    return __mod
end

function __variogram_spherical(sill, nugget, range)
    function __mod(h)
        if h > range
            return sill
        else
            unit = 1.5 * (h / range) - 0.5 * (h / range)^3
            return unit * (sill - nugget) + nugget
        end
    end
    return __mod
end

function __variogram_exponential(sill, nugget, range)
    function __mod(h)
        unit = (1 - exp(-(3 * h) / range))
        return unit * (sill - nugget) + nugget
    end
    return __mod
end

"""
    fitvariogram(x, y, n; family = :gaussian)

Fits a variogram of the given `family` based on data representing the central
bin distance `x`, the semivariogram `y`, and the sample size `n`. The data are
returned as a named tuple containing the `range`, the `sill`, the `nugget`, the
`error`, and the `model`. The model is a function that can be called on a given
distance to obtained the best fit variogram.

Possible values of `family` are `:gaussian` (default), `:spherical`, and
`:exponential`.
"""
function fitvariogram(x, y, n; family = :gaussian)

    # Parameters to check (this is a reasonable heuristic)
    range_sill = LinRange(0.0, 1.4, 40) .* maximum(y)
    range_nugget = LinRange(extrema(y[1:5])..., 40)
    range_range = LinRange(extrema(x)..., 40)

    error = Inf
    gen = __variogram_gaussian
    if family == :exponential
        gen = __variogram_exponential
    end
    if family == :spherical
        gen = __variogram_spherical
    end

    best = (first(range_sill), first(range_nugget), first(range_range))

    for S in range_sill
        for N in range_nugget
            for R in range_range
                f = gen(S, N, R)
                w = n ./ sum(n)
                test_error = sqrt(sum(w .* (f.(x) .- y) .^ 2.0))
                if test_error < error
                    error = test_error
                    best = (S, N, R)
                end
            end
        end
    end

    S, N, R = best
    return (sill = S, nugget = N, range = R, error = error, model = gen(S, N, R))
end

"""
    fitvariogram(L::SDMLayer; family::Symbol=:gaussian, kwargs...)

Fits the variogram based on a layer. The `kwargs...` are passed to `variogram`.
"""
function fitvariogram(L::SDMLayer; family::Symbol=:gaussian, kwargs...)
    vario = variogram(L; kwargs...)
    return fitvariogram(vario...; family=family)
    
end