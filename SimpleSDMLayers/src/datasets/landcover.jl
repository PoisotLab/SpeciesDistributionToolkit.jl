"""
Get the correct URL for a variable with or without discover, returns a pair filename => url
"""
function _landcover_variable_url(variable_index::T, full::Bool) where { T<: Integer}
    if full
        return "landcover_full_$(variable_index).tif" => "https://data.earthenv.org/consensus_landcover/with_DISCover/consensus_full_class_$(variable_index).tif"
    end
    return "landcover_reduced_$(variable_index).tif" => "https://data.earthenv.org/consensus_landcover/without_DISCover/Consensus_reduced_class_$(variable_index).tif" 
end

"""
    landcover(layers::Vector{T}; full::Bool=false, path::AbstractString="assets") where {T <: Integer}

Download and prepare the EarthEnv consensus landcover data, and returns them as
an array of `SimpleSDMPredictor`s. Layers are called by their number, from 1 to
19. The list of available layers is given in a table below. The raw data come
from https://www.earthenv.org/landcover.

THe `full` keyword indicates whether the *DISCover* information must be
included. Quoting from the reference website:

> Although DISCover is based on older remote sensing imagery (1992-1993), it
> contains some complementary information which is useful for capturing
> sub-pixel land cover heterogeneity (please see the associated article for
> details). Therefore, it is recommended to use the full version of the
> consensus land cover dataset for most applications. However, the reduced
> version may provide an alternative for applications in regions with large land
> cover change in the past two decades.

Internally, this function will download the main zip file for the required
version of the data, extract it, and parse the required layers.

It is recommended to *keep* the content of the `path` folder, as it will
eliminate the need to download and/or extract the tiff files. For example,
calling `landcover(1:12)` will download and extract everything, and future calls
will be much faster. Please keep in mind that the layers can be quite large, so
keeping the models stored is particularly important.

| Variable |             Description              |
| -------- | ------------------------------------ |
| 1        | Evergreen/Deciduous Needleleaf Trees |
| 2        | Evergreen Broadleaf Trees            |
| 3        | Deciduous Broadleaf Trees            |
| 4        | Mixed/Other Trees                    |
| 5        | Shrubs                               |
| 6        | Herbaceous Vegetation                |
| 7        | Cultivated and Managed Vegetation    |
| 8        | Regularly Flooded Vegetation         |
| 9        | Urban/Built-up                       |
| 10       | Snow/Ice                             |
| 11       | Barren                               |
| 12       | Open Water                           |

These data are released under a CC-BY-NC license to Tuanmu & Jetz.
"""
function landcover(layers::Vector{T}; full::Bool=false, path::AbstractString="assets") where {T <: Integer}
    all(1 .≤ layers .≤ 12) || throw(ArgumentError("The number of the layers must all be between 1 and 12"))
    isdir(path) || mkdir(path)

    layer_information = _landcover_variable_url.(layers)

    data_layers = []

    for model_pair in layer_information
        if !isfile(joinpath(path, model_pair.first))
            @info "Downloading $(model_pair.first)"
            layerrequest = HTTP.request("GET", model_pair.second)
            open(joinpath(path, model_pair.first), "w") do layerfile
                write(layerfile, String(layerrequest.body))
            end
        end
        push!(data_layers, geotiff(joinpath(path, model_pair.first)))
    end

    return SimpleSDMPredictor.(data_layers, -180.0, 180.0, -90.0, 90.0)
end

"""
    landcover(layer::T; x...) where {T <: Integer}

Return a single layer from EarthEnv landcover
"""
landcover(layer::T; x...) where {T <: Integer} = first(landcover([layer]; x...))

"""
    landcover(layers::UnitRange{T}; x...) where {T <: Integer}

Return a range of layers from EarthEnv landcover
"""
landcover(layers::UnitRange{T}; x...) where {T <: Integer} = landcover(collect(layers); x...)
