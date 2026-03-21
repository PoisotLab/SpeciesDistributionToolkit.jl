function _triangle(p, s = 1.0; pointy::Bool = false)
    base = (2s / sqrt(3))
    altitude = s
    pts = [
        (p[1], p[2] + altitude / 2),
        (p[1] + base / 2, p[2] - altitude / 2),
        (p[1] - base / 2, p[2] - altitude / 2),
    ]
    if pointy
        pts = [
            (p[1], p[2] - altitude / 2),
            (p[1] - base / 2, p[2] + altitude / 2),
            (p[1] + base / 2, p[2] + altitude / 2),
        ]
    end
    push!(pts, first(pts))
    return pts
end

function triangles(
    origin::Tuple{Float64, Float64},
    destination::Tuple{Float64, Float64},
    altitude::Float64;
    offset = (0.0, 0.0),
)

    # We measure the distance from the origin to the right / bottom of the
    # bounding box - these distances are measured in degree
    W = abs(destination[1] - origin[1])
    H = abs(destination[2] - origin[2])

    # Now we want to know how many hexagons we must add. The first one starts at
    # the origin point, so to cover the full width, we need
    w = ceil(Int, W / (3R))
    h = ceil(Int, H / (2r))

    # Now we generate the triangles
    polys = Feature[]

    # We always do one more bin than required just in case I guess? Anyway it
    # will be intersected after this is done, so it doesn't matter.
    for row in 0:(h + 1)
        for col in 0:(w + 1)
            # Note that here col is the column number, but we need to generate
            # two cells: the one at the coordinates, and the one horizontally on
            # the inter-column

            # The position for the cell on the column is easy to get
            px = origin[1] + base * (col - 1)
            py = origin[2] - altitude * (row - 1) - altitude / 2

            orig_point = iszero(row % 2)

            push!(
                polys,
                Feature(
                    Polygon(_triangle((px, py), altitude; pointy = orig_point)),
                    Dict{String, Any}("__centroid" => (px, py), "__tile" => true)),
            )

            # The position for the other cell is not terribly difficult either
            p2x = px + base / 2
            p2y = py

            push!(
                polys,
                Feature(
                    Polygon(_triangle((p2x, p2y), altitude; pointy = !orig_point)),
                    Dict{String, Any}("__centroid" => (p2x, p2y), "__tile" => true)),
            )
        end
    end

    return FeatureCollection(polys)
end