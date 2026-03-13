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
        colormap = @inherit colormap :viridis
        colorrange = @inherit colorrange (0, 1)
    end
end

# CP plot

function _check_trained(model)
    if !istrained(model)
        throw(UntrainedModelError())
    end
    return nothing
end

function _cpplot_data(model, inst, feat, bins)
    _check_trained(model)
    X = instance(model, inst; strict = false)
    x = collect(LinRange(extrema(features(model, feat))..., bins))
    Y = permutedims(repeat(X', length(x)))
    Y[feat, :] .= x
    y = predict(model, Y; threshold = false)
    return (x, y)
end

function _cpplot_data(model, inst, f1, f2, bins)
    _check_trained(model)
    x1 = collect(LinRange(extrema(features(model, f1))..., bins))
    x2 = collect(LinRange(extrema(features(model, f2))..., bins))
    Y = zeros(bins, bins)
    X = instance(model, inst; strict = false)
    for i in eachindex(x1)
        X[f1] = x1[i]
        for j in eachindex(x2)
            X[f2] = x2[j]
            Y[i,j] = predict(model, X; threshold=false)
        end
    end
    return (x1, x2, Y)
end

Makie.@recipe CPPlot (sdm, instance, feature) begin
    _shared_argument_cp_plots()...
end

const OneDimCP = CPPlot{<:Tuple{AbstractSDM, Integer, Integer}}
const TwoDimCP = CPPlot{<:Tuple{AbstractSDM, <:Integer, <:Integer, <:Integer}}

Makie.convert_arguments(::Type{OneDimCP}, sdm::AbstractSDM, inst::Integer, feat::Integer) = (sdm, inst, feat)
Makie.convert_arguments(::Type{TwoDimCP}, sdm::AbstractSDM, inst::Integer, f1::Integer, f2::Integer) = (sdm, inst, [f1, f2])

function Makie.plot!(cp::OneDimCP)
    x, y = _cpplot_data(cp.sdm[], cp.instance[], cp.feature[], cp.bins[])
    if cp.center[] == :midpoint
        x .-= (x[end] + x[begin]) / 2
    end
    if cp.center[] == :value
        x .-= instance(cp.sdm[], cp.instance[]; strict = false)[cp.feature[]]
    end
    plfunc! = cp.stairs[] ? stairs! : lines!
    plfunc!(cp, cp.attributes, x, y)
    return cp
end

function Makie.plot!(cp::TwoDimCP)
    model = cp.arg1[]
    inst = cp.arg2[]
    f1 = cp.arg3[]
    f2 = cp.arg4[]
    x1, x2, y = _cpplot_data(model, inst, f1, f2, cp.bins[])
    if cp.center[] == :midpoint
        x1 .-= (x1[end] + x1[begin]) / 2
        x2 .-= (x2[end] + x2[begin]) / 2
    end
    if cp.center[] == :value
        x1 .-= instance(model, inst; strict = false)[f1]
        x2 .-= instance(model, inst; strict = false)[f2]
    end
    heatmap!(cp, cp.attributes, x1, x2, y)
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
Makie.convert_arguments(::Type{ICEPlot}, sdm::AbstractSDM, y::Int) =
    (sdm, eachindex(labels(sdm)), y)

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
Makie.convert_arguments(
    ::Type{PartialDependencePlot},
    sdm::AbstractSDM,
    y::Int,
) = (sdm, eachindex(labels(sdm)), y)

function Makie.plot!(pdp::PartialDependencePlot)
    x, _ = _cpplot_data(pdp.sdm[], 1, pdp.feature[], pdp.bins[])
    Y = zeros(Float64, pdp.bins[], length(pdp.instances[]))
    for (i, inst) in enumerate(pdp.instances[])
        xᵢ, yᵢ = _cpplot_data(pdp.sdm[], inst, pdp.feature[], pdp.bins[])
        Y[:, i] = yᵢ
    end
    if pdp.center[] == :midpoint
        x .-= (x[end] + x[begin]) / 2
    end
    if pdp.center[] == :value
        @warn "Using center = :value has no effect on a partial dependence plot"
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