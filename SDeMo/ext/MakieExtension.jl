module MakieExtension

using Makie
using SDeMo
import SDeMo: ceterisparibus, ceterisparibus!

function Makie.convert_arguments(P::Makie.PointBased, model::T) where {T <: AbstractSDM}
    @assert isgeoreferenced(model)
    return Makie.convert_arguments(P, model.coordinates)
end

Makie.@recipe CeterisParibus (sdm, instance, feature) begin
    bins = 30
    color = @inherit color :black
    linestyle = @inherit linestyle :solid
    linewidth = @inherit linewidth 1
    alpha = @inherit alpha 1.0
    stairs = true
end

Makie.plottype(::CeterisParibus) = Lines
Makie.convert_arguments(::Type{CeterisParibus}, sdm::AbstractSDM, x::Int, y::Int) =
    (sdm, x, y)

function Makie.plot!(cp::CeterisParibus)
    X = instance(cp.sdm[], cp.instance[]; strict = false)
    x = LinRange(extrema(features(cp.sdm[], cp.feature[]))..., cp.bins[])
    Y = permutedims(repeat(X', length(x)))
    Y[cp.feature[], :] .= x
    plfunc! = cp.stairs[] ? stairs! : lines!
    plfunc!(cp, cp.attributes, x, predict(cp.sdm[], Y; threshold = false))
    return cp
end

end