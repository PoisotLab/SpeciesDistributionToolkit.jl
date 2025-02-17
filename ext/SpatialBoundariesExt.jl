module SpatialBoundariesExt

using SpeciesDistributionToolkit
using SpatialBoundaries

"""
    wombling(layer::SDMLayer; convert_to::Type=Float64)

Performs a lattice wombling on a `SimpleSDMLayer`. The returns are (i) the rate
of change, (ii) the direction of change, and (iii) the wombling object itself.
"""
function wombling(layer::SDMLayer)

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

end