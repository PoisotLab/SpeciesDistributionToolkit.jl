CHELSA1Dataset = Union{
    BioClim,
    AverageTemperature,
    MinimumTemperature,
    MaximumTemperature,
    Precipitation,
}

# Update provisioning
provides(::Type{CHELSA1}, ::Type{T}) where {T <: CHELSA1Dataset} = true

# Update the layers
layers(::RasterData{CHELSA1, BioClim}) = "BIO" .* string.(1:19)

# Months for climate variables
months(::RasterData{CHELSA1, T}) where {T <: CHELSA1Dataset} = Month.(1:12)
months(::RasterData{CHELSA1, BioClim}) = nothing

_var_slug(::RasterData{CHELSA1, MinimumTemperature}) = "tmin"
_var_slug(::RasterData{CHELSA1, MaximumTemperature}) = "tmax"
_var_slug(::RasterData{CHELSA1, AverageTemperature}) = "tmean"
_var_slug(::RasterData{CHELSA1, Precipitation}) = "prec"

function source(data::RasterData{CHELSA1, Precipitation}; month = Month(1))
    var_code = _var_slug(data)
    month_code = lpad(string(month.value), 2, '0')
    root = "https://envicloud.wsl.ch/envicloud/chelsa/chelsa_V1/climatologies/$(var_code)/"
    stem = "CHELSA_$(var_code)_$(month_code)_V1.2_land.tif"
    return (
        url = root * stem,
        filename = lowercase(stem),
        outdir = destination(data),
    )
end

function source(data::RasterData{CHELSA1, T}; month = Month(1)) where {T <: CHELSA1Dataset}
    var_code = _var_slug(data)
    month_code = lpad(string(month.value), 2, '0')
    root = "https://envicloud.wsl.ch/envicloud/chelsa/chelsa_V1/climatologies/$(var_code)/"
    layer_code = (T <: AverageTemperature) ? "temp" : var_code
    stem = "CHELSA_$(layer_code)10_$(month_code)_1979-2013_V1.2_land.tif"
    return (
        url = root * stem,
        filename = lowercase(stem),
        outdir = destination(data),
    )
end

function source(data::RasterData{CHELSA1, BioClim}; layer = "BIO1")
    var_code = (layer isa Integer) ? layer : findfirst(isequal(layer), layers(data))
    var_pad = lpad(string(var_code), 2, '0')
    root = "https://envicloud.wsl.ch/envicloud/chelsa/chelsa_V1/climatologies/bio/"
    stem = "CHELSA_bio10_$(var_pad).tif"
    return (
        url = root * stem,
        filename = lowercase(stem),
        outdir = destination(data),
    )
end