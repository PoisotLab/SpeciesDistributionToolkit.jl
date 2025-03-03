function openstreetmap(place::String)
    url_place = HTTP.URIs.escapeuri(place)
    query = "https://nominatim.openstreetmap.org/search?q=$(url_place)&format=geojson"
    id = first(GeoJSON.read(Downloads.download(query)).osm_id)
    return GeoJSON.read(Downloads.download("https://polygons.openstreetmap.fr/get_geojson.py?id=$(id)"))
end