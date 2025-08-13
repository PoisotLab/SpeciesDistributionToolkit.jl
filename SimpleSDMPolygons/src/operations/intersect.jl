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
function Base.intersect(fc1::FeatureCollection, f1::Feature) 
    feats = [Feature(intersect(f, f1), f1.properties) for f in fc1]
    return FeatureCollection(feats)
end 

Base.intersect(p1::POLY_AND_MP, fc1::FeatureCollection) = intersect(fc1, p1)
function Base.intersect(fc1::FeatureCollection, p1::POLY_AND_MP) 
    feats = [Feature(intersect(f, p1), f.properties) for f in fc1]
    filter!(x->!AG.isempty(x.geometry.geometry), feats)
    return FeatureCollection(feats)
end 

Base.intersect(f1::Feature, f2::Feature) = intersect(f1.geometry, f2.geometry)
Base.intersect(p1::POLY_AND_MP, f1::Feature) = intersect(f1, p1)
Base.intersect(f1::Feature, p1::POLY_AND_MP) = intersect(f1.geometry, p1)
function Base.intersect(p1::POLY_AND_MP, p2::POLY_AND_MP)
    GI.crs(p1.geometry) == GI.crs(p2.geometry) || throw(ArgumentError("Cannot intersect two geometries with different CRSs"))

    p = AG.intersection(p1.geometry, p2.geometry)
    return p isa AG.IGeometry{AG.wkbPolygon} ? Polygon(p) : MultiPolygon(p)
end 