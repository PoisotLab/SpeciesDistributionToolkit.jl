"""
Download and prepare WorldClim 2.0 bioclimatic variables, and returns them as
an array of `SimpleSDMPredictor`s. Layers are called by their number, from 1 to
19. The list of available layers is given in a table below.

The two keywords are `resolution`, which must be a string, and either `2.5`,
`5`, or `10`; and `path`, which refers to the path where the function will look
for the zip and geotiff files.

Internally, this function will download the main zip file for the required
resolution from the WordlClim website, extract it, and parse the required
layers.

It is recommended to *keep* the content of the `path` folder, as it will
eliminate the need to download and/or extract the tiff files. For example,
calling `wordlclim(1:19)` will download and extract everything, and future
calls will be much faster.

| Variable | Description                                                |
| ------   | ------                                                     |
| 1        | Annual Mean Temperature                                    |
| 2        | Mean Diurnal Range (Mean of monthly (max temp - min temp)) |
| 3        | Isothermality (BIO2/BIO7) (* 100)                          |
| 4        | Temperature Seasonality (standard deviation *100)          |
| 5        | Max Temperature of Warmest Month                           |
| 6        | Min Temperature of Coldest Month                           |
| 7        | Temperature Annual Range (BIO5-BIO6)                       |
| 8        | Mean Temperature of Wettest Quarter                        |
| 9        | Mean Temperature of Driest Quarter                         |
| 10       | Mean Temperature of Warmest Quarter                        |
| 11       | Mean Temperature of Coldest Quarter                        |
| 12       | Annual Precipitation                                       |
| 13       | Precipitation of Wettest Month                             |
| 14       | Precipitation of Driest Month                              |
| 15       | Precipitation Seasonality (Coefficient of Variation)       |
| 16       | Precipitation of Wettest Quarter                           |
| 17       | Precipitation of Driest Quarter                            |
| 18       | Precipitation of Warmest Quarter                           |
| 19       | Precipitation of Coldest Quarter                           |

"""
function worldclim(layers::Vector{Int64}; resolution::AbstractString="10", path::AbstractString="assets")
    @assert all(1 .≤ layers .≤ 19)
    isdir(path) || mkdir(path)
    @assert resolution ∈ ["2.5", "5", "10"]
    codes = [lpad(code, 2, "0") for code in layers]
    paths = [joinpath(path, "wc2.0_bio_$(resolution)m_$(code).tif") for code in codes]

    #=
    Download the files if they are missing. In order of preference, this
    function will extract from the zip file if found, and download the zip file
    if not.
    =#
    missing_files = !all(isfile.(paths))
    zip_file = "wc2.0_bio$(resolution)m.zip"
    missing_zip_file = !isfile(joinpath(path, zip_file))
    if missing_files
        if missing_zip_file
            @info "Downloading $(zip_file)"
            download("http://biogeo.ucdavis.edu/data/worldclim/v2.0/tif/base/wc2.0_$(resolution)m_bio.zip", joinpath(path, zip_file))
        end
        zf = ZipFile.Reader(joinpath(path, zip_file))
        for rf in zf.files
            if joinpath(path, rf.name) in paths
                if !isfile(joinpath(path, rf.name))
                    @info "Reading layer $(rf.name) from archive"
                    write(joinpath(path, rf.name), read(rf))
                end
            end
        end
        close(zf)
    end

    data_layers = geotiff.(paths)

    return SimpleSDMPredictor.(data_layers, -180.0, 180.0, -90.0, 90.0)

end

"""
Return a single layer from WorldClim 2.0.
"""
worldclim(layer::Int64; x...) = worldclim([layer]; x...)[1]

worldclim(layers::UnitRange{Int64}; x...) = worldclim(collect(layers); x...)
