# Function to turn a layer into something (Geo)Makie can use
function sprinkle(layer::T) where {T <: SimpleSDMLayer}
    return (
        longitudes(layer),
        latitudes(layer),
        transpose(replace(layer.grid, nothing => NaN)),
    )
end

function sprinkle(records::GBIFRecords)
    lon = Float32.(replace(longitudes(records), missing => NaN))
    lat = Float32.(replace(latitudes(records), missing => NaN))
    return (lon, lat)
end

MakieCore.convert_arguments(
    P::MakieCore.SurfaceLike,
    layer::T,
) where {T <: SimpleSDMLayer} = sprinkle(layer)

MakieCore.convert_arguments(
    P::MakieCore.NoConversion,
    layer::T,
) where {T <: SimpleSDMLayer} = MakieCore.convert_arguments(P, values(layer))

MakieCore.convert_arguments(P::MakieCore.PointBased, records::GBIFRecords) =
    MakieCore.convert_arguments(P, sprinkle(records)...)

function MakieCore.convert_arguments(
    P::MakieCore.PointBased,
    layer1::T1,
    layer2::T2,
) where {T1 <: SimpleSDMLayer, T2 <: SimpleSDMLayer}
    k = intersect(keys(layer1), keys(layer2))
    v1 = replace(layer1[k], nothing => NaN)
    v2 = replace(layer2[k], nothing => NaN)
    return MakieCore.convert_arguments(P, v1, v2)
end