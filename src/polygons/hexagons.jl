function _hexagon(p, s = 1.0)
    pts = [
        (p[1] + s * sin(k * π / 3), p[2] + s * cos(k * π / 3)) for k in 1:6
    ]
    push!(pts, first(pts))
    return pts
end

function hexagons(layer::SDMLayer, d::Float64; padding = 0.5)
    bb = boundingbox(layer; padding = padding)

    # We estimate the span at the middle of the latitude
    middle_latitude = (bb.top + bb.bottom) / 2
    middle_longitude = (bb.left + bb.right) / 2

    # This gives the layer dimensions (approximate)
    W = SpeciesDistributionToolkit.Fauxcurrences._distancefunction(
        (bb.left, middle_latitude),
        (bb.right, middle_latitude),
    )
    H = SpeciesDistributionToolkit.Fauxcurrences._distancefunction(
        (middle_longitude, bb.bottom),
        (middle_longitude, bb.top),
    )

    # How many hexagons should this be?
    w, h = ceil(Int, W / d), ceil(Int, H / d)

    # Now we generate the grid of hexagons
    p1 = [(3 * j, i * sqrt(3)) for i in 1:w, j in 1:h]
    p2 = [(3 * j + 3 / 2, (i + 1 / 2) * sqrt(3)) for i in 1:w, j in 1:h]
    grid = vcat(vec(p1), vec(p2))

    # Corrected to the unit interval
    dx, dy = extrema(first.(grid)), extrema(last.(grid))
    for i in eachindex(grid)
        g = grid[i]
        grid[i] = ((g[1] - dx[1]) / (dx[2] - dx[1]), (g[2] - dy[1]) / (dy[2] - dy[1]))
    end

    # We need to resize the grid so that it covers the right bbox
    for i in eachindex(grid)
        g = grid[i]
        grid[i] = (
            (g[1] * (bb.right - bb.left) + bb.left),
            (g[2] * (bb.top - bb.bottom) + bb.bottom),
        )
    end

    # Now we need to get the size of the resulting hexagons
    ref = rand(grid)
    sur = filter(r -> (r[1]==ref[1]), grid)
    sur = filter(r -> r != ref, sur)
    _, ix = findmin([abs(ref[2]-s[2]) for s in sur])

    @info sur[ix], ref
    D = abs(sur[ix][2]-ref[2])
    R = D / 2
    
    polys = [
        Polygon(_hexagon(g, R)) for g in grid
    ]

    return polys
end
