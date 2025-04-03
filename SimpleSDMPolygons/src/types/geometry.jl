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

"""
    FeatureCollection
"""
struct FeatureCollection{T} <: AbstractGeometry
    features::Vector{T}
end
FeatureCollection(f::Feature) = FeatureCollection([f])

Base.show(io::IO, fc::FeatureCollection) = print(io, "FeatureCollection with $(length(fc)) features, each with $(length(first(fc.features).properties)) properties")

Base.length(fc::FeatureCollection) = length(fc.features)
Base.getindex(fc::FeatureCollection, i) = getindex(fc.features, i)
Base.eachindex(fc::FeatureCollection) = eachindex(fc.features)
Base.iterate(fc::FeatureCollection) = iterate(fc.features)
Base.iterate(fc::FeatureCollection, i) = iterate(fc.features, i)



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

# --------------------------------------------------------------
# Handle conversion from Shapefile 
# --------------------------------------------------------------
function _polygonize(poly::SF.Polygon)
    agdal_mp = AG.createpolygon(GI.coordinates(poly)[1])
    target_crs = AG.importEPSG(4326)
    _add_crs(agdal_mp, target_crs)
    return MultiPolygon(agdal_mp)
end
