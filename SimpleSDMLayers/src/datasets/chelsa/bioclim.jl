"""
    SimpleSDMPredictor(CHELSA, BioClim, layer::Integer; left=nothing, right=nothing, bottom=nothing, top=nothing)

Download and prepare bioclim layers from the CHELSA database, and returns
them as an array of `SimpleSDMPredictor`s. Layers are called by their number,
from 1 to 19. The list of available layers is given in a table below.

The keyword argument is `path`, which refers to the path where the function
will look for the geotiff files.

Note that these files are *large* due the fine resolution of the data, and for
this reason this function will return the *integer* version of the layers. Also
note that the bioclim data are only available for the V1 of CHELSA, and are not
from the V2.

It is recommended to *keep* the content of the `path` folder, as it will
eliminate the need to download the tiff files (which are quite large). For
example, calling `bioclim(1:19)` will download and everything, and future
calls will be much faster.
"""
function SimpleSDMPredictor(::Type{CHELSA}, ::Type{BioClim}, layer::Integer=1; kwargs...)
    file = _get_raster(CHELSA, BioClim, layer)
    return geotiff(SimpleSDMPredictor, file; kwargs...)
end

function SimpleSDMPredictor(::Type{CHELSA}, ::Type{BioClim}, layers::AbstractArray; kwargs...)
    @assert eltype(layers) <: Integer
    return [SimpleSDMPredictor(CHELSA, BioClim, l; kwargs...) for l in layers]
end

"""
    SimpleSDMPredictor(CHELSA, BioClim, mod::CMIP5, fut::RepresentativeConcentrationPathway, layer::Integer=1; year="2041-2060", kwargs...)

Returns a *future* layer for a given RCP and model, at a given year (either
2041-2060 or 2061-2080), from the bioclim future climate.
"""
function SimpleSDMPredictor(::Type{CHELSA}, ::Type{BioClim}, mod::CMIP5, fut::RepresentativeConcentrationPathway, layer::Integer=1; year="2041-2060", kwargs...)
    @assert year in ["2041-2060", "2061-2080"]
    file = _get_raster(CHELSA, BioClim, mod, fut, layer, year)
    return geotiff(SimpleSDMPredictor, file; kwargs...)
end

function SimpleSDMPredictor(::Type{CHELSA}, ::Type{BioClim}, mod::CMIP5, fut::RepresentativeConcentrationPathway, layers::AbstractArray; kwargs...)
    @assert eltype(layers) <: Integer
    return [SimpleSDMPredictor(CHELSA, BioClim, mod, fut, l; kwargs...) for l in layers]
end

function SimpleSDMPredictor(::Type{CHELSA}, ::Type{BioClim}, mod::CMIP6, fut::SharedSocioeconomicPathway, layers::AbstractArray; kwargs...)
    @assert eltype(layers) <: Integer
    return [SimpleSDMPredictor(CHELSA, BioClim, mod, fut, l; kwargs...) for l in layers]
end

function SimpleSDMPredictor(::Type{CHELSA}, ::Type{BioClim}, mod::CMIP6, fut::SharedSocioeconomicPathway, layer::Integer=1; year="2041-2060", kwargs...)
    file = _get_raster(CHELSA, BioClim, mod, fut, layer, year)
    return geotiff(SimpleSDMPredictor, file; kwargs...)
end
