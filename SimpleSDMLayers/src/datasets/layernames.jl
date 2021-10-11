layernames(::Type{WorldClim}, ::Type{Elevation}) = ("Elevation",)

function layernames(::Type{WorldClim}, ::Type{BioClim})
    return (
        "Annual Mean Temperature",
        "Mean Diurnal Range",
        "Isothermality",
        "Temperature Seasonality",
        "Max Temperature of Warmest Month",
        "Min Temperature of Coldest Month",
        "Temperature Annual Range",
        "Mean Temperature of Wettest Quarter",
        "Mean Temperature of Driest Quarter",
        "Mean Temperature of Warmest Quarter",
        "Mean Temperature of Coldest Quarter",
        "Annual Precipitation",
        "Precipitation of Wettest Month",
        "Precipitation of Driest Month",
        "Precipitation Seasonality",
        "Precipitation of Wettest Quarter",
        "Precipitation of Driest Quarter",
        "Precipitation of Warmest Quarter",
        "Precipitation of Coldest Quarter",
    )
end

layernames(::Type{CHELSA}, ::Type{BioClim}) = layernames(WorldClim, BioClim)

function layernames(::Type{EarthEnv}, ::Type{HabitatHeterogeneity})
    return (
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
    )
end

function layernames(::Type{EarthEnv}, ::Type{LandCover})
    return (
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
    )
end

function layernames(::Type{EarthEnv}, ::Type{Topography})
    return (
        "Elevation",
        "Slope",
        "Aspect Cosine",
        "Aspect Sine",
        "Aspect Eastness",
        "Aspect Northness",
        "Roughness",
        "Topographic Position Index",
        "Terrain Ruggedness Index",
        "Vector Ruggedness Measure",
        "∂(E-W slope)",
        "∂²(E-W slope)",
        "∂(N-S slope)",
        "∂²(N-S slope)",
        "Profile curvature",
        "Tangential curvature"
    )
end

layernames(p::Type{<:LayerProvider}, d::Type{<:LayerDataset}, i::Int) = layernames(p, d)[i]
layernames(p::Type{<:LayerProvider}, d::Type{<:LayerDataset}, i::AbstractArray) = layernames(p, d)[i]