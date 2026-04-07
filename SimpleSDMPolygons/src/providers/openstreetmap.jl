const OpenStreetMapDatasets = Union{
    Countries,
    Places,
}

SimpleSDMDatasets.provides(
    ::Type{OpenStreetMap},
    ::Type{T},
) where {T <: OpenStreetMapDatasets} = true
SimpleSDMDatasets.downloadtype(::PolygonData{OpenStreetMap, T}) where {T} = _File
SimpleSDMDatasets.filetype(::PolygonData{OpenStreetMap, T}) where {T} = _GeoJSON
root(::PolygonData{OpenStreetMap, T}) where {T} =
    "https://nominatim.openstreetmap.org/search"

source(::PolygonData{OpenStreetMap, Countries}; country = "Canada") =
    source(PolygonData(OpenStreetMap, Places); place = country, type = "country")

function source(
    data::PolygonData{OpenStreetMap, Places};
    place = "Alps",
    layer = nothing,
    type = nothing,
)
    @assert layer in [nothing, "natural", "manmade", "poi"]
    @assert type in [nothing, "country", "state", "city", "settlement"]
    # Generate the filename
    stem = place
    query = "q=$(HTTP.URIs.escapeuri(place))"
    if !isnothing(layer)
        stem *= "_$(layer)"
        query *= "&layer=$(HTTP.URIs.escapeuri(layer))"
    end
    if !isnothing(type)
        stem *= "_$(type)"
        query *= "&type=$(HTTP.URIs.escapeuri(type))"
    end
    stem *= ".geojson"

    # Construct the actual query URL
    query = root(data) * "?" * query * "&format=geojson&polygon_geojson=1&limit=1"

    # Return
    return (
        url = query,
        filename = stem,
        outdir = destination(data),
    )
end

function postprocess(data::PolygonData{OpenStreetMap, T}, res::R; kw...) where {T, R}
    return _polygonize(res)
end

@testitem "We can get some info about the Alps (mountain range)" begin
    prov = PolygonData(OpenStreetMap, Places)
    poly = getpolygon(prov; place = "Alps")
    @test uniqueproperties(poly)[:addresstype] == ["region"]
    @test uniqueproperties(poly)[:category] == ["boundary"]
end

@testitem "We can get some info about the Vatican" begin
    prov = PolygonData(OpenStreetMap, Countries)
    poly = getpolygon(prov; country = "Vatican City State")
    @test uniqueproperties(poly)[:addresstype] == ["country"]
    @test uniqueproperties(poly)[:category] == ["boundary"]
end