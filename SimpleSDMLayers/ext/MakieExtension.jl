module MakieExtension

import Makie
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

function Makie.convert_arguments(::Makie.GridBased, layer::SDMLayer)
    return _sprinkle(convert(SDMLayer{Float32}, layer))
end

Makie.convert_arguments(P::Makie.NoConversion, layer::SDMLayer) = Makie.convert_arguments(P, values(layer))

function Makie.convert_arguments( P::Makie.PointBased, layer1::T1, layer2::T2, ) where {T1 <: SDMLayer, T2 <: SDMLayer}
    k = findall(layer1.indices .& layer2.indices)
    return Makie.convert_arguments(P, layer1[k], layer2[k])
end

function Makie.convert_arguments( P::Makie.PointBased, layer::T, ) where {T <: SDMLayer{Bool}}
    return Makie.convert_arguments(P, _sprinkle(ones(nodata(layer, false), Float32))...)
end

end