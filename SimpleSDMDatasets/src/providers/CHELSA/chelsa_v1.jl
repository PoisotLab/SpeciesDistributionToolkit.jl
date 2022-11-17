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
layerdescriptions(::RasterData{CHELSA1, BioClim}) = Dict([
    "BIO1" => "Annual Mean Temperature",
    "BIO2" => "Mean Diurnal Range (Mean of monthly (max temp - min temp))",
    "BIO3" => "Isothermality (BIO2/BIO7) (×100)",
    "BIO4" => "Temperature Seasonality (standard deviation ×100)",
    "BIO5" => "Max Temperature of Warmest Month",
    "BIO6" => "Min Temperature of Coldest Month",
    "BIO7" => "Temperature Annual Range (BIO5-BIO6)",
    "BIO8" => "Mean Temperature of Wettest Quarter",
    "BIO9" => "Mean Temperature of Driest Quarter",
    "BIO10" => "Mean Temperature of Warmest Quarter",
    "BIO11" => "Mean Temperature of Coldest Quarter",
    "BIO12" => "Annual Precipitation",
    "BIO13" => "Precipitation of Wettest Month",
    "BIO14" => "Precipitation of Driest Month",
    "BIO15" => "Precipitation Seasonality (Coefficient of Variation)",
    "BIO16" => "Precipitation of Wettest Quarter",
    "BIO17" => "Precipitation of Driest Quarter",
    "BIO18" => "Precipitation of Warmest Quarter",
    "BIO19" => "Precipitation of Coldest Quarter",
])

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
