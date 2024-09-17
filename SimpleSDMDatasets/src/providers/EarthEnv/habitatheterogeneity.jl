
url(::RasterData{EarthEnv, HabitatHeterogeneity}) = "https://www.earthenv.org/texture"
blurb(::RasterData{EarthEnv, HabitatHeterogeneity}) = md"""
The dataset contains 14 metrics quantifying spatial heterogeneity of global
habitat at multiple resolutions based on the textural features of Enhanced
Vegetation Index (EVI) imagery acquired by the Moderate Resolution Imaging
Spectroradiometer (MODIS). For additional information about the metrics and the
evaluations of their utility for biodiversity modeling, please see the
associated journal article:

:::details Citation
Tuanmu, M.-N. and W. Jetz. (2015) A global, remote sensing-based
characterization of terrestrial habitat heterogeneity for biodiversity and
ecosystem modeling. Global Ecology and Biogeography. DOI: 10.1111/geb.12365.
:::
"""

layers(::RasterData{EarthEnv, HabitatHeterogeneity}) = [
    "Coefficient of variation",
    "Evenness",
    "Range",
    "Shannon",
    "Simpson",
    "Standard deviation",
    "Contrast",
    "Correlation",
    "Dissimilarity",
    "Entropy",
    "Homogeneity",
    "Maximum",
    "Uniformity",
    "Variance",
]

resolutions(::RasterData{EarthEnv, HabitatHeterogeneity}) =
    Dict([0.5 => "1km", 2.5 => "5km", 12.5 => "25km"])

function source(
    data::RasterData{EarthEnv, HabitatHeterogeneity};
    layer = "Uniformity",
    resolution = 12.5,
)
    var_code =
        (layer isa Integer) ? layer : findfirst(isequal(layer), layers(data))
    # This bit is required because the value encoding is specified in the file
    # name, and also varies arbitrarily between files
    file_enc = "uint16"
    if var_code in [7, 9, 14]
        file_enc = "uint32"
    end
    if (var_code == 10) & (resolution == 12.5)
        file_enc = "uint32"
    end
    if (var_code == 1) & (resolution == 2.5)
        file_enc = "uint32"
    end
    # OK done.
    file_codes = [
        "cv",
        "evenness",
        "range",
        "shannon",
        "simpson",
        "std",
        "Contrast",
        "Correlation",
        "Dissimilarity",
        "Entropy",
        "Homogeneity",
        "Maximum",
        "Uniformity",
        "Variance",
    ]
    res_code = get(resolutions(data), resolution, "25km")
    root = "https://data.earthenv.org/habitat_heterogeneity/$(res_code)/"
    stem = "$(file_codes[var_code])_01_05_$(res_code)_$(file_enc).tif"
    return (
        url = root * stem,
        filename = lowercase(stem),
        outdir = destination(data),
    )
end