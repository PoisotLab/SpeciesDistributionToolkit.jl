url(::Type{PaleoClim}) = "http://www.paleoclim.org/"

blurb(::Type{PaleoClim}) = md"""
PaleoClim provides high-resolution paleoclimate data for use in biological
modeling and GIS. The data were generated based in part on
[CHELSA](https://chelsa-climate.org/last-glacial-maximum-climate/) data.

::: details Citation

Brown, Hill, Dolan, Carnaval, Haywood. PaleoClim, high spatial resolution
paleoclimate surfaces for global land areas. Scientific Data. 5:18025 (2018).

:::

"""

provides(::Type{PaleoClim}, ::Type{BioClim}) = true

downloadtype(::RasterData{PaleoClim, BioClim}) = _zip

destination(::RasterData{PaleoClim, BioClim}; kwargs...) =
    joinpath(SimpleSDMDatasets._LAYER_PATH, string(PaleoClim))

layers(::RasterData{PaleoClim, BioClim}) = layers(RasterData(CHELSA2, BioClim))
layerdescriptions(::RasterData{PaleoClim, BioClim}) =
    layerdescriptions(RasterData(CHELSA2, BioClim))

resolutions(::RasterData{PaleoClim, BioClim}) = Dict([
    2.5 => ("2_5m", "2.5 arc minutes, approx 4×4 km"),
    5.0 => ("5m", "5 arc minutes"),
    10.0 => ("10m", "10 arc minutes"),
])

extrakeys(::RasterData{PaleoClim, BioClim}) = Dict([
    :timeperiod => (
        "LH" => "Pleistocene: late-Holocene, Meghalayan (4.2-0.3 ka),",
        "MH" => "Pleistocene: mid-Holocene, Northgrippian (8.326-4.2 ka)",
        "EH" => "Pleistocene: early-Holocene, Greenlandian (11.7-8.326 ka)",
        "YDS" => "Pleistocene: Younger Dryas Stadial (12.9-11.7 ka)",
        "BA" => "Pleistocene: Bølling-Allerød ( 14.7-12.9 ka)",
        "HS1" => "Pleistocene: Heinrich Stadial 1 (17.0-14.7 ka)",
        "LIG" => "Pleistocene: Last Interglacial (ca. 130 ka)",
    ),
])

function source(
    data::RasterData{PaleoClim, BioClim};
    timeperiod = "LH",
    resolution = 10.0,
    kwargs...,
)
    rescode = resolutions(data)[resolution][1]
    filename = "$(timeperiod)_v1_$(rescode).zip"
    url = "http://sdmtoolbox.org/paleoclim.org/data/$(timeperiod)/$(filename)"
    outdir = destination(data)
    return (; url, filename, outdir)
end

function layername(
    data::RasterData{PaleoClim, BioClim};
    timeperiod = "LH",
    resolution = 10.0,
    layer = "BIO1",
)
    lname = replace(layer, "BIO" => "bio_")
    rescode = resolutions(data)[resolution][1]
    root = "$(timeperiod)_v1_$(rescode)"
    fname = "$(lname).tif"
    return fname
end