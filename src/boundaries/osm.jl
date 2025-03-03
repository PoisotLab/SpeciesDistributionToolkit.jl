function openstreetmap(place::String)
    cache_location = joinpath(SimpleSDMDatasets._LAYER_PATH, "OSM")
    if !ispath(cache_location)
        mkpath(cache_location)
    end
    cache_file = joinpath(cache_location, replace(place, " " => "_") * ".geojson")
    if !isfile(cache_file)
        url_place = HTTP.URIs.escapeuri(place)
        query = "https://nominatim.openstreetmap.org/search?q=$(url_place)&format=geojson"
        id = first(GeoJSON.read(Downloads.download(query)).osm_id)
        Downloads.download("https://polygons.openstreetmap.fr/get_geojson.py?id=$(id)", cache_file)
    end
    return GeoJSON.read(cache_file)
end