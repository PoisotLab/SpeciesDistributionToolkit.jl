function Base.intersect(fc1::FeatureCollection, fc2::FeatureCollection) 
    feats = []
    for f1 in fc1
        for f2 in fc2
            poly = intersect(f1, f2)
            if !AG.isempty(poly.geometry)
                new_props = mergewith((a,b) -> "$a x $b", f1.properties, f2.properties)

                push!(feats, Feature(poly, new_props))
            end 
        end
    end
    return FeatureCollection(feats)    
end 


Base.intersect(f1::Feature, fc1::FeatureCollection) = intersect(fc1, f1)
Base.intersect(fc1::FeatureCollection, f1::Feature) = intersect(add(fc1), f1.geometry)
Base.intersect(f1::Feature, f2::Feature) = intersect(f1.geometry, f2.geometry)
Base.intersect(p1::POLY_AND_MP, f1::Feature) = intersect(f1, p1)
Base.intersect(f1::Feature, p1::POLY_AND_MP) = intersect(f1.geometry, p1)

function Base.intersect(p1::POLY_AND_MP, p2::POLY_AND_MP)
    p = AG.intersection(p1.geometry, p2.geometry)
    return p isa AG.IGeometry{AG.wkbPolygon} ? Polygon(p) : MultiPolygon(p)
end 