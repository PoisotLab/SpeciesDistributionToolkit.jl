provides(::Type{PaleoClim}, ::Type{BioClim}) = true

downloadtype(::RasterData{PaleoClim, BioClim}) = _zip

destination(::RasterData{PaleoClim, BioClim}; kwargs...) = joinpath(SimpleSDMDatasets._LAYER_PATH, string(PaleoClim))

url(::RasterData{PaleoClim, BioClim}) = "http://sdmtoolbox.org/paleoclim.org/"
_var_slug(::RasterData{PaleoClim, BioClim}) = "data"

layers(::RasterData{PaleoClim, BioClim}) = layers(RasterData(CHELSA2, BioClim))
layerdescriptions(::RasterData{PaleoClim, BioClim}) = layers(RasterData(CHELSA2, BioClim))

resolutions(::RasterData{PaleoClim, BioClim}) = Dict([2.5 => "2_5m", 5.0 => "5m", 10.0 => "10m"])

extrakeys(::RasterData{PaleoClim, BioClim}) = Dict([:timeperiod => ("LH", "MH", "EH", "YDS", "BA", "HS1", "LIG")])

function source(data::RasterData{PaleoClim, BioClim}; timeperiod="LH", resolution=10.0, kwargs...)
    rescode = get(resolutions(data), resolution, "10m")
    filename = "$(timeperiod)_v1_$(rescode).zip"
    url = "http://sdmtoolbox.org/paleoclim.org/data/$(timeperiod)/$(filename)"
    outdir = destination(data)
    return (; url, filename, outdir)
end

function layername(data::RasterData{PaleoClim, BioClim}; timeperiod="LH", resolution=10.0, layer="BIO1")
    lname = replace(layer, "BIO" => "bio_")
    rescode = get(resolutions(data), resolution, "10m")
    root = "$(timeperiod)_v1_$(rescode)"
    fname = "$(lname).tif"
    return fname
end