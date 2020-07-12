function raster(::type{IT}, source::ST; layer::Integer=1, left=nothing, right=nothing, bottom=nothing, top=nothing) where {IT <: SimpleSDMLayer, LT <: SimpleSDMSource}
    file = download_layer(x, layer)
    left = isnothing(left) ? minimum(longitudes(ST))
    right = isnothing(right) ? maximum(longitudes(ST))
    bottom = isnothing(bottom) ? minimum(latitudes(ST))
    top = isnothing(top) ? maximum(latitudes(ST))
    return geotiff(IT, ST, file; left=left, right=right, bottom=bottom, top=top)
end
