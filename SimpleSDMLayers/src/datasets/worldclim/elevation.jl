function SimpleSDMPredictor(::Type{WorldClim}, ::Type{Elevation}, layer::Integer=1; resolution::Float64=10.0, kwargs...)
    @assert resolution in [0.5, 2.5, 5.0, 10.0]
    file = _get_raster(WorldClim, Elevation, layer, resolution)
    return geotiff(SimpleSDMPredictor, file; kwargs...)
end