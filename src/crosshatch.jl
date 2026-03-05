function _pts_to_poly(pol, pts)
    cpol = SimpleSDMPolygons.AG.createpolygon(pts)
    SimpleSDMPolygons._add_crs(
        cpol,
        SimpleSDMPolygons.AG.importCRS(SimpleSDMPolygons.GI.crs(pol)),
    )
    return Polygon(cpol)
end

function crosshatch(region::SimpleSDMPolygons.AbstractGeometry; spacing = 1.0, angle = 60.0)
    bbox = SimpleSDMPolygons.boundingbox(region)

    O = bbox.top - bbox.bottom
    A = O / tan(deg2rad(angle))

    start_at = bbox.left - abs(A)
    stop_at = bbox.right + abs(A)
    xpoints = start_at:spacing:stop_at

    if !iszero(length(xpoints) % 2)
        stop_at = bbox.right + 2abs(A)
        xpoints = start_at:spacing:stop_at
    end

    pols = []
    for i in eachindex(xpoints)
        if iszero(i % 2)
            p = [
                (xpoints[i], bbox.bottom),
                (xpoints[i] + A, bbox.top),
                (xpoints[i] + A + spacing, bbox.top),
                (xpoints[i] + spacing, bbox.bottom),
                (xpoints[i], bbox.bottom),
            ]
            push!(pols, p)
        end
    end

    P = [_pts_to_poly(region, p) for p in pols]
    hatch = sum(P)
    hatch = intersect(hatch, region)

    return hatch
end
