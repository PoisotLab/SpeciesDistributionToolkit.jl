function _square(p, s = 1.0)
    pts = [
        (p[1] - s / 2, p[2] + s / 2),
        (p[1] + s / 2, p[2] + s / 2),
        (p[1] + s / 2, p[2] - s / 2),
        (p[1] - s / 2, p[2] - s / 2),
    ]
    push!(pts, first(pts))
    return pts
end

function squares(
    origin::Tuple{Float64, Float64},
    destination::Tuple{Float64, Float64},
    s::Float64;
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

    # Now we generate the grid of squares
    grid = Tuple{Float64, Float64}[]

    # We always do one more bin than required just in case I guess? Anyway it
    # will be intersected after this is done, so it doesn't matter.
    for row in 0:(h + 1)
        for col in 0:(w + 1)
            px = origin[1] + s * (col - 1)
            py = origin[2] - s * (row - 1)

            push!(grid, (px, py))
        end
    end

    # Now we can return the polygons
    polys = [
        Feature(
            Polygon(_square(g, s)),
            Dict{String, Any}("__centroid" => g, "__tile" => true),
        ) for g in grid
    ]

    return FeatureCollection(polys)
end
