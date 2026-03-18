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

function variogram(pairs::Vector{Tuple{Float64, Float64}}, n::Integer; α::Float64=2.0)
    x = first.(pairs)
    y = last.(pairs)
    bins = LinRange(extrema(x)..., n+1)
    X = zeros(n+1)
    Y = zeros(n+1)
    N = zeros(n+1)
    for i in eachindex(bins)
        if i > 1
            vx = findall(s -> bins[i-1] <= s <= bins[i], x)
            if !isnothing(vx)
                X[i-1] = Statistics.mean(x[vx])
                Y[i-1] = Statistics.mean(y[vx].^α)/2
                N[i-1] = length(vx)
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
function variogram(L::SDMLayer; samples::Integer=2000, bins::Integer=100; kwargs...)
    Z = _generate_point_pairs(L, samples)
    return variogram(Z, bins; kwargs...)
end