url(::RasterData{Copernicus, LandCover}) = "https://zenodo.org/records/3939050"

blurb(::RasterData{Copernicus, LandCover}) = md"""
Near real time epoch 2019 from the Collection 3 of annual, global 100m land
cover maps.

Produced by the global component of the Copernicus Land Service, derived from
PROBA-V satellite observations and ancillary datasets.

:::details Citation

Marcel Buchhorn, Bruno Smets, Luc Bertels, Bert De Roo, Myroslava Lesiv,
Nandin-Erdene Tsendbazar, Martin Herold, & Steffen Fritz. (2020). Copernicus
Global Land Service: Land Cover 100m: collection 3: epoch 2019: Globe (V3.0.1)
[Data set]. Zenodo. https://doi.org/10.5281/zenodo.3939050

:::

"""

# Update the layers
layers(::RasterData{Copernicus, LandCover}) = [
    "Bare",
    "Built-up",
    "Crops",
    "Grass",
    "Moss and lichen",
    "Permanent water",
    "Seasonal water",
    "Shrubs",
    "Snow",
    "Trees",
    "Classification",
    "Forest type"
]

function __copernify(str)
    varnames = Dict(
        "Bare" => "Bare-CoverFraction-layer",
        "Built-up" => "BuiltUp-CoverFraction-layer",
        "Crops" => "Crops-CoverFraction-layer",
        "Grass" => "Grass-CoverFraction-layer",
        "Moss and Lichen" => "MossLichen-CoverFraction-layer",
        "Permanent water" => "PermanentWater-CoverFraction-layer",
        "Seasonal water" => "SeasonalWater-CoverFraction-layer",
        "Shrubs" => "Shrub-CoverFraction-layer",
        "Snow" => "Snow-CoverFraction-layer",
        "Trees" => "Tree-CoverFraction-layer",
        "Classification" => "Discrete-Classification-map",
        "Forest type" => "Forest-Type-layer",
    )
    
    return varnames[str]
end

function source(
    data::RasterData{Copernicus, LandCover};
    layer = "Classification",
)
    var_code = __copernify(layer)
    dlurl = "https://zenodo.org/records/3939050/files/PROBAV_LC100_global_v3.0.1_2019-nrt_$(var_code)_EPSG-4326.tif?download=1"
    return (
        url = dlurl,
        filename = lowercase("PROBAV_LC100_global_v3.0.1_2019-nrt_$(var_code)_EPSG-4326.tif"),
        outdir = destination(data),
    )
end