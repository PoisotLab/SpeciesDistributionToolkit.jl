# Function to turn a layer into something (Geo)Makie can use
function sprinkle(layer::T) where {T <: SimpleSDMLayer}
    return (
        longitudes(layer),
        latitudes(layer),
        transpose(replace(layer.grid, nothing => NaN)),
    )
end

# Surface-like plot for a layer
MakieCore.convert_arguments(P::MakieCore.SurfaceLike, layer::T) where {T <: SimpleSDMLayer} = sprinkle(layer)

# Scatter-like plot for GBIFRecords
MakieCore.convert_arguments(P::MakieCore.PointBased, records::GBIFRecords) = (longitudes(records), latitudes(records))