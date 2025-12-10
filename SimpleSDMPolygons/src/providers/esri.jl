const ESRIDatasets = Union{
    Places
}

SimpleSDMDatasets.provides(::Type{ESRI}, ::Type{T}) where {T<:ESRIDatasets} = true
SimpleSDMDatasets.downloadtype(::PolygonData{ESRI,T}) where T = _File
SimpleSDMDatasets.filetype(::PolygonData{ESRI,T}) where T = _GeoJSON
root(::PolygonData{ESRI,T}) where T = "https://hub.arcgis.com/"

# 

function source(data::PolygonData{ESRI,Places})
    url = "https://hub.arcgis.com/api/v3/datasets/56633b40c1744109a265af1dba673535_0/downloads/data?format=geojson&spatialRefId=4326&where=1%3D1"
    return (
        url=url,
        filename="World_Administrative_Divisions.geojson",
        outdir=destination(data)
    )
end

function postprocess(data::PolygonData{ESRI,T}, res::R; kw...) where {T,R}
    fields = _fields_to_extract(data)
    return FeatureCollection(map(feat -> Feature(_polygonize(feat.geometry), Dict([v => feat.properties[k] for (k, v) in fields])), res.features))
end

_fields_to_extract(::PolygonData{ESRI,Places}) = Dict(
    :OBJECTID => "ID",
    :NAME => "Place name",
    :COUNTRY => "Country",
    :ADMINTYPE => "Administrative type",
    :DISPUTED => "Disputed",
    :AUTONOMOUS => "Autonomous",
    :COUNTRYAFF => "Country of affiliation",
    :CONTINENT => "Continent",
    :LAND_TYPE => "Land type",
    :LAND_RANK => "Land rank",
    :Shape_Leng => "Length",
    :Shape_Area => "Area",
)

@testitem "We can get places from ESRI" begin
    prov = PolygonData(ESRI, Places)
    poly = getpolygon(prov)
    @test poly isa FeatureCollection
end

@testitem "We can get countries from ESRI by continent" begin
    prov = PolygonData(ESRI, Places)
    poly = getpolygon(prov)["Continent" => "Europe"]
    @test poly isa FeatureCollection
end

@testitem "We can query from ESRI data" begin
    prov = PolygonData(ESRI, Places)
    poly = getpolygon(prov)
    @test poly["Place name" => "Quebec"] isa FeatureCollection
end