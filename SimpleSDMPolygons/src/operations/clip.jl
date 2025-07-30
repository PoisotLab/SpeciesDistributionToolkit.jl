function _get_polygon_from_bbox(bbox::NamedTuple)
    all(haskey(bbox, k) for k in [:left, :bottom, :right, :top]) || throw(ArgumentError("Bounding box tuple doesn't have correct keys. It must contain :top, :bottom, :left, and :right"))

    bl, tl, tr, br = (bbox[:left], bbox[:bottom]),
        (bbox[:left], bbox[:top]),
        (bbox[:right], bbox[:top]),
        (bbox[:right], bbox[:bottom])
    return Polygon(bl, tl, tr, br)
end 


function clip(
    feat::Feature,
    bbox::NamedTuple
)
    bbox_poly = _get_polygon_from_bbox(bbox)
    return Feature(intersect(feat, bbox_poly), feat.properties)
end

function clip(
    fc::FeatureCollection,
    bbox::NamedTuple
)
    bbox_poly = _get_polygon_from_bbox(bbox)
    return intersect(add(fc), bbox_poly)
end

function clip(
    poly::Union{Polygon,MultiPolygon},
    bbox::NamedTuple
)
    bbox_poly = _get_polygon_from_bbox(bbox)
    return intersect(poly, bbox_poly)
end
