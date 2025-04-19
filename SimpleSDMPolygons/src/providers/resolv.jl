const ResolvDatasets = Union{
    Ecoregions
}

SimpleSDMDatasets.provides(::Type{Resolv}, ::Type{T}) where {T<:ResolvDatasets} = true
SimpleSDMDatasets.downloadtype(::PolygonData{Resolv, Ecoregions}) = _Zip
SimpleSDMDatasets.filetype(::PolygonData{Resolv, Ecoregions}) = _Shapefile
root(::PolygonData{Resolv, Ecoregions}) = "https://storage.googleapis.com/teow2016/"

function source(data::PolygonData{Resolv, Ecoregions})    
    stem = "Ecoregions2017.zip"
    return (
        url = root(data) * stem,
        filename = stem,
        outdir = destination(data)
    )
end

function postprocess(data::PolygonData{Resolv,T}, res::R; kw...) where {T,R}
    feat, prj = res
    agdal_multipolys = [AG.createmultipolygon(GI.coordinates(mp)) for mp in feat.geometry]
    target_crs = AG.importEPSG(4326) 
    for mp in agdal_multipolys
        AG.createcoordtrans(prj, target_crs) do transform
            AG.transform!(mp, transform) 
        end        
    end  

    prop = [Dict([v=>getproperty(feat,k)[i] for (k,v) in _fields_to_extract(data)]) for i in 1:length(feat.geometry)]
    FeatureCollection([Feature(MultiPolygon(agdal_multipolys[i]), prop[i]) for i in 1:length(feat.geometry)]) 
end 

_fields_to_extract(::PolygonData{Resolv,Ecoregions}) = Dict(
    :ECO_NAME => "Name",
    :BIOME_NAME => "Biome",
    :REALM => "Realm",
    :NNH_NAME => "Status"
)

