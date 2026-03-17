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

function triangles(bbox::NamedTuple, d::Float64; offset = (0.0, 0.0))
    all(haskey(bbox, k) for k in [:left, :bottom, :right, :top]) || throw(
        ArgumentError(
            "Bounding box tuple doesn't have correct keys. It must contain :top, :bottom, :left, and :right",
        ),
    )

    # This is the first center
    origin = (bbox.left - offset[1], bbox.top + offset[2])

    # We estimate the span at the middle of the latitude
    middle_latitude = (bbox.top + bbox.bottom) / 2
    middle_longitude = (bbox.left + bbox.right) / 2

    # We start by estimating the size of the circumradius at the middle latitude
    # of the boundingbox
    km_per_deg = cos(middle_latitude * π / 180) * 111325.0 / 1000.0

    # We want to get the triangle height from this value
    altitude = d / km_per_deg

    # The triangle base therefore
    base = (2altitude / sqrt(3))

    # Now we measure the distance from the origin to the right / bottom of the
    # bounding box - these distances are measured in degree
    W = abs(bbox.right - origin[1])
    H = abs(bbox.bottom - origin[2])

    # Now we want to know how many hexagons we must add. The first one starts at
    # the origin point, so to cover the full width, we need

    w = ceil(Int, W / base)
    h = ceil(Int, H / altitude)

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
            py = origin[2] - altitude * (row - 1) - altitude/2

            orig_point = iszero(row % 2)

            push!(
                polys,
                Feature(
                    Polygon(_triangle((px, py), altitude; pointy = orig_point)),
                    Dict{String, Any}("__centroid" => (px, py))),
            )

            # The position for the other cell is not terribly difficult either
            p2x = px + base/2
            p2y = py

            push!(
                polys,
                Feature(
                    Polygon(_triangle((p2x, p2y), altitude; pointy = !orig_point)),
                    Dict{String, Any}("__centroid" => (p2x, p2y))),
            )
        end
    end

    return FeatureCollection(polys)
end