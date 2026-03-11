module MakieExtension

import Makie
using SDeMo
import SDeMo: ceterisparibus, ceterisparibus!

function Makie.convert_arguments(P::Makie.PointBased, model::T) where {T <: AbstractSDM}
    @assert isgeoreferenced(model)
    return Makie.convert_arguments(P, model.coordinates)
end

@recipe CeterisParibus (model, instance, feature) begin
    Makie.@DocumentedAttributes begin
        """
        Number of bins in which the range of the value is divided
        """
        bins = 30
    end
end

Makie.plottype(::CeterisParibus) = PointBased
Makie.convert_arguments(::Type{CeterisParibus}, model::AbstractSDM, x::Int, y::Int) =
    (model, x, y)

function Makie.plot!(cp::CeterisParibus)
    X = instance(cp.model[], cp.instance[]; strict=false)
    x = LinRange(extrema(features(cp.model[], cp.feature[]))..., cp.bins[])
    Y = permutedims(repeat(X', length(x)))
    Y[j, :] .= x
    stairs!(cp, x, predict(model, Y; threshold=false))
    return cp
end

end