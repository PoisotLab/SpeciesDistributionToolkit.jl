const GADMDatasets = Union{
    Countries
}

SimpleSDMDatasets.provides(::Type{GADM}, ::Type{T}) where {T<:GADMDatasets} = true
SimpleSDMDatasets.downloadtype(::PolygonData{GADM, Countries}) = _File
SimpleSDMDatasets.filetype(::PolygonData{GADM, Countries}) = _GeoJSON
root(::PolygonData{GADM, Countries}) = "https://geodata.GADM.edu/gadm/gadm4.1/json/"

levels(::PolygonData{GADM, Countries}) = (0,1,2,3,4)

function source(data::PolygonData{GADM, Countries}; country = "CAN", level = 0)    
    stem = _slug(country, level) 
    return (
        url = root(data) * stem,
        filename = stem,
        outdir = destination(data)
    )
end

function _extra_keychecks(::PolygonData{GADM, Countries}; kwargs...) 
    if :level in keys(kwargs) && :country in keys(kwargs)
        requested_level = kwargs[:level]
        requested_country = kwargs[:country]
        if _GADM_MAX_LEVELS[requested_country] < requested_level 
            error("The country $(requested_country) does not provide level $requested_level. The maximum level provided is $(_GADM_MAX_LEVELS[requested_country])")
        end
    end 
end

_slug(code, level) = "gadm41_$(code)_$(level).json"

function postprocess(data::PolygonData{GADM,T}, res::R; kw...) where {T,R}
    level = haskey(kw, :level) ? kw[:level] : 0
    fields = _fields_to_extract(data; level=level)    
    return FeatureCollection(map(feat -> Feature(_polygonize(feat.geometry), Dict([v=>feat.properties[k] for (k,v) in fields])), res.features))    
end 

function _fields_to_extract(::PolygonData{GADM,Countries}; level=0) 
    level == 0 && return _level_zero_gadm_fields()
    level == 1 && return _level_one_gadm_fields()
    level == 2 && return _level_two_gadm_fields()
    level == 3 && return _level_three_gadm_fields()
end

_level_zero_gadm_fields() = Dict(:COUNTRY=>"Name")

_level_one_gadm_fields() = Dict(
    :NAME_1 => "Name",
    :COUNTRY => "Country"
)

_level_two_gadm_fields() = Dict(
    :NAME_2 => "Name",
    :COUNTRY => "Country",
    :NAME_1 => "Level One",
)

_level_three_gadm_fields() = Dict(
    :NAME_3 => "Name",
    :NAME_2 => "Level Two",
    :NAME_1 => "Level One",
    :COUNTRY => "Country"
)

