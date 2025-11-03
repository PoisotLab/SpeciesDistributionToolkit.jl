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