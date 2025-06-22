const NaturalEarthDatasets = Union{
    Land,
    Lakes,
    Oceans,
    ParksAndProtected,
    Countries,
}

SimpleSDMDatasets.provides(::Type{NaturalEarth}, ::Type{T}) where {T<:NaturalEarthDatasets} = true
SimpleSDMDatasets.downloadtype(::PolygonData{NaturalEarth,T}) where T = _File
SimpleSDMDatasets.filetype(::PolygonData{NaturalEarth,T}) where T = _GeoJSON
root(::PolygonData{NaturalEarth,T}) where T = "https://raw.githubusercontent.com/nvkelso/natural-earth-vector/master/geojson/"


resolutions(::PolygonData{NaturalEarth,ParksAndProtected}) = Dict(10 => "10m")
resolutions(::PolygonData{NaturalEarth,<:NaturalEarthDatasets}) = Dict([
    10 => "10m",
    50 => "50m",
    110 => "110m",
])

function source(data::PolygonData{NaturalEarth,T}; resolution=10) where T
    stem = _slug(data, resolutions(data)[resolution])
    return (
        url=root(data) * stem,
        filename=stem,
        outdir=destination(data)
    )
end

_slug(::PolygonData{NaturalEarth,ParksAndProtected}, scale) = "ne_$(scale)_parks_and_protected_lands_area.geojson"
_slug(::PolygonData{NaturalEarth,Land}, scale) = "ne_$(scale)_land.geojson"
_slug(::PolygonData{NaturalEarth,Oceans}, scale) = "ne_$(scale)_ocean.geojson"
_slug(::PolygonData{NaturalEarth,Lakes}, scale) = "ne_$(scale)_lakes.geojson"
_slug(::PolygonData{NaturalEarth,Countries}, scale) = "ne_$(scale)_admin_0_countries.geojson"

function postprocess(data::PolygonData{NaturalEarth,T}, res::R; kw...) where {T,R}
    fields = _fields_to_extract(data)
    return FeatureCollection(map(feat -> Feature(_polygonize(feat.geometry), Dict([v => feat.properties[k] for (k, v) in fields])), res.features))
end

_fields_to_extract(::PolygonData{NaturalEarth,Countries}) = Dict(
    :NAME_EN => "Name",
    :REGION_UN => "Region",
    :SUBREGION => "Subregion",
    :POP_EST => "Population",
)


_fields_to_extract(::PolygonData{NaturalEarth,Lakes}) = Dict(
    :name_en => "Name",
    :featurecla => "Type",
)

_fields_to_extract(::PolygonData{NaturalEarth,ParksAndProtected}) = Dict(
    :unit_name => "Name",
    :unit_type => "Type",
    :nps_region => "Region",
)

_fields_to_extract(::PolygonData{NaturalEarth,Oceans}) = Dict()
_fields_to_extract(::PolygonData{NaturalEarth,Land}) = Dict()

@testitem "We can get countries from Natural Earth" begin
    prov = PolygonData(NaturalEarth, Countries)
    poly = getpolygon(prov)
    @test poly isa FeatureCollection
end

@testitem "We can get countries from Natural Earth at 110m resolution" begin
    prov = PolygonData(NaturalEarth, Countries)
    poly = getpolygon(prov; resolution=110)
    @test poly isa FeatureCollection
end

@testitem "We can get countries from Natural Earth within a region" begin
    prov = PolygonData(NaturalEarth, Countries)
    poly = getpolygon(prov; resolution=110)
    EUR = poly["Region"=>"Europe"]
    @test EUR isa FeatureCollection
end

@testitem "We can get countries from Natural Earth within a sub-region" begin
    prov = PolygonData(NaturalEarth, Countries)
    poly = getpolygon(prov; resolution=110)
    CAM = poly["Subregion"=>"Central America"]
    @test CAM isa FeatureCollection
end

@testitem "We can get countries from Natural Earth by name" begin
    prov = PolygonData(NaturalEarth, Countries)
    poly = getpolygon(prov; resolution=110)
    CHL = poly["Chile"]
    @test CHL isa Feature
end