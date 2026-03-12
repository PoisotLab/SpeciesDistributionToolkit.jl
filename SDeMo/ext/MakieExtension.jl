module MakieExtension

using Makie
using SDeMo
import SDeMo: cpplot, cpplot!, iceplot, iceplot!

function Makie.convert_arguments(P::Makie.PointBased, model::T) where {T <: AbstractSDM}
    @assert isgeoreferenced(model)
    return Makie.convert_arguments(P, model.coordinates)
end

function _shared_argument_cp_plots()
    return Makie.@DocumentedAttributes begin
        bins = 30
        color = @inherit color :black
        linestyle = @inherit linestyle :solid
        linewidth = @inherit linewidth 1
        alpha = @inherit alpha 1.0
        stairs = true
        center = :none # Alt values :midpoint, :value
    end
end

Makie.@recipe CPPlot (sdm, instance, feature) begin
    _shared_argument_cp_plots()...
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
        x .-= (x[end] - x[begin]) / 2
    end
    if cp.center[] == :value
        x .-= X[cp.feature[]]
    end
    plfunc! = cp.stairs[] ? stairs! : lines!
    plfunc!(cp, cp.attributes, x, predict(cp.sdm[], Y; threshold = false))
    return cp
end

Makie.@recipe ICEPlot (sdm, instances, feature) begin
    _shared_argument_cp_plots()...
end


Makie.plottype(::ICEPlot) = Lines
Makie.convert_arguments(::Type{ICEPlot}, sdm::AbstractSDM, x::Colon, y::Int) = (sdm, eachindex(labels(sdm)), y)
Makie.convert_arguments(::Type{ICEPlot}, sdm::AbstractSDM, x::AbstractRange, y::Int) = (sdm, collect(x), y)
Makie.convert_arguments(::Type{ICEPlot}, sdm::AbstractSDM, x::Vector{Int}, y::Int) = (sdm, x, y)

function Makie.plot!(ice::ICEPlot)
    for i in ice.instances[]
        cpplot!(ice, ice.attributes, ice.sdm[], i, ice.feature[])
    end
    return ice
end

end