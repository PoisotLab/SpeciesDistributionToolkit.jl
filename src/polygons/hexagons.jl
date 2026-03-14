function _hexagon(p, s = 1.0)
    pts = [
        (p[1] + s * sin(k * π / 3 + π / 6), p[2] + s * cos(k * π / 3 + π / 6)) for k in 1:6
    ]
    push!(pts, first(pts))
    return pts
end

function hexagons(layer::SDMLayer, d::Float64; padding = 1.0)
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

    # We want d to be the circumradius of the hexagon
    R = d
    r = (sqrt(3.0) / 2) * R

    # We want our hexagons to be flat side up, so we need to first divide the
    # layer height by the indiameter
    h = ceil(Int, H / 2r)

    # Next we do the same thing for the width of the layer with the outdiameter
    w = ceil(Int, W / 2R)

    # Now we generate the grid of hexagons
    grid = Tuple{Float64, Float64}[]

    for y in 1:ceil(Int, h)
        for x in 1:2ceil(Int, w)+1
            # Given a pair of integers x, y, we generate two points: (3y, x√3)
            # and (3y+3/2, (x+1/2)√3)
            p1 = (3 * y, x * sqrt(3))
            p2 = (3 * y + 3 / 2, (x + 1 / 2) * sqrt(3))

            # We now need to re-calculate everything in order to bring the
            # centers to the correct layer space. By convention, we will ensure
            # that the width of the space covered by the hexagons goes from 0 to
            # 1.

            # These is the correct way to range the values in the width unit space
            m, M = 3, 3h + 3/2            
            px = [tuple([(c - m)/(M - m) for c in p]...) for p in [p1, p2]]

            # To bring these to the space of the layer, we then need to rescale
            # by the length of the layer, but we know this one in units of
            # lat/lon
            px = [
                (p[1]*(bb.right-bb.left)+bb.left, p[2]*(bb.right-bb.left)+bb.bottom)
                for p in px
            ]

            # Next we add these two points to the grid
            append!(grid, px)
        end
    end

    # Now the centers are correct, so we can work on getting the true radius - we get this from the circumradius,
    ref = rand(grid)
    sur = filter(r -> (r[2] == ref[2]), grid)
    sur = filter(r -> r != ref, sur)
    _, ix = findmin([abs(ref[1] - s[1]) for s in sur])

    D = abs(sur[ix][1] - ref[1])

    # This is the distance between two centers, which is equal to 3R
    R = D / 3

    polys = [
        Feature(Polygon(_hexagon(g, R)), Dict()) for g in grid
    ]

    return FeatureCollection(polys)
end
