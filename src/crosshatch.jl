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

function polygonize(L::SDMLayer{Bool})
    layer = copy(L)
    nodata!(layer, false)
    pols = Polygon[]

    layer_crs = SimpleSDMPolygons.AG.toPROJ4(projection(layer))
    if layer.crs == "+proj=longlat +datum=WGS84 +no_defs"
        layer_crs = SimpleSDMPolygons.AG.importEPSG(4326)
    end

    eb = LinRange(layer.x..., size(layer, 2) + 1)
    nb = LinRange(layer.y..., size(layer, 1) + 1)

    for k in keys(layer)
        north, east = k.I
        points = [
            (eb[east], nb[north]),
            (eb[east + 1], nb[north]),
            (eb[east + 1], nb[north + 1]),
            (eb[east], nb[north + 1]),
        ]
        push!(points, first(points))
        cellpol = SimpleSDMPolygons.AG.createpolygon(points)
        SimpleSDMPolygons._add_crs(
            cellpol,
            layer_crs,
        )
        push!(pols, Polygon(cellpol))
    end
    
    cells = sum(pols)
    return cells
end