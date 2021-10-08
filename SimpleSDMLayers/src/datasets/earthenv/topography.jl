"""
    SimpleSDMPredictor(::Type{EarthEnv}, ::Type{Topography}, layer::Integer=1; resolution::Int64=100, kwargs...)

Allowed resolutions (in km) are 1, 5, 10, 50 (default), and 100

Allowed sources is currently *only* "GMTED"

Allowed aggregations are "mean" (default), "median", "minimum", "maximum", and "std"
"""
function SimpleSDMPredictor(::Type{EarthEnv}, ::Type{Topography}, layer::Integer=1; resolution::Int64=100, source::String="GMTED", aggregation::String="mean", kwargs...)
    @assert resolution in [1, 5, 10, 50, 100]
    @assert source in ["GMTED"]
    @assert aggregation in ["mean", "median", "minimum", "maximum", "std"]
    file = _get_raster(EarthEnv, Topography, layer, resolution, source, aggregation)
    return geotiff(SimpleSDMPredictor, file; kwargs...)
end

function SimpleSDMPredictor(::Type{EarthEnv}, ::Type{Topography}, layers::AbstractArray; kwargs...)
    @assert eltype(layers) <: Integer
    return [SimpleSDMPredictor(EarthEnv, HabitatHeterogeneity, l; kwargs...) for l in layers]
end