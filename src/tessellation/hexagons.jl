function _hexagon(p, s = 1.0; pointy::Bool = false)
    offset = pointy ? 0 : π / 6
    pts = [
        (p[1] + s * sin(k * π / 3 + offset), p[2] + s * cos(k * π / 3 + offset)) for
        k in 1:6
    ]
    push!(pts, first(pts))
    return pts
end

function hexagons(
    origin::Tuple{Float64, Float64},
    destination::Tuple{Float64, Float64},
    R::Float64;
    offset = (0.0, 0.0),
    pointy::Bool = false,
)

    # We get the inradius from the circumradius
    r = (sqrt(3.0) / 2) * R

    # We measure the distance from the origin to the right / bottom of the
    # bounding box - these distances are measured in degree
    W = destination[1] - origin[1]
    H = origin[2] - destination[2]

    # Now we want to know how many hexagons we must add. The first one starts at
    # the origin point, so to cover the full width, we need
    w = ceil(Int, W / (3R))
    h = ceil(Int, H / (2r))

    # If this is a pointy side up tiling, we need to accurately reflect this
    if pointy
        w = ceil(Int, W / (2r))
        h = ceil(Int, H / (3R))
    end

    # Now we generate the grid of hexagons
    grid = Tuple{Float64, Float64}[]

    # We always do one more bin than required just in case I guess? Anyway it
    # will be intersected after this is done, so it doesn't matter.
    for row in 0:(h + 1)
        for col in 0:(w + 1)
            # Note that here col is the column number, but we need to generate
            # two cells: the one at the coordinates, and the one horizontally on
            # the inter-column

            if pointy
                # This is a pointy side up tiling, where the rows are continuous
                # along the width
                px = origin[1] + 2r * (col - 1)
                py = origin[2] - 3R * (row - 1)

                # Now we create the shifted polygon
                p2x = px - r
                p2y = py - (3 / 2)R

            else
                # This is the flat side up tiling, where the columns are
                # continuous along the height

                # The position for the cell on the column is easy to get
                px = origin[1] + 3 * R * (col - 1)
                py = origin[2] - 2 * r * (row - 1)

                # The position for the other cell is not terribly difficult either
                p2x = px + (3 / 2) * R
                p2y = py - r
            end

            append!(grid, [(px, py), (p2x, p2y)])
        end
    end

    # Now we can return the polygons
    return [(centroid=g, cycle=_hexagon(g, R; pointy = pointy)) for g in grid]
end