const ResolveDatasets = Union{
    Ecoregions
}

SimpleSDMDatasets.provides(::Type{Resolve}, ::Type{T}) where {T<:ResolveDatasets} = true
SimpleSDMDatasets.downloadtype(::PolygonData{Resolve, Ecoregions}) = _Zip
SimpleSDMDatasets.filetype(::PolygonData{Resolve, Ecoregions}) = _Shapefile
root(::PolygonData{Resolve, Ecoregions}) = "https://storage.googleapis.com/teow2016/"

function source(data::PolygonData{Resolve, Ecoregions})    
    stem = "Ecoregions2017.zip"
    return (
        url = root(data) * stem,
        filename = stem,
        outdir = destination(data)
    )
end

function postprocess(data::PolygonData{Resolve,T}, res::R; kw...) where {T,R}
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

_fields_to_extract(::PolygonData{Resolve,Ecoregions}) = Dict(
    :ECO_NAME => "Name",
    :BIOME_NAME => "Biome",
    :REALM => "Realm",
    :NNH_NAME => "Status"
)

