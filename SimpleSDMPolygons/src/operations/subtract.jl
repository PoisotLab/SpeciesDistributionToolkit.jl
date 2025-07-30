Base.:-(g1::AbstractGeometry, g2::AbstractGeometry) = subtract(g1, g2)

subtract(fc1::FeatureCollection, fc2::FeatureCollection) = subtract(add(fc1), add(fc2))


function subtract(fc1::FeatureCollection, f1::Feature)
    feats = [Feature(subtract(f, f1), f.properties) for f in fc1]
    filter!(x->!AG.isempty(x.geometry.geometry), feats)
    return FeatureCollection(feats)
end 

function subtract(fc1::FeatureCollection, p1::POLY_AND_MP)
    feats = [Feature(subtract(f, p1), f.properties) for f in fc1]
    filter!(x->!AG.isempty(x.geometry.geometry), feats)
    return FeatureCollection(feats)
end 

subtract(f1::Feature, fc::FeatureCollection) = subtract(f1.geometry, add(fc))
subtract(f1::Feature, p1::POLY_AND_MP) = subtract(f1.geometry, p1)
subtract(f1::Feature, f2::Feature) = subtract(f1.geometry, f2.geometry)

subtract(p1::POLY_AND_MP, fc::FeatureCollection) = subtract(p1, add(fc))
subtract(p1::POLY_AND_MP, f1::Feature) = subtract(p1, f1.geometry)

function subtract(p1::POLY_AND_MP, p2::POLY_AND_MP)
    p = AG.difference(p1.geometry, p2.geometry)
    return p isa AG.IGeometry{AG.wkbPolygon} ? Polygon(p) : MultiPolygon(p)
end 
