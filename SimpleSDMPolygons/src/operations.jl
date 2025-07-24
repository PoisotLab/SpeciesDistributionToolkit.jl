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
# vcat
# 
# ==================================================

Base.vcat(fcs::FeatureCollection...) = FeatureCollection(vcat([fc.features for fc in fcs]...))

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

# ==================================================
# invert
#
# ==================================================

function invert(inner::Union{POLY_AND_MP, Feature, FeatureCollection})
    outer = _get_polygon_from_bbox(boundingbox(inner))
    subtract(outer, inner)
end 

#=

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

function _merge_feature_properties(f1, f2, delim)
    p1, p2 = f1.properties, f2.properties
    if haskey(p1, "Name") && haskey(p2, "Name") 
        return Dict("Name" => p1["Name"] * " $delim " * p2["Name"])
    else
        haskey(p1, "Name") && return Dict("Name"=>p1["Name"])
        haskey(p2, "Name") && return Dict("Name"=>p2["Name"])
    end 
    return Dict()
end

# TODO:
# add, intersect, and subtract should have a keyword argument that decides how to handle Feature properties when merging two features 

# ==================================================
# vcat
# 
# ==================================================

Base.vcat(fcs::FeatureCollection...) = FeatureCollection(vcat([fc.features for fc in fcs]...))

# ==================================================
# overlaps
# 
# ==================================================

overlaps(fc1::FeatureCollection, fc2::FeatureCollection) = any([overlaps(f1, f2) for f1 in fc1, f2 in fc2])

overlaps(f1::Feature, fc1::FeatureCollection) = overlaps(fc1, f1)
overlaps(fc1::FeatureCollection, f1::Feature) =  any([overlaps(f, f1) for f in fc1])

overlaps(f1::Feature, f2::Feature) = overlaps(f1.geometry, f2.geometry)

overlaps(p1::POLY_AND_MP, fc1::FeatureCollection) = overlaps(fc1, p1)
overlaps(fc1::FeatureCollection, p1::POLY_AND_MP) = any([overlaps(f, p1) for f in fc1])

overlaps(p1::POLY_AND_MP, f1::Feature) = overlaps(f1, p1)
overlaps(f1::Feature, p1::POLY_AND_MP) = overlaps(f1.geometry, p1)

overlaps(p1::POLY_AND_MP, p2::POLY_AND_MP) = AG.intersects(p1.geometry, p2.geometry)



# ==================================================
# add
#
# ==================================================

Base.:+(g1::AbstractGeometry, g2::AbstractGeometry) = add(g1, g2)

function add(f1::Feature, f2::Feature) 
    Feature(add(f1.geometry, f2.geometry), Dict())
end
 
function add(fc1::FeatureCollection) 
    agg_feat = fc1.features[begin]
    for feat in fc1.features
        agg_feat = add(agg_feat, feat)
    end    
    return Feature(agg_feat, Dict())
end

function add(fc1::FeatureCollection, fc2::FeatureCollection)
    feats = []
    for f1 in fc1
        for f2 in fc2
            push!(feats, add(f1, f2))
        end 
    end 
    return FeatureCollection(feats)
end 

add(f1::Feature, fc1::FeatureCollection) = add(fc1, f1)
function add(fc1::FeatureCollection, f2::Feature)
    feats = []
    for feat in fc1
        push!(feats, add(feat, f2))
    end 
    return FeatureCollection(feats)
end 

add(p1::POLY_AND_MP, f1::FeatureCollection) = add(f1, p1)
function add(f1::FeatureCollection, p1::POLY_AND_MP)
    agg_feat = p1
    for feat in f1.features
        agg_feat = add(agg_feat, feat)
    end
    return agg_feat
end 

add(p1::POLY_AND_MP, f1::Feature) = add(f1, p1)
# TODO: decide if this should return polygon or feature
function add(f1::Feature, p1::POLY_AND_MP) 
    add(f1.geometry, p1)
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


# all of these should iterate over each Feature in the Collection to preserve subdivs.
function subtract(fc1::FeatureCollection, fc2::FeatureCollection) 
    feats = []
    for f1 in fc1 
        for f2 in fc2             
            new_poly = subtract(f1, f2)
            new_props = _merge_feature_properties(f1, f2, "-")
            push!(feats, Feature(new_poly, new_props))
        end 
    end 
    return FeatureCollection(feats)
end 

function subtract(fc1::FeatureCollection, f1::Feature) 
    feats = []
    for f2 in fc1
        if overlaps(f1, f2)
            new_poly = f2 - f1 
            new_props = _merge_feature_properties(f2, f1, "-")
            push!(feats, Feature(new_poly, new_props))
        end 
    end 
    return FeatureCollection(feats)
end 

function subtract(fc1::FeatureCollection, p1::POLY_AND_MP)
    subtract(add(fc1), p1)
end 

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

function intersect(fc1::FeatureCollection, fc2::FeatureCollection) 
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

intersect(f1::Feature, fc1::FeatureCollection) = intersect(fc1, f1)
intersect(fc1::FeatureCollection, f1::Feature) = intersect(add(fc1), f1.geometry)


function intersect(f1::Feature, f2::Feature) 
    poly = intersect(f1.geometry, f2.geometry)
end 

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


=#