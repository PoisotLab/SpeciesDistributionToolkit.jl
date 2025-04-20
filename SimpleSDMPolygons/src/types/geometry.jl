"""
    AbstractGeometry
"""
abstract type AbstractGeometry end 

"""
    Polygon
"""
struct Polygon <: AbstractGeometry
    geometry::AG.IGeometry{AG.wkbPolygon}
end
GI.isgeometry(::Polygon)::Bool = true
GI.geomtrait(::Polygon)::DataType = GI.PolygonTrait
GI.ngeom(::Type{GI.PolygonTrait}, geom::Polygon)::Integer = GI.ngeom(geom.geometry)
GI.getgeom(::Type{GI.PolygonTrait}, geom::Polygon, i) = 
GI.getgeom(geom.geometry, i)
GI.crs(::Type{GI.PolygonTrait}, geom::Polygon)= GI.crs(geom.geometry)
GI.extent(::Type{GI.PolygonTrait}, geom::Polygon)::GI.Extents.Extent = GI.extent(geom.geometry)


"""
    MultiPolygon
"""
struct MultiPolygon <: AbstractGeometry
    geometry::AG.IGeometry{AG.wkbMultiPolygon}
end
Base.show(io::IO, mp::MultiPolygon) = print(io, "MultiPolygon with $(GI.ngeom(mp.geometry)) subpolygons")
GI.isgeometry(::MultiPolygon)::Bool = true
GI.geomtrait(::MultiPolygon)::DataType = GI.MultiPolygonTrait
GI.ngeom(::Type{GI.MultiPolygonTrait}, geom::MultiPolygon)::Integer = GI.ngeom(geom.geometry)
GI.getgeom(::Type{GI.MultiPolygonTrait}, geom::MultiPolygon, i) = 
GI.getgeom(geom.geometry, i)
GI.crs(::Type{GI.MultiPolygonTrait}, geom::MultiPolygon)= GI.crs(geom.geometry)
GI.extent(::Type{GI.MultiPolygonTrait}, geom::MultiPolygon)::GI.Extents.Extent = GI.extent(geom.geometry)

"""
    Feature
"""
struct Feature{T<:Union{Polygon,MultiPolygon}} <: AbstractGeometry
    geometry::T
    properties::Dict
end
Base.show(io::IO, feat::Feature{T}) where T = begin
    feat_str = "$T Feature"
    props = [(k,v) for (k,v) in feat.properties]
    if length(feat.properties) > 0
        for p in props[1:end-1]
            feat_str = feat_str * "\n├ $(p[1]) => $(p[2])"
        end 
        feat_str = feat_str * "\n└ $(props[end][1]) => $(props[end][2])"
    end 
    print(io, feat_str)
end 

Base.getproperty(feat::Feature, propname::String) = haskey(feat.properties, propname) ? feat.properties[propname] : nothing 

getname(feat::Feature) = getproperty(feat, "Name")

"""
    FeatureCollection
"""
struct FeatureCollection{T} <: AbstractGeometry
    features::Vector{T}
end
FeatureCollection(f::Feature) = FeatureCollection([f])

Base.show(io::IO, fc::FeatureCollection) = print(io, "FeatureCollection with $(length(fc)) features, each with $(length(first(fc.features).properties)) properties")

Base.length(fc::FeatureCollection) = length(fc.features)
Base.firstindex(::FeatureCollection) = 1
Base.lastindex(fc::FeatureCollection) = length(fc)
Base.eachindex(fc::FeatureCollection) = eachindex(fc.features)
Base.iterate(fc::FeatureCollection) = iterate(fc.features)
Base.iterate(fc::FeatureCollection, i) = iterate(fc.features, i)


getname(fc::FeatureCollection) = getname.(fc.features)

Base.getindex(fc::FeatureCollection, i) = getindex(fc.features, i)
Base.getindex(fc::FeatureCollection, str::String) = begin
    names = getname.(fc)    
    idx = findfirst(isequal(str), names)
    return fc[idx]
end

Base.getindex(fc::FeatureCollection, pr::Pair) = begin
    vals = getproperty.(fc.features, pr[1])
    idx = findall(isequal(pr[2]), vals)
    FeatureCollection(fc[idx])
end 


# --------------------------------------------------------------
# boundingbox
# --------------------------------------------------------------

_padbbox(l, r, b, t, p) = (left=l-p, right=r+p, bottom=b-p, top=t+p)

function boundingbox(p::Union{Polygon,MultiPolygon}; padding=0.) 
    (l,r), (b,t) = GI.extent(p)
    return _padbbox(l, r, b, t, padding)
end

function boundingbox(f::Feature; padding=0.) 
    (l,r), (b,t) = GI.extent(f.geometry)
    return _padbbox(l, r, b, t, padding)
end

function boundingbox(fc::FeatureCollection; padding=0.) 
    bboxs = map(boundingbox, fc)    
    l,r = minimum([b.left for b in bboxs]), maximum([b.right for b in bboxs]) 
    b,t = minimum([b.bottom for b in bboxs]), maximum([b.top for b in bboxs]) 
    return _padbbox(l, r, b, t, padding)
end


# This is (somehow) that most straightforward way to take an ArchGDAL geometry without an associated CRS and add one to it. Don't ask. 
function _add_crs(geom::AG.IGeometry, target_crs)
    source_crs = isnothing(GI.crs(geom)) ? AG.importEPSG(4326) : AG.importEPSG(GI.crs(geom).val[1])
    AG.createcoordtrans(source_crs, target_crs) do transform
        AG.transform!(geom, transform) 
    end    
end

# --------------------------------------------------------------
# Handle conversion from GeoJSON 
# --------------------------------------------------------------
function _polygonize(mp::GJ.MultiPolygon)
    agdal_mp = AG.createmultipolygon(GI.coordinates(mp))
    target_crs = AG.importEPSG(4326)
    _add_crs(agdal_mp, target_crs)
    return MultiPolygon(agdal_mp)
end

function _polygonize(poly::GJ.Polygon)
    agdal_poly = AG.createpolygon(GI.coordinates(poly))
    target_crs = AG.importEPSG(4326)
    _add_crs(agdal_poly, target_crs)
    return Polygon(agdal_poly)
end


