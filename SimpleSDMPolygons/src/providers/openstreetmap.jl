const OpenStreetMapDatasets = Union{
    Countries,
    Places
}

provides(::Type{OpenStreetMap}, ::Type{T}) where {T<:OpenStreetMapDatasets} = true 
downloadtype(::PolygonData{OpenStreetMap,T}) where T = _File
filetype(::PolygonData{OpenStreetMap,T}) where T = _GeoJSON
root(::PolygonData{OpenStreetMap,T}) where T = "https://polygons.openstreetmap.fr/get_geojson.py?id="

function _query_osm_id(place)
    url_place = HTTP.URIs.escapeuri(place)
    query = "https://nominatim.openstreetmap.org/search?q=$(url_place)&format=geojson"
    id = first(GeoJSON.read(Downloads.download(query)).osm_id)
    return id
end


source(::PolygonData{OpenStreetMap, Countries}; country = "Canada") = source(PolygonData(OpenStreetMap,Places); place = country)

function source(data::PolygonData{OpenStreetMap,Places}; place = "Canada")    
    stem = place * ".geojson"
    id = _query_osm_id(place)
    return (
        url = "https://polygons.openstreetmap.fr/get_geojson.py?id=$(id)",
        filename = stem,
        outdir = destination(data)
    )
end

function postprocess(data::PolygonData{OpenStreetMap, T}, res::R; kw...) where {T,R}
    return FeatureCollection(Feature(_polygonize(res), Dict()))
end 