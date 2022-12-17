# Function to turn a layer into something (Geo)Makie can use
function sprinkle(layer::T) where {T <: SimpleSDMLayer}
    return (
        longitudes(layer),
        latitudes(layer),
        transpose(replace(layer.grid, nothing => NaN)),
    )
end

MakieCore.convert_arguments(P::MakieCore.SurfaceLike, layer::T) where {T <: SimpleSDMLayer} = sprinkle(layer)