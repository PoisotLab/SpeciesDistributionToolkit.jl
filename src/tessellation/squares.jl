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

function squares(bbox::NamedTuple, d::Float64; offset = (0.0, 0.0))
    all(haskey(bbox, k) for k in [:left, :bottom, :right, :top]) || throw(
        ArgumentError(
            "Bounding box tuple doesn't have correct keys. It must contain :top, :bottom, :left, and :right",
        ),
    )

    # This is the first center
    origin = (bbox.left - offset[1], bbox.top + offset[2])

    # We estimate the span at the middle of the latitude
    middle_latitude = (bbox.top + bbox.bottom) / 2

    # We start by estimating the size of the circumradius at the middle latitude
    # of the boundingbox
    km_per_deg = cos(middle_latitude * π / 180) * 111325.0 / 1000.0

    # We want to get the size of the square in units of degrees
    s = d / km_per_deg

    # Now we measure the distance from the origin to the right / bottom of the
    # bounding box - these distances are measured in degree
    W = abs(bbox.right - origin[1])
    H = abs(bbox.bottom - origin[2])

    # Now we want to know how many hexagons we must add. The first one starts at
    # the origin point, so to cover the full width, we need

    w = ceil(Int, W / s)
    h = ceil(Int, H / s)

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
            Dict{String, Any}("__centroid" => g),
        ) for g in grid
    ]
    
    return FeatureCollection(polys)
end
