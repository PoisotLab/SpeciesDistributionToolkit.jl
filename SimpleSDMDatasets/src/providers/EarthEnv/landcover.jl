url(::RasterData{EarthEnv, LandCover}) = "https://www.earthenv.org/landcover"

blurb(::RasterData{EarthEnv, LandCover}) = md"""
The dataset integrates multiple global remote sensing-derived land-cover
products and provide consensus information on the prevalence of 12 land-cover
classes at 1-km resolution. For additional information about the integration
approach and the evaluations of the datasets, please see the associated journal
article:

Tuanmu, M.-N. and W. Jetz. 2014. A global 1-km consensus land-cover product for
biodiversity and ecosystem modeling. Global Ecology and Biogeography 23(9):
1031-1045.
"""

# Additional keys for search
extrakeys(::RasterData{EarthEnv, LandCover}) = Dict([
    :full => (
        true => "Version with GlobCover (2005-06; v2.2), MODIS land-cover product (MCD12Q1; v051), GLC2000 (global product; v1.1), and DISCover (GLCC; v2)",
        false => "Version without DISCover",
    ),
])

# Update the layers
layers(::RasterData{EarthEnv, LandCover}) = [
    "Evergreen/Deciduous Needleleaf Trees",
    "Evergreen Broadleaf Trees",
    "Deciduous Broadleaf Trees",
    "Mixed/Other Trees",
    "Shrubs",
    "Herbaceous Vegetation",
    "Cultivated and Managed Vegetation",
    "Regularly Flooded Vegetation",
    "Urban/Built-up",
    "Snow/Ice",
    "Barren",
    "Open Water",
]

function source(
    data::RasterData{EarthEnv, LandCover};
    layer = "Urban/Built-up",
    full = true,
)
    var_code =
        (layer isa Integer) ? layer : findfirst(isequal(layer), layers(data))
    root = if full
        "https://data.earthenv.org/consensus_landcover/with_DISCover/"
    else
        "https://data.earthenv.org/consensus_landcover/without_DISCover/"
    end
    stem = if full
        "consensus_full_class_$(var_code).tif"
    else
        "Consensus_reduced_class_$(var_code).tif"
    end
    return (
        url = root * stem,
        filename = lowercase(stem),
        outdir = destination(data),
    )
end