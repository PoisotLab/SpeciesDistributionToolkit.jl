function crosshatch(region::SimpleSDMPolygons.AbstractGeometry; spacing=1.0, angle=80.)
    
    bbox = SDT.boundingbox(region)
    
    O = bbox.top - bbox.bottom
    A = O / tan(deg2rad(angle))

    start_at = bbox.left - abs(A)
    stop_at = bbox.right + abs(A)
    xpoints = start_at:spacing:stop_at

    pols = []
    for i in eachindex(xpoints)
        p = [
            (xpoints[i], bbox.bottom),
            (xpoints[i] + A, bbox.top),
            (xpoints[i] + A + spacing, bbox.top),
            (xpoints[i] + spacing, bbox.bottom),
            (xpoints[i], bbox.bottom),
        ]
        push!(pols, p)
    end

    P = [_pts_to_poly(region, p) for p in pols]
    hatch = FeatureCollection([Feature(p, Dict()) for p in P])

    return intersect(region, hatch)
end