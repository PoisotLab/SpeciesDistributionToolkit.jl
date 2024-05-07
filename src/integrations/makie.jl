function sprinkle(layer::SDMLayer)
    content = copy(layer.grid)
    content[.!layer.indices] .= NaN
    return (
        eastings(layer),
        northings(layer),
        transpose(content),
    )
end

function sprinkle(records::GBIFRecords)
    lon = Float32.(replace(eastings(records), missing => NaN))
    lat = Float32.(replace(northings(records), missing => NaN))
    return (lon, lat)
end

function MakieCore.convert_arguments(::MakieCore.GridBased, layer::SDMLayer)
    return sprinkle(convert(SDMLayer{Float32}, layer))
end

MakieCore.convert_arguments(P::MakieCore.NoConversion, layer::SDMLayer) =
    MakieCore.convert_arguments(P, values(layer))
MakieCore.convert_arguments(P::MakieCore.PointBased, records::GBIFRecords) =
    MakieCore.convert_arguments(P, sprinkle(records)...)

function MakieCore.convert_arguments(
    P::MakieCore.PointBased,
    layer1::T1,
    layer2::T2,
) where {T1 <: SDMLayer, T2 <: SDMLayer}
    k = layer1.indices .& layer2.indices
    return MakieCore.convert_arguments(P, layer1[k], layer2[k])
end