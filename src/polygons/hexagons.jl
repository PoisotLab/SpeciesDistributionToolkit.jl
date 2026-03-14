function _hexagon(p, s = 1.0)
    pts = [
        (p[1] + s * sin(k * π / 3 + π / 6), p[2] + s * cos(k * π / 3 + π / 6)) for k in 1:6
    ]
    push!(pts, first(pts))
    return pts
end

function hexagons(bbox::NamedTuple, d::Float64; offset = (0.0, 0.0))
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

    # We want to get the circumradius in units of degrees
    R = d / km_per_deg

    # Then we get the inradius from this value
    r = (sqrt(3.0) / 2) * R

    # Now we measure the distance from the origin to the right / bottom of the
    # bounding box - these distances are measured in degree
    W = abs(bbox.right - origin[1])
    H = abs(bbox.bottom - origin[2])
    
    # Now we want to know how many hexagons we must add. The first one starts at
    # the origin point, so to cover the full width, we need
    w = ceil(Int, W / (3R))

    # And for the full height, we need
    h = ceil(Int, H / (2r))

    # Note that these WILL overflow the boundingbox but it's not a problem as we
    # can intersect everything later on.

    # Now we generate the grid of hexagons
    grid = Tuple{Float64, Float64}[]

    for row in 1:h+1
        for col in 1:w+1
            # Note that here col is the column number, but we need to generate
            # two cells: the one at the coordinates, and the one horizontally on
            # the inter-column

            # The position for the cell on the column is easy to get
            px = origin[1] + 3 * R * (col - 1)
            py = origin[2] - 2 * r * (row - 1)
            
            # The position for the other cell is not terribly difficult either
            p2x = px + (3/2)*R
            p2y = py - r

            append!(grid, [(px, py), (p2x, p2y)])
        end
    end

    # Now we can return the polygons
    polys = [
        Feature(Polygon(_hexagon(g, R)), Dict()) for g in grid
    ]

    return FeatureCollection(polys)
end

function hexagons(sdm::AbstractSDM, args...; kwargs...)
    return hexagons(boundingbox(sdm), args...; kwargs...)
end

function hexagons(layer::SDMLayer, args...; kwargs...)
    return hexagons(boundingbox(layer), args...; kwargs...)
end

function hexagons(geom::SimpleSDMPolygons.AbstractGeometry, args...; kwargs...)
    return hexagons(boundingbox(geom), args...; kwargs...)
end