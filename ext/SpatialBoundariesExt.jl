module SpatialBoundariesExt

using SpeciesDistributionToolkit
using SpatialBoundaries


"""
    wombling(layer::SDMLayer)

Performs a lattice wombling on a `SDMLayer`. The returns are (i) the rate
of change, (ii) the direction of change, and (iii) the wombling object itself.
"""
function SpatialBoundaries.wombling(layer::T) where {T <: SDMLayer}

    # Get the values for x and y
    y = collect(eastings(layer))
    x = collect(northings(layer))

    # Get the grid
    z = convert(Matrix{Float64}, layer.grid)
    z[findall(!, layer.indices)] .= NaN

    # Womble
    W = wombling(Float64.(x), Float64.(y), z)

    # Prepare to return
    rate = SDMLayer(W.m, (!isnan).(W.m), extrema(W.y), extrema(W.x), layer.crs)
    direction = SDMLayer(W.θ, (!isnan).(W.m), extrema(W.y), extrema(W.x), layer.crs)
    return (; rate, direction, wombling = W)
end


"""
    wombling(L::Vector{SDMLayer})

Performs a lattice wombling on a vector of `SDMLayer`. The returns are (i) the
rate of change, (ii) the direction of change, and (iii) the wombling object
itself. This returns the mean of the womblings.
"""
function SpatialBoundaries.wombling(L::Vector{T}) where {T <: SDMLayer}
    W = wombling.(L)
    M = SpatialBoundaries.mean([w.wombling for w in W])
    rate = SDMLayer(M.m, (!isnan).(M.m), extrema(M.y), extrema(M.x), first(L).crs)
    direction = SDMLayer(M.θ, (!isnan).(M.m), extrema(M.y), extrema(M.x), first(L).crs)
    return (; rate, direction, wombling = M)
end

end