module MakieExtension

using Makie
using SDeMo
import SDeMo: cpplot, cpplot!

function Makie.convert_arguments(P::Makie.PointBased, model::T) where {T <: AbstractSDM}
    @assert isgeoreferenced(model)
    return Makie.convert_arguments(P, model.coordinates)
end

Makie.@recipe CPPlot (sdm, instance, feature) begin
    bins = 30
    color = @inherit color :black
    linestyle = @inherit linestyle :solid
    linewidth = @inherit linewidth 1
    alpha = @inherit alpha 1.0
    stairs = true
    center = :none # Alt values :midpoint, :value
end

Makie.plottype(::CPPlot) = Lines
Makie.convert_arguments(::Type{CPPlot}, sdm::AbstractSDM, x::Int, y::Int) =
    (sdm, x, y)

function Makie.plot!(cp::CPPlot)
    X = instance(cp.sdm[], cp.instance[]; strict = false)
    x = collect(LinRange(extrema(features(cp.sdm[], cp.feature[]))..., cp.bins[]))
    Y = permutedims(repeat(X', length(x)))
    Y[cp.feature[], :] .= x
    if cp.center[] == :midpoint
        x .-= (x[end]-x[begin])/2
    end
    if cp.center[] == :value
        x .-= X[cp.feature[]]
    end
    plfunc! = cp.stairs[] ? stairs! : lines!
    plfunc!(cp, cp.attributes, x, predict(cp.sdm[], Y; threshold = false))
    return cp
end

end