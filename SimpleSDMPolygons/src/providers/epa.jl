const EPADatasets = Union{
    Ecoregions
}

SimpleSDMDatasets.provides(::Type{EPA}, ::Type{T}) where {T<:EPADatasets} = true
SimpleSDMDatasets.downloadtype(::PolygonData{EPA,Ecoregions}) = _Zip
SimpleSDMDatasets.filetype(::PolygonData{EPA,Ecoregions}) = _Shapefile
root(::PolygonData{EPA,Ecoregions}) = "https://dmap-prod-oms-edc.s3.us-east-1.amazonaws.com/ORD/Ecoregions/cec_na/"
levels(::PolygonData{EPA,Ecoregions}) = (1, 2, 3)

function source(data::PolygonData{EPA,Ecoregions}; level=1)
    stem = _slug(data, level)
    return (
        url=root(data) * stem,
        filename=stem,
        outdir=destination(data)
    )
end

function _merge_ecoregions(sf_table, level, fields)
    ecoregion_field = Symbol("NA_L$(level)NAME")
    er_labels = getproperty(sf_table, ecoregion_field)
    unique_ecoregions = unique(er_labels)

    er_idxs = [findall(isequal(er), er_labels) for er in unique_ecoregions]

    dicts = [Dict([v => getproperty(sf_table, k)[er_idxs[i][begin]] for (k, v) in fields]) for i in eachindex(unique_ecoregions)]

    [AG.createmultipolygon(map(first, GI.coordinates.(sf_table.geometry[idx]))) for idx in er_idxs], dicts
end

function postprocess(data::PolygonData{EPA,Ecoregions}, res::R; kw...) where {R}
    # This bit is important as for some reason, the level argument is not
    # carried over when calling getpolygon
    if !(:level in keys(kw))
        kw = (kw..., level = 1)
    end
    sf_table, ag_prj = res
    fields = _fields_to_extract(data, kw[:level])
    agdal_multipolys, properties = _merge_ecoregions(sf_table, kw[:level], fields)
    target_crs = AG.importEPSG(4326; order=:trad) # ORDER IS IMPORTANT OTHERWISE THE POLYGON IS FLIPPED
    for mp in agdal_multipolys
        AG.createcoordtrans(ag_prj, target_crs) do transform
            AG.transform!(mp, transform)
        end
    end
    return FeatureCollection([Feature(MultiPolygon(agdal_multipolys[i]), properties[i]) for i in eachindex(agdal_multipolys)])
end

function _fields_to_extract(::PolygonData{EPA,Ecoregions}, level)
    level == 1 && return Dict(:NA_L1NAME => "Name")
    level == 2 && return Dict(:NA_L2NAME => "Name", :NA_L1NAME => "Level 1")
    level == 3 && return Dict(:NA_L3NAME => "Name", :NA_L1NAME => "Level 1", :NA_L2NAME => "Level 2")
end

function _slug(::PolygonData{EPA,Ecoregions}, level)
    if level == 1
        return "na_cec_eco_l1.zip"
    elseif level == 2
        return "na_cec_eco_l2.zip"
    elseif level == 3
        return "NA_CEC_Eco_Level3.zip"  # 🤦
    end
    @info "you should never get here if keychecker does its job"
    error("Not an available Ecoregion level")
end

@testitem "We can get all polygons from EPA" begin
    prov = PolygonData(EPA, Ecoregions)
    pol = getpolygon(prov)
    @test pol isa FeatureCollection
end

@testitem "We can get all level 2 polygons from EPA" begin
    prov = PolygonData(EPA, Ecoregions)
    pol = getpolygon(prov; level=2)
    @test pol isa FeatureCollection
end

@testitem "We can get all level 3 polygons from EPA" begin
    prov = PolygonData(EPA, Ecoregions)
    pol = getpolygon(prov; level=3)
    @test pol isa FeatureCollection
end