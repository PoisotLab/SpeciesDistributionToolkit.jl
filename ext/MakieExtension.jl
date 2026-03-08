module MakieExtension

using SpeciesDistributionToolkit
import SpeciesDistributionToolkit:
    graticulebox, graticulebox!, graticulegrid, graticulegrid!, enlargelimits!
using Makie

function _to_dms(dec::Float64, north = false)
    D = round(Int, trunc(dec))
    M = round(Int, trunc(60 * abs(dec - D)))
    S = round(Int, 3600 * abs(dec - D) - 60 * M)
    str = "$(abs(D))°"
    if M != 0
        str *= " $(M)′"
        if S != 0
            str *= " $(S)″"
        end
    end
    if D >= 0
        if north
            str *= " N"
        else
            str *= " E"
        end
    else
        if north
            str *= " S"
        else
            str *= " W"
        end
    end
    return str
end

function _return_isolines(m, M, nmin, nideal, nmax)
    return first(
        Makie.PlotUtils.optimize_ticks(
            m,
            M;
            k_min = nmin,
            k_max = nmax,
            k_ideal = nideal,
        ),
    )
end

function _generate_line(at, from, to, n, flip)
    return [flip ? (s, at) : (at, s) for s in LinRange(from, to, n)]
end

function _graticule_box_poly(box, projection; n = 50)
    prj = SpeciesDistributionToolkit._projector(
        "EPSG:4326",
        SimpleSDMLayers.AG.toPROJ4(projection),
    )
    bottom = prj.([(p, box.bottom) for p in LinRange(box.left, box.right, n)])
    right = prj.([(box.right, p) for p in LinRange(box.bottom, box.top, n)])
    top = prj.([(p, box.top) for p in LinRange(box.right, box.left, n)])
    left = prj.([(box.left, p) for p in LinRange(box.top, box.bottom, n)])
    cycle = Polygon(vcat(bottom, right, top, left))
    SimpleSDMPolygons._add_crs(cycle.geometry, projection)
    return cycle
end

@recipe GraticuleGrid (box, projection) begin
    xgridcolor = @inherit xgridcolor :grey80
    ygridcolor = @inherit ygridcolor :grey80
    xgridstyle = @inherit xgridstyle :solid
    ygridstyle = @inherit ygridstyle :solid
    xgridwidth = @inherit xgridwidth 0.9
    ygridwidth = @inherit ygridwidth 0.9
    xgridvisible = @inherit xgridvisible true
    ygridvisible = @inherit ygridvisible true
    backgroundcolor = @inherit backgroundcolor :transparent

    yminticks = 3
    yticks = 6
    ymaxticks = 8

    xminticks = 3
    xticks = 6
    xmaxticks = 8

    alpha = 1.0

    npoints = 20

    labels = :lbrt

    dms = false
end

@recipe GraticuleBox (box, projection) begin
    leftspinevisible = @inherit leftspinevisible true
    bottomspinevisible = @inherit bottomspinevisible true
    topspinevisible = @inherit topspinevisible true
    rightspinevisible = @inherit rightspinevisible true

    spinewidth = @inherit spinewidth 1.0

    leftspinecolor = @inherit leftspinecolor :black
    bottomspinecolor = @inherit bottomspinecolor :black
    topspinecolor = @inherit topspinecolor :black
    rightspinecolor = @inherit rightspinecolor :black
end

Makie.convert_arguments(::Type{GraticuleBox}, layer::SDMLayer) =
    (SpeciesDistributionToolkit.boundingbox(layer), projection(layer))
Makie.convert_arguments(::Type{GraticuleGrid}, layer::SDMLayer) =
    (SpeciesDistributionToolkit.boundingbox(layer), projection(layer))

