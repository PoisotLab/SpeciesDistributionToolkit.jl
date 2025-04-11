module MakieExtension

using MakieCore
using SimpleSDMLayers

function _sprinkle(layer::SDMLayer)
    content = copy(layer.grid)
    content[.!layer.indices] .= NaN
    return (
        eastings(layer),
        northings(layer),
        transpose(content),
    )
end

function MakieCore.convert_arguments(::MakieCore.GridBased, layer::SDMLayer)
    return _sprinkle(convert(SDMLayer{Float32}, layer))
end

MakieCore.convert_arguments(P::MakieCore.NoConversion, layer::SDMLayer) = MakieCore.convert_arguments(P, values(layer))

function MakieCore.convert_arguments( P::MakieCore.PointBased, layer1::T1, layer2::T2, ) where {T1 <: SDMLayer, T2 <: SDMLayer}
    k = findall(layer1.indices .& layer2.indices)
    return MakieCore.convert_arguments(P, layer1[k], layer2[k])
end

function MakieCore.convert_arguments( P::MakieCore.PointBased, layer::T, ) where {T <: SDMLayer{Bool}}
    return MakieCore.convert_arguments(P, _sprinkle(ones(nodata(layer, false), Float32))...)
end

end