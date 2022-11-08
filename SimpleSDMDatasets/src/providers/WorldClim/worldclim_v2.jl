# Define the datasets that WorldClim2 can provide - all of the entries in this array are `RasterDatasets`
wcdat = [
    BioClim,
    Elevation,
    MinimumTemperature,
    MaximumTemperature,
    AverageTemperature,
    Precipitation,
    SolarRadiation,
    WindSpeed,
    WaterVaporPressure,
]
WorldClim2Dataset = Union{wcdat...}

# Update provisioning
provides(::Type{WorldClim2}, ::Type{T}) where {T <: WorldClim2Dataset} = true

# Update downloadtype
downloadtype(::RasterData{WorldClim2, T}) where {T <: WorldClim2Dataset} = _zip

# Update the resolution
resolutions(::RasterData{WorldClim2, T}) where {T <: WorldClim2Dataset} =
    Dict([0.5 => "30s", 2.5 => "2.5m", 5.0 => "5m", 10.0 => "10m"])

# Update the months
months(::RasterData{WorldClim2, T}) where {T <: WorldClim2Dataset} = Month.(1:12)
months(::RasterData{WorldClim2, BioClim}) = nothing
months(::RasterData{WorldClim2, Elevation}) = nothing

# Update the layers
layers(::RasterData{WorldClim2, BioClim}) = "BIO" .* string.(1:19)

# The following functions are the list of URL codes for the datasets. Note that
# they dispatch on the dataset within the context of WorldClim2
_var_slug(::RasterData{WorldClim2, MinimumTemperature}) = "tmin"
_var_slug(::RasterData{WorldClim2, MaximumTemperature}) = "tmax"
_var_slug(::RasterData{WorldClim2, AverageTemperature}) = "tavg"
_var_slug(::RasterData{WorldClim2, Precipitation}) = "prec"
_var_slug(::RasterData{WorldClim2, SolarRadiation}) = "srad"
_var_slug(::RasterData{WorldClim2, WindSpeed}) = "wind"
_var_slug(::RasterData{WorldClim2, WaterVaporPressure}) = "vapr"
_var_slug(::RasterData{WorldClim2, BioClim}) = "bio"
_var_slug(::RasterData{WorldClim2, Elevation}) = "elev"

# Get the dataset source
function source(
    data::RasterData{WorldClim2, D};
    resolution = 10.0,
    args...,
) where {D <: WorldClim2Dataset}
    res_code = get(resolutions(data), resolution, "10m")
    var_code = _var_slug(data)
    root = "https://geodata.ucdavis.edu/climate/worldclim/2_1/base/"
    stem = "wc2.1_$(res_code)_$(var_code).zip"
    return (
        url = root * stem,
        filename = lowercase(stem),
        outdir = destination(data),
    )
end

function layername(
    data::RasterData{WorldClim2, D};
    resolution = 10.0,
    month = Month(1),
) where {D <: WorldClim2Dataset}
    res_code = get(resolutions(data), resolution, "10m")
    var_code = _var_slug(data)
    layer_code = lpad(string(month.value), 2, '0')
    return "wc2.1_$(res_code)_$(var_code)_$(layer_code).tif"
end

function layername(
    data::RasterData{WorldClim2, BioClim};
    resolution = 10.0,
    layer = "BIO1",
)
    res_code = get(resolutions(data), resolution, "10m")
    var_code = _var_slug(data)
    layer_code = (layer isa Integer) ? layer : findfirst(isequal(layer), layers(data))
    return "wc2.1_$(res_code)_$(var_code)_$(layer_code).tif"
end

function layername(
    data::RasterData{WorldClim2, Elevation};
    resolution = 10.0,
)
    res_code = get(resolutions(data), resolution, "10m")
    var_code = _var_slug(data)
    return "wc2.1_$(res_code)_$(var_code).tif"
end