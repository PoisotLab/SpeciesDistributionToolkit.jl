function _generate_point_pairs(occ::AbstractOccurrenceCollection, n::Integer)
    z = Tuple{Float64, Float64}[]

    xy = place(occ)
    for _ in Base.OneTo(n)
        s = rand(eachindex(xy), 2)
        sᵢ = xy[s[1]]
        sⱼ = xy[s[2]]
        Lᵢ = presence(occ)[s[1]]
        Lⱼ = presence(occ)[s[2]]
        δ = Fauxcurrences._distancefunction(sᵢ, sⱼ)
        push!(z, (δ, abs(Lᵢ - Lⱼ)))
    end
    return z
end

function _generate_point_pairs(model::AbstractSDM, n::Integer, v::Integer)
    z = Tuple{Float64, Float64}[]

    xy = place(model)
    for _ in Base.OneTo(n)
        s = rand(eachindex(xy), 2)
        sᵢ = xy[s[1]]
        sⱼ = xy[s[2]]
        Lᵢ = features(model, v)[s[1]]
        Lⱼ = features(model, v)[s[2]]
        δ = Fauxcurrences._distancefunction(sᵢ, sⱼ)
        push!(z, (δ, abs(Lᵢ - Lⱼ)))
    end
    return z
end

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

function variogram(
    pairs::Vector{Tuple{Float64, Float64}},
    h::Float64,
    w::Float64;
    α::Float64 = 2.0,
)
    x = first.(pairs)
    y = last.(pairs)
    bins = collect((minimum(x) + h / 2):w:(maximum(x) - h / 2))
    
    X = zeros(length(bins))
    Y = zeros(length(bins))
    N = zeros(length(bins))
    for i in eachindex(bins)
        vx = findall(s -> bins[i]-h/2 <= s <= bins[i]+h/2, x)
        if !isnothing(vx)
            X[i] = Statistics.mean(x[vx])
            Y[i] = Statistics.mean(y[vx] .^ α) / 2
            N[i] = length(vx)
        end
    end
    val = findall(!iszero, N)
    return X[val], Y[val], N[val]
end

"""
    variogram(L::SDMLayer; samples::Integer=2000, bins::Integer=100; kwargs...)

Generates the raw data to look at an empirical semivariogram from a layer with
numerical values. This method will generate bins that are `width` kilometers
wide by drawing pairs of points at random, and each bin will be shifted by
`shift` kilometers.

This returns three vectors: the empirical center of the bin, the semivariance
within this bin, and the number of samples that compose this bin.
"""
function variogram(L::SDMLayer; width::Float64 = 10., shift::Float64=1.0, kwargs...)
    bb = boundingbox(L)
    # Estimate of the distance for the number of samples is the largest of height/width

    Lh = Fauxcurrences._distancefunction((bb.left, bb.bottom), (bb.left, bb.top))
    Lw = Fauxcurrences._distancefunction((bb.left, bb.bottom), (bb.right, bb.bottom))
    Ls = max(Lh, Lw)

    # We would like to get 30 samples per bin if possible, but if not that's cool too
    samples = ceil(Int, (Ls / width) * 30)

    Z = _generate_point_pairs(L, samples)
    return variogram(Z, width, shift; kwargs...)
end

"""
    variogram(model::AbstractSDM; variable::Int, samples::Integer=2000, bins::Integer=100; kwargs...)

Generates the raw data to look at an empirical semivariogram from a model, for a
given `variable` (keyword, defaults to the first variable in the model). This
method will generate bins that are `width` kilometers wide by drawing pairs of
points at random, and each bin will be shifted by `shift` kilometers.

This returns three vectors: the empirical center of the bin, the semivariance
within this bin, and the number of samples that compose this bin.
"""
function variogram(model::AbstractSDM; variable::Int=first(variables(model)), width::Float64 = 10., shift::Float64=1.0, kwargs...)
    @assert isgeoreferenced(model)
    bb = boundingbox(elements(model))
    # Estimate of the distance for the number of samples is the largest of height/width

    Lh = Fauxcurrences._distancefunction((bb.left, bb.bottom), (bb.left, bb.top))
    Lw = Fauxcurrences._distancefunction((bb.left, bb.bottom), (bb.right, bb.bottom))
    Ls = max(Lh, Lw)

    # We would like to get 30 samples per bin if possible, but if not that's cool too
    samples = ceil(Int, (Ls / width) * 30)

    Z = _generate_point_pairs(model, samples, variable)
    return variogram(Z, width, shift; kwargs...)
end


"""
    variogram(occ::AbstractOccurrenceCollection; width::Float64 = 10., shift::Float64=1.0, kwargs...)

Generates the raw data to look at an empirical semivariogram from a collection
of occurrences. This method will generate bins that are `width` kilometers wide
by drawing pairs of points at random, and each bin will be shifted by `shift`
kilometers.

This returns three vectors: the empirical center of the bin, the semivariance
within this bin, and the number of samples that compose this bin.
"""
function variogram(occ::AbstractOccurrenceCollection; width::Float64 = 10., shift::Float64=1.0, kwargs...)
    bb = boundingbox(occ)

    # Estimate of the distance for the number of samples is the largest of height/width
    Lh = Fauxcurrences._distancefunction((bb.left, bb.bottom), (bb.left, bb.top))
    Lw = Fauxcurrences._distancefunction((bb.left, bb.bottom), (bb.right, bb.bottom))
    Ls = max(Lh, Lw)

    # We would like to get 30 samples per bin if possible, but if not that's cool too
    samples = ceil(Int, (Ls / width) * 30)

    Z = _generate_point_pairs(occ, samples)
    return variogram(Z, width, shift; kwargs...)
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

function __variogram_cubic(sill, nugget, range)
    function __mod(h)
        coeffs = [7, -35/4, -7/2, -3/4]
        expos = [2, 3, 5, 7]
        unit = sum([coeffs[i]*(h/range)^expos[i] for i in eachindex(coeffs)])
        return unit * (sill - nugget) + nugget
    end
    return __mod
end

function __variogram_hyperbolic(sill, nugget, range)
    function __mod(h)
        δ = sqrt(20) - 1 
        unit = 1 - 1 / (1 + (δ * h) / range)
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
distance to obtain the best fit variogram.

Possible values of `family` are `:gaussian` (default), `:spherical`, and
`:exponential`.

Values are optimized using the Nelder-Mead algorithm with `samples` samples and
`maxiter` iterations.
"""
function fitvariogram(x, y, n; family = :gaussian, samples = 300, maxiter = 1200)

    # Generate some random parameters
    _samples = samples
    ranges = rand(_samples) .* 0.75 * maximum(x)
    sills = rand(_samples) .* maximum(y)
    nuggets = rand(_samples) .* maximum(y) / 10

    error = Inf
    gen = __variogram_gaussian
    if family == :exponential
        gen = __variogram_exponential
    end
    if family == :spherical
        gen = __variogram_spherical
    end
    if family == :cubic
        gen = __variogram_cubic
    end
    if family == :hyperbolic
        gen = __variogram_hyperbolic
    end

    w = n ./ sum(n)

    xn = [(sills[i], nuggets[i], ranges[i]) for i in Base.OneTo(_samples)]

    for _ in Base.OneTo(maxiter)
        __nm!(xn, x, y, n, gen)
    end

    L = [sqrt(sum(w .* (gen(xn[i]...).(x) .- y) .^ 2.0)) for i in Base.OneTo(length(xn))]
    best = xn[last(findmin(L))]
    S, N, R = abs.(best)
    return (sill = S, nugget = N, range = R, error = minimum(L), model = gen(S, N, R))
end

"""
    fitvariogram(L::SDMLayer; family::Symbol=:gaussian, kwargs...)

Fits the variogram based on a layer. The `kwargs...` are passed to `variogram`.
"""
function fitvariogram(L::SDMLayer; family::Symbol = :gaussian, kwargs...)
    vario = variogram(L; kwargs...)
    return fitvariogram(vario...; family = family)
end

function shrink!(xn, xl; α = 1.0, β = 0.5, γ = 2.0, δ = 0.5)
    for i in eachindex(xn)
        xn[i] = xl .+ δ .* (xn[i] .- xl)
    end
    return xn
end

function __nm!(
    xn, x, y, n, f;
    α = 1.0,
    β = 0.5,
    γ = 2.0,
    δ = 0.5,
    kwargs...,
)

    # Weights
    w = n ./ maximum(n)

    # What is their loss?
    L = [sqrt(sum(w .* (f(xn[i]...).(x) .- y) .^ 2.0)) for i in Base.OneTo(length(xn))]

    # Proposals
    best = partialsortperm(L, 1)
    second = partialsortperm(L, length(L) - 1)
    worst = partialsortperm(L, length(L))

    xh, xs, xl = xn[worst], xn[second], xn[best]
    fh, fs, fl = L[worst], L[second], L[best]

    bestside = filter(!isequal(worst), eachindex(xn))
    centroid = reduce(.+, xn[bestside]) ./ length(bestside)

    # Reflection
    xr = centroid .+ α .* (centroid .- xh)
    fr = sqrt(sum(w .* (f(xr...).(x) .- y) .^ 2.0))
    if fl <= fr < fs
        xn[worst] = xr
        return xn
    end

    # Expansion
    if fr < fl
        xe = centroid .+ γ .* (xr .- centroid)
        fe = sqrt(sum(w .* (f(xe...).(x) .- y) .^ 2.0))
        if fe < fr
            xn[worst] = xe
            return xn
        else
            xn[worst] = xr
            return xn
        end
    end

    # Contraction
    if fr >= fs
        if fs <= fr < fh
            xc = centroid .+ β .* (xr .- centroid)
            fc = sqrt(sum(w .* (f(xc...).(x) .- y) .^ 2.0))
            if fc <= fr
                xn[worst] = xc
                return xn
            else
                return shrink!(xn, xl)
            end
        end
        if fr >= fh
            xc = centroid .+ β .* (xr .- centroid)
            fc = sqrt(sum(w .* (f(xc...).(x) .- y) .^ 2.0))
            if fc < fh
                xn[worst] = xc
                return xn
            else
                return shrink!(xn, xl)
            end
        end
    end
end