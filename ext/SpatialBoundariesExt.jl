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

@testitem "We can get the gradient right" begin
    using SpatialBoundaries
    X = zeros(Float64, 200, 200)
    for i in axes(X, 1)
        X[i, :] .= i
    end
    grad = SDMLayer(X)
    Z = wombling(grad)
    @test all(unique(values(Z.rate)) .== 1.0)
    @test all(unique(values(Z.direction)) .== 180.0)
end

@testitem "We can womble with a layer" begin
    using SpatialBoundaries
    precipitation = SDMLayer(
        RasterData(CHELSA1, BioClim);
        layer = 12,
        left = -66.0,
        right = -62.0,
        bottom = 45.0,
        top = 46.5,
    )
    W = wombling(precipitation)
    @test isa(W.rate, SDMLayer)
    @test isa(W.direction, SDMLayer)
end

end