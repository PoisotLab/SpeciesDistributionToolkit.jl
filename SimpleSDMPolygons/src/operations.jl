const POLY_AND_MP = Union{Polygon,MultiPolygon}

function _get_polygon_from_bbox(bbox)
    return Polygon(AG.createpolygon([ 
        (bbox[:left], bbox[:bottom]),
        (bbox[:left], bbox[:top]),
        (bbox[:right], bbox[:top]),
        (bbox[:right], bbox[:bottom]),
        (bbox[:left], bbox[:bottom]),
    ]))
end 

# ==================================================
# add
#
# ==================================================

Base.:+(g1::AbstractGeometry, g2::AbstractGeometry) = add(g1, g2)

function add(fc1::FeatureCollection)
    agg_feat = fc1.features[begin]
    for feat in fc1.features
        agg_feat = add(agg_feat, feat)
    end    
    return agg_feat
end

function add(fc1::FeatureCollection, fc2::FeatureCollection)
    agg_feat = add(fc1)
    add(agg_feat, fc2)
end 

add(f1::Feature, fc1::FeatureCollection) = add(fc1, f1)
function add(fc1::FeatureCollection, f2::Feature)
    agg_feat = f2 
    for feat in fc1
        agg_feat = add(agg_feat, feat)
    end 
    return agg_feat
end 

add(p1::POLY_AND_MP,f1::FeatureCollection) = add(f1, p1)
function add(f1::FeatureCollection, p1::POLY_AND_MP)
    agg_feat = p1
    for feat in f1.features
        agg_feat = add(agg_feat, feat)
    end
    return agg_feat
end 

add(p1::POLY_AND_MP, f1::Feature) = add(f1, p1)
function add(f1::Feature, p1::POLY_AND_MP)
    add(f1.geometry, p1)
end 

function add(f1::Feature, f2::Feature)
    add(f1.geometry, f2.geometry)
end

function add(p1::POLY_AND_MP, p2::POLY_AND_MP)
    p = AG.union(p1.geometry, p2.geometry)
    return p isa AG.IGeometry{AG.wkbPolygon} ? Polygon(p) : MultiPolygon(p)
end 

# ==================================================
# subtract
#
# ==================================================

Base.:-(g1::AbstractGeometry, g2::AbstractGeometry) = subtract(g1, g2)

subtract(fc1::FeatureCollection, f1::Feature) = subtract(add(fc1), f1.geometry)
subtract(fc1::FeatureCollection, fc2::FeatureCollection) = subtract(add(fc1), add(fc2))
subtract(fc1::FeatureCollection, p1::POLY_AND_MP) = subtract(add(fc1), p1)
subtract(f1::Feature, p1::POLY_AND_MP) = subtract(f1.geometry, p1)
subtract(f1::Feature, f2::Feature) = subtract(f1.geometry, f2.geometry)
subtract(f1::Feature, fc::FeatureCollection) = subtract(f1.geometry, add(fc))
subtract(p1::POLY_AND_MP, fc::FeatureCollection) = subtract(p1, add(fc))
subtract(p1::POLY_AND_MP, f1::Feature) = subtract(p1, f1.geometry)

function subtract(p1::POLY_AND_MP, p2::POLY_AND_MP)
    p = AG.difference(p1.geometry, p2.geometry)
    return p isa AG.IGeometry{AG.wkbPolygon} ? Polygon(p) : MultiPolygon(p)
end 

# ==================================================
# intersect
#
# ==================================================
intersect(fc1::FeatureCollection, fc2::FeatureCollection) = AG.intersection(add(fc1), add(fc2)) 
intersect(f1::Feature, fc1::FeatureCollection) = intersect(fc1, f1)
intersect(fc1::FeatureCollection, f1::Feature) = intersect(add(fc1), f1.geometry)
intersect(f1::Feature, f2::Feature) = intersect(f1.geometry, f2.geometry)
intersect(p1::POLY_AND_MP, f1::Feature) = intersect(f1, p1)
intersect(f1::Feature, p1::POLY_AND_MP) = intersect(f1.geometry, p1)

function intersect(p1::POLY_AND_MP, p2::POLY_AND_MP)
    p = AG.intersection(p1.geometry, p2.geometry)
    return p isa AG.IGeometry{AG.wkbPolygon} ? Polygon(p) : MultiPolygon(p)
end 

# ==================================================
# invert
#
# ==================================================

function invert(inner::Union{POLY_AND_MP, Feature, FeatureCollection})
    outer = _get_polygon_from_bbox(boundingbox(inner))
    subtract(outer, inner)
end 
