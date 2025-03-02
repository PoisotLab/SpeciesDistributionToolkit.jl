blurb(::Type{CHELSA2}) = md"""
CHELSA (Climatologies at high resolution for the earth’s land surface areas) is
a very high resolution (30 arc sec, ~1km) global downscaled climate data set
currently hosted by the Swiss Federal Institute for Forest, Snow and Landscape
Research WSL. It is built to provide free access to high resolution climate data
for research and application, and is constantly updated and refined.

::: details Citations

Karger, D.N., Conrad, O., Böhner, J., Kawohl, T., Kreft, H., Soria-Auza, R.W.,
Zimmermann, N.E., Linder, P., Kessler, M. (2017): Climatologies at high
resolution for the Earth land surface areas. Scientific Data. 4 170122.

Karger D.N., Conrad, O., Böhner, J., Kawohl, T., Kreft, H., Soria-Auza, R.W.,
Zimmermann, N.E, Linder, H.P., Kessler, M. (2018): Data from: Climatologies at
high resolution for the earth’s land surface areas. EnviDat.

:::
"""

CHELSA2Dataset = Union{
    BioClim,
    Precipitation,
    MinimumTemperature,
    MaximumTemperature,
    AverageTemperature,
}

# Update provisioning
provides(::Type{CHELSA2}, ::Type{T}) where {T <: CHELSA2Dataset} = true

url(::Type{CHELSA2}) = "https://chelsa-climate.org/"
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
    root = "https://os.zhdk.cloud.switch.ch/chelsav2/GLOBAL/climatologies/1981-2010/bio/"
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
    root = "https://os.zhdk.cloud.switch.ch/chelsav2/GLOBAL/climatologies/1981-2010/$(var_code)/"
    stem = "CHELSA_$(var_code)_$(month_code)_1981-2010_V.2.1.tif"
    return (
        url = root * stem,
        filename = lowercase(stem),
        outdir = destination(data),
    )
end

@testitem "We have implemented CHELSA v2 properly" begin
    using Dates

    @test CHELSA2 <: RasterProvider

    # Test the interface
    for T in Base.uniontypes(SimpleSDMDatasets.CHELSA2Dataset)
        @test SimpleSDMDatasets.provides(CHELSA2, T)
        data = RasterData(CHELSA2, T)
        @test SimpleSDMDatasets.resolutions(data) |> isnothing
    end

    @test layerdescriptions(RasterData(CHELSA2, BioClim))["BIO1"] ==
          "Annual Mean Temperature"

    @test SimpleSDMDatasets.months(RasterData(CHELSA2, BioClim)) |> isnothing
    @test SimpleSDMDatasets.extrakeys(RasterData(CHELSA2, BioClim)) |> isnothing
    @test SimpleSDMDatasets.layers(RasterData(CHELSA2, BioClim)) |> !isnothing

    @test SimpleSDMDatasets.months(RasterData(CHELSA2, Precipitation)) |> !isnothing
    @test SimpleSDMDatasets.extrakeys(RasterData(CHELSA2, AverageTemperature)) |> isnothing
    @test SimpleSDMDatasets.layers(RasterData(CHELSA2, MinimumTemperature)) |> isnothing

    begin
        out = downloader(RasterData(CHELSA2, BioClim); layer = "BIO12")
        @test isfile(first(out))
        @test out[2] == SimpleSDMDatasets.filetype(RasterData(CHELSA2, BioClim))
    end

    begin
        out = downloader(RasterData(CHELSA2, AverageTemperature); month = Month(6))
        @test isfile(first(out))
        @test out[2] == SimpleSDMDatasets.filetype(RasterData(CHELSA2, AverageTemperature))
    end

    begin
        out = downloader(RasterData(CHELSA2, MinimumTemperature); month = Month(12))
        @test isfile(first(out))
        @test out[2] == SimpleSDMDatasets.filetype(RasterData(CHELSA2, MinimumTemperature))
    end

    begin
        out = downloader(RasterData(CHELSA2, MaximumTemperature); month = Month(1))
        @test isfile(first(out))
        @test out[2] == SimpleSDMDatasets.filetype(RasterData(CHELSA2, MaximumTemperature))
    end

    begin
        out = downloader(RasterData(CHELSA2, Precipitation); month = Month(10))
        @test isfile(first(out))
        @test out[2] == SimpleSDMDatasets.filetype(RasterData(CHELSA2, Precipitation))
    end
end