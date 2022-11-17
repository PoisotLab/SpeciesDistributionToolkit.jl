CHELSA2Dataset = Union{
    BioClim,
    Precipitation,
    MinimumTemperature,
    MaximumTemperature,
    AverageTemperature,
}

# Update provisioning
provides(::Type{CHELSA2}, ::Type{T}) where {T <: CHELSA2Dataset} = true

url(::RasterData{CHELSA2, D}) where {D <: CHELSA2Dataset} = "https://chelsa-climate.org/"

# Update the layers
layers(::RasterData{CHELSA2, BioClim}) = "BIO" .* string.(1:19)
layerdescriptions(::RasterData{CHELSA2, BioClim}) = Dict([
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

# Months
months(::RasterData{CHELSA2, T}) where {T <: CHELSA2Dataset} = Month.(1:12)
months(::RasterData{CHELSA2, BioClim}) = nothing

# slugs for the variables
_var_slug(::RasterData{CHELSA2, Precipitation}) = "pr"
_var_slug(::RasterData{CHELSA2, MinimumTemperature}) = "tasmin"
_var_slug(::RasterData{CHELSA2, MaximumTemperature}) = "tas"
_var_slug(::RasterData{CHELSA2, AverageTemperature}) = "tasmax"
_var_slug(::RasterData{CHELSA2, BioClim}) = "bio"

# Get the dataset source
function source(data::RasterData{CHELSA2, BioClim}; layer = "BIO1")
    var_code = (layer isa Integer) ? layer : findfirst(isequal(layer), layers(data))
    root = "https://envicloud.wsl.ch/envicloud/chelsa/chelsa_V2/GLOBAL/climatologies/1981-2010/bio/"
    stem = "CHELSA_bio$(var_code)_1981-2010_V.2.1.tif"
    return (
        url = root * stem,
        filename = lowercase(stem),
        outdir = destination(data),
    )
end

function source(data::RasterData{CHELSA2, T}; month = Month(1)) where {T <: CHELSA2Dataset}
    var_code = _var_slug(data)
    month_code = lpad(string(month.value), 2, '0')
    root = "https://envicloud.wsl.ch/envicloud/chelsa/chelsa_V2/GLOBAL/climatologies/1981-2010/$(var_code)/"
    stem = "CHELSA_$(var_code)_$(month_code)_1981-2010_V.2.1.tif"
    return (
        url = root * stem,
        filename = lowercase(stem),
        outdir = destination(data),
    )
end
