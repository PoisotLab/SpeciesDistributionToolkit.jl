function _get_polygon_from_bbox(bbox::NamedTuple)
    all(haskey(bbox, k) for k in [:left, :bottom, :right, :top]) || throw(
        ArgumentError(
            "Bounding box tuple doesn't have correct keys. It must contain :top, :bottom, :left, and :right",
        ),
    )

    L, B, R, T = bbox[:left], bbox[:bottom], bbox[:right], bbox[:top]

    # L, B to T
    side1 = [(L,i) for i in LinRange(B, T, 50)]

    # T, L to R
    side2 = [(i,T) for i in LinRange(L, R, 50)]

    # R, T to B
    side3 = [(R,i) for i in LinRange(T, B, 50)]

    # B, R to L
    side4 = [(i,B) for i in LinRange(R, L, 50)]

    cycle = vcat(side1, side2, side3, side4)
    
    return Polygon(cycle...)
end

function clip(
    feat::Feature,
    bbox::NamedTuple,
)
    bbox_poly = _get_polygon_from_bbox(bbox)
    return Feature(intersect(feat, bbox_poly), feat.properties)
end

function clip(
    fc::FeatureCollection,
    bbox::NamedTuple,
)
    bbox_poly = _get_polygon_from_bbox(bbox)
    return intersect(fc, bbox_poly)
end

function clip(
    poly::Union{Polygon, MultiPolygon},
    bbox::NamedTuple,
)
    bbox_poly = _get_polygon_from_bbox(bbox)
    return intersect(poly, bbox_poly)
end
