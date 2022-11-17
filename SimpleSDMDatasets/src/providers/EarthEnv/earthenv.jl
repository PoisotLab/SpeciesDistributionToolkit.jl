EarthEnvDataset = Union{LandCover, HabitatHeterogeneity}

# Update provisioning
provides(::Type{EarthEnv}, ::Type{T}) where {T <: EarthEnvDataset} = true

# Additional keys for search
extrakeys(::RasterData{EarthEnv, LandCover}) = Dict([:full => (true, false)])

url(::RasterData{EarthEnv, LandCover}) = "https://www.earthenv.org/landcover"
url(::RasterData{EarthEnv, HabitatHeterogeneity}) = "https://www.earthenv.org/texture"

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
