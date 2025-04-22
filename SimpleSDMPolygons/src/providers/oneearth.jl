SimpleSDMDatasets.provides(::Type{OneEarth}, ::Type{Bioregions}) = true
SimpleSDMDatasets.downloadtype(::PolygonData{OneEarth, Bioregions}) = _Zip
SimpleSDMDatasets.filetype(::PolygonData{OneEarth, Bioregions}) = _GeoJSON
root(::PolygonData{OneEarth, Bioregions}) = "https://assets.takeshape.io/237b7856-239f-4c62-9f9e-0b9ce73fa864/dev/aeb6d1cd-6cc7-4849-b0fd-70eeed16a417/"

_slug(::PolygonData{OneEarth,Bioregions}) = "one_earth-bioregions-2023.geojson.zip"

function source(data::PolygonData{OneEarth, Bioregions})
    stem = _slug(data)
    return (
        url = root(data) * stem,
        filename = stem,
        outdir = destination(data)
    )
end

function postprocess(data::PolygonData{OneEarth, Bioregions}, res::R; kw...) where {R}
    feats = [Feature(_polygonize(res.geometry[i]), _ONEEARTH_CODES[res.Bioregions[i]]) for i in eachindex(res.geometry)]
    return FeatureCollection(feats)
end 

_fields_to_extract(::PolygonData{OneEarth,Bioregions}) =  Dict(
    :Bioregions => "Name"
)