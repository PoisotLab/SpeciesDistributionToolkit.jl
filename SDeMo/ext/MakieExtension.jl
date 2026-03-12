module MakieExtension

using Makie
using Statistics
using SDeMo
import SDeMo:
    cpplot, cpplot!, iceplot, iceplot!, partialdependenceplot, partialdependenceplot!

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

# CP plot

function _cpplot_data(model, inst, feat, bins)
    X = instance(model, inst; strict = false)
    x = collect(LinRange(extrema(features(model, feat))..., bins))
    Y = permutedims(repeat(X', length(x)))
    Y[feat, :] .= x
    y = predict(model, Y; threshold = false)
    return (x, y)
end

Makie.@recipe CPPlot (sdm, instance, feature) begin
    _shared_argument_cp_plots()...
end

Makie.plottype(::CPPlot) = Lines
Makie.convert_arguments(::Type{CPPlot}, sdm::AbstractSDM, x::Int, y::Int) =
    (sdm, x, y)

function Makie.plot!(cp::CPPlot)
    x, y = _cpplot_data(cp.sdm[], cp.instance[], cp.feature[], cp.bins[])
    if cp.center[] == :midpoint
        x .-= (x[end] - x[begin]) / 2
    end
    if cp.center[] == :value
        x .-= instance(cp.sdm[], cp.instance[]; strict = false)[cp.feature[]]
    end
    plfunc! = cp.stairs[] ? stairs! : lines!
    plfunc!(cp, cp.attributes, x, y)
    return cp
end

# ICE plot

Makie.@recipe ICEPlot (sdm, instances, feature) begin
    _shared_argument_cp_plots()...
end

Makie.plottype(::ICEPlot) = Lines
Makie.convert_arguments(::Type{ICEPlot}, sdm::AbstractSDM, x::Colon, y::Int) =
    (sdm, eachindex(labels(sdm)), y)
Makie.convert_arguments(::Type{ICEPlot}, sdm::AbstractSDM, x::AbstractRange, y::Int) =
    (sdm, collect(x), y)
Makie.convert_arguments(::Type{ICEPlot}, sdm::AbstractSDM, x::Vector{Int}, y::Int) =
    (sdm, x, y)

function Makie.plot!(ice::ICEPlot)
    for i in ice.instances[]
        cpplot!(ice, ice.attributes, ice.sdm[], i, ice.feature[])
    end
    return ice
end

# PCP plot

Makie.@recipe PartialDependencePlot (sdm, instances, feature) begin
    _shared_argument_cp_plots()...
    ribbon = nothing # Or a function for the ribbon
    background = :grey80
end

Makie.plottype(::PartialDependencePlot) = Lines
Makie.convert_arguments(::Type{PartialDependencePlot}, sdm::AbstractSDM, x::Colon, y::Int) =
    (sdm, eachindex(labels(sdm)), y)
Makie.convert_arguments(
    ::Type{PartialDependencePlot},
    sdm::AbstractSDM,
    x::AbstractRange,
    y::Int,
) = (sdm, collect(x), y)
Makie.convert_arguments(
    ::Type{PartialDependencePlot},
    sdm::AbstractSDM,
    x::Vector{Int},
    y::Int,
) = (sdm, x, y)

function Makie.plot!(pdp::PartialDependencePlot)
    x, _ = _cpplot_data(pdp.sdm[], 1, pdp.feature[], pdp.bins[])
    Y = zeros(Float64, pdp.bins[], length(pdp.instances[]))
    for (i, inst) in enumerate(pdp.instances[])
        xᵢ, yᵢ = _cpplot_data(pdp.sdm[], inst, pdp.feature[], pdp.bins[])
        Y[:, i] = yᵢ
    end
    μ = dropdims(mapslices(Statistics.mean, Y; dims = 2); dims = 2)
    if !isnothing(pdp.ribbon[])
        r = dropdims(mapslices(pdp.ribbon[], Y; dims = 2); dims = 2)
        band!(pdp, x, μ .- r, μ .+ r; color = pdp.background[])
    end
    plfunc! = pdp.stairs[] ? stairs! : lines!
    plfunc!(pdp, pdp.attributes, x, μ)
    return pdp
end

end