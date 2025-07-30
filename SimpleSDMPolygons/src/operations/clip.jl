function _get_polygon_from_bbox(bbox)
    return Polygon(AG.createpolygon([ 
        (bbox[:left], bbox[:bottom]),
        (bbox[:left], bbox[:top]),
        (bbox[:right], bbox[:top]),
        (bbox[:right], bbox[:bottom]),
        (bbox[:left], bbox[:bottom]),
    ]))
end 

#=
function clip(
    poly::Union{Polygon,MultiPolygon},
    layer::SDMLayer
)

end
=#

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