function Makie.plot!(gg::GraticuleGrid)

    # We get the ideal ticks
    ew_ticks = _return_isolines(
        gg.box[].left,
        gg.box[].right,
        gg.xminticks[],
        gg.xticks[],
        gg.xmaxticks[],
    )
    ns_ticks = _return_isolines(
        gg.box[].bottom,
        gg.box[].top,
        gg.yminticks[],
        gg.yticks[],
        gg.ymaxticks[],
    )

    # Projection function
    prj = SpeciesDistributionToolkit._projector(
        "EPSG:4326",
        SimpleSDMLayers.AG.toPROJ4(gg.projection[]),
    )

    # Background
    if gg.backgroundcolor[] != :transparent
        p1 = prj.(
            _generate_line(gg.box[].left, gg.box[].bottom, gg.box[].top, 20, false)
        )
        p2 = prj.(
            _generate_line(gg.box[].right, gg.box[].bottom, gg.box[].top, 20, false)
        )
        p3 = prj.(
            _generate_line(gg.box[].top, gg.box[].left, gg.box[].right, 20, true)
        )
        p4 = prj.(
            _generate_line(gg.box[].bottom, gg.box[].left, gg.box[].right, 20, true)
        )
        poly!(
            gg,
            vcat(p1, p2, reverse(p3), reverse(p4));
            color = gg.backgroundcolor[],
            alpha = gg.alpha[],
        )
    end

    # Lines in the northing direction

    for i in eachindex(ew_ticks)
        if !isnothing(gg.labels[])
            if occursin('b', String(gg.labels[]))
                point = prj((ew_ticks[i], gg.box[].bottom))
                text!(
                    gg,
                    [point];
                    text = [gg.dms[] ? _to_dms(ew_ticks[i], false) : string(ew_ticks[i])],
                    align = (:center, :top),
                    offset = (0, -8),
                )
            end
            if occursin('t', String(gg.labels[]))
                point = prj((ew_ticks[i], gg.box[].top))
                text!(
                    gg,
                    [point];
                    text = [gg.dms[] ? _to_dms(ew_ticks[i], false) : string(ew_ticks[i])],
                    align = (:center, :bottom),
                    offset = (0, 8),
                )
            end
        end
        if gg.xgridvisible[]
            points =
                prj.(
                    _generate_line(
                        ew_ticks[i],
                        gg.box[].bottom,
                        gg.box[].top,
                        gg.npoints[],
                        false,
                    )
                )
            lines!(
                gg,
                points;
                color = gg.xgridcolor[],
                linestyle = gg.xgridstyle[],
                linewidth = gg.xgridwidth[],
            )
        end
    end

    # Lines in the easting direction

    for i in eachindex(ns_ticks)
        if !isnothing(gg.labels[])
            if occursin('l', String(gg.labels[]))
                point = prj((gg.box[].left, ns_ticks[i]))
                text!(
                    gg,
                    [point];
                    text = [gg.dms[] ? _to_dms(ns_ticks[i], true) : string(ns_ticks[i])],
                    align = (:right, :center),
                    offset = (-8, 0),
                )
            end
            if occursin('r', String(gg.labels[]))
                point = prj((gg.box[].right, ns_ticks[i]))
                text!(
                    gg,
                    [point];
                    text = [gg.dms[] ? _to_dms(ns_ticks[i], true) : string(ns_ticks[i])],
                    align = (:left, :center),
                    offset = (8, 0),
                )
            end
        end
        if gg.ygridvisible[]
            points =
                prj.(
                    _generate_line(
                        ns_ticks[i],
                        gg.box[].left,
                        gg.box[].right,
                        gg.npoints[],
                        true,
                    )
                )
            lines!(
                gg,
                points;
                color = gg.ygridcolor[],
                linestyle = gg.ygridstyle[],
                linewidth = gg.ygridwidth[],
            )
        end
    end

    # We return
    return gg
end

function Makie.plot!(gb::GraticuleBox)
    prj = SpeciesDistributionToolkit._projector(
        "EPSG:4326",
        SimpleSDMLayers.AG.toPROJ4(gb.projection[]),
    )
    if gb.leftspinevisible[]
        p = prj.(
            _generate_line(gb.box[].left, gb.box[].bottom, gb.box[].top, 20, false)
        )
        lines!(gb, p; color = gb.leftspinecolor[], linewidth = gb.spinewidth[])
    end
    if gb.rightspinevisible[]
        p = prj.(
            _generate_line(gb.box[].right, gb.box[].bottom, gb.box[].top, 20, false)
        )
        lines!(gb, p; color = gb.rightspinecolor[], linewidth = gb.spinewidth[])
    end
    if gb.topspinevisible[]
        p = prj.(
            _generate_line(gb.box[].top, gb.box[].left, gb.box[].right, 20, true)
        )
        lines!(gb, p; color = gb.topspinecolor[], linewidth = gb.spinewidth[])
    end
    if gb.bottomspinevisible[]
        p = prj.(
            _generate_line(gb.box[].bottom, gb.box[].left, gb.box[].right, 20, true)
        )
        lines!(gb, p; color = gb.bottomspinecolor[], linewidth = gb.spinewidth[])
    end
    return gb
end

function enlargelimits!(ax::Axis; x::Float64 = 0.07, y::Float64 = 0.07)
    xl = ax.xaxis.attributes.limits[]
    Δ = (xl[2] - xl[1]) .* x
    xlims!(ax, ax.xaxis.attributes.limits[] .+ (-Δ, Δ))
    yl = ax.yaxis.attributes.limits[]
    Δ = (yl[2] - yl[1]) .* y
    ylims!(ax, ax.yaxis.attributes.limits[] .+ (-Δ, Δ))
    return ax
end

end