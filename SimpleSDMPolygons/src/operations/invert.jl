function invert(inner::Union{POLY_AND_MP, Feature, FeatureCollection})
    outer = _get_polygon_from_bbox(boundingbox(inner))
    subtract(outer, inner)
end 
