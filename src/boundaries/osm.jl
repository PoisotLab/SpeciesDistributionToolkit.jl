"""
    openstreetmap(id::Integer)

Returns a GeoJSON polygon from an OSM ID - this calls the polygon conversion
service hosted at polygons.openstreetmap.fr.
"""
function openstreetmap(id::Integer)
    resp = HTTP.get("https://polygons.openstreetmap.fr/get_geojson.py?id=$(id)")
    return GeoJSON.read(resp.body)
end

"""
    openstreetmap(place::String)

Returns a GeoJSON polygon from a plain text query. This uses the nominatim API
hosted by Open Street Maps to identify the OSM ID, and then calls the polygon
generation service to return the GeoJSON file. Note that this method may return
big polygons.

In order to minimze the calls to the nominatim service, the results for a query
are stored locally.
"""
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
        osm_poly = SpeciesDistributionToolkit.openstreetmap(id)
        GeoJSON.write(cache_file, osm_poly)
    end
    return GeoJSON.read(cache_file)
end