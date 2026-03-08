using Revise
using SpeciesDistributionToolkit
const SDT = SpeciesDistributionToolkit
using CairoMakie

pol =
    getpolygon(PolygonData(ESRI, Places))["Country of affiliation" => "Finland"]["Land type" => "Primary land"]
proj = "EPSG:3387"

temp =
    SDMLayer(
        RasterData(WorldClim2, Elevation);
        SDT.boundingbox(pol)...,
        resolution = 2.5,
    )
mask!(temp, pol)
itemp = interpolate(temp; dest = proj)

function shared_graticule_attributes()
    Makie.@DocumentedAttributes begin
        """
        color for the line
        """
        color = :black

        """
        linestyle for the line
        """
        linestyle = :solid

        """
        width for the line
        """
        linewidth = 1
    end
end

@recipe GraticuleGrid (box, projection) begin
    shared_graticule_attributes()...

    """
    draw the north/south lines
    """
    north = true

    """
    draw the east/west lines
    """
    east = true

    """
    npoints
    """
    npoints = 20

    """
    display the labels
    """
    labels = :lbrt
end

@recipe GraticuleBox (box, projection) begin
    shared_graticule_attributes()...

    """
    text label positions
    """
    labels = :lrtb

    """
    text label offset
    """
    offset = 8
end

Makie.convert_arguments(::Type{GraticuleBox}, layer::SDMLayer) =
    (SpeciesDistributionToolkit.boundingbox(layer), projection(layer))
Makie.convert_arguments(::Type{GraticuleGrid}, layer::SDMLayer) =
    (SpeciesDistributionToolkit.boundingbox(layer), projection(layer))

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

function Makie.plot!(gg::GraticuleGrid)

    # We get the ideal ticks
    ew_ticks = _return_isolines(gg.box[].left, gg.box[].right, 4, 6, 10)
    ns_ticks = _return_isolines(gg.box[].bottom, gg.box[].top, 4, 6, 10)

    # Projection function
    prj = SpeciesDistributionToolkit._projector(
        "EPSG:4326",
        SimpleSDMLayers.AG.toPROJ4(gg.projection[]),
    )

    # Lines in the northing direction
    if gg.north[]
        for i in eachindex(ew_ticks)
            if !isnothing(gg.labels[])
                if occursin('b', String(gg.labels[]))
                    point = prj((ew_ticks[i], gg.box[].bottom))
                    text!(gg, [point]; text=[string(ew_ticks[i])], align=(:center, :top), offset=(0, -8))
                end
                if occursin('t', String(gg.labels[]))
                    point = prj((ew_ticks[i], gg.box[].top))
                    text!(gg, [point]; text=[string(ew_ticks[i])], align=(:center, :bottom), offset=(0, 8))
                end
            end
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
                gg.attributes,
                points,
            )
        end
    end

    # Lines in the easting direction
    if gg.east[]
        for i in eachindex(ns_ticks)
            if !isnothing(gg.labels[])
                if occursin('l', String(gg.labels[]))
                    point = prj((gg.box[].left, ns_ticks[i]))
                    text!(gg, [point]; text=[string(ns_ticks[i])], align=(:right, :center), offset=(-8, 0))
                end
                if occursin('r', String(gg.labels[]))
                    point = prj((gg.box[].right, ns_ticks[i]))
                    text!(gg, [point]; text=[string(ns_ticks[i])], align=(:left, :center), offset=(8, 0))
                end
            end
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
                gg.attributes,
                points,
            )
        end
    end

    # We return
    return gg
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

function Makie.plot!(gb::GraticuleBox)
    prj = SpeciesDistributionToolkit._projector(
        "EPSG:4326",
        SimpleSDMLayers.AG.toPROJ4(gb.projection[]),
    )
    p = prj.(
        _generate_line(gb.box[].left, gb.box[].bottom, gb.box[].top, 20, false)
    )
    lines!(gb, gb.attributes, p)
    p = prj.(
        _generate_line(gb.box[].right, gb.box[].bottom, gb.box[].top, 20, false)
    )
    lines!(gb, gb.attributes, p)
    p = prj.(
        _generate_line(gb.box[].top, gb.box[].left, gb.box[].right, 20, true)
    )
    lines!(gb, gb.attributes, p)
    p = prj.(
        _generate_line(gb.box[].bottom, gb.box[].left, gb.box[].right, 20, true)
    )
    lines!(gb, gb.attributes, p)
    return gb
end

function enlargelimits!(ax::Axis; x::Float64 = 0.07, y::Float64 = 0.07)
    xl = ax.xaxis.attributes.limits[]
    Δ = (xl[2] - xl[1]) .* x
    xlims!(ax, ax.xaxis.attributes.limits[] .+ (-Δ, Δ))
    yl = ax.yaxis.attributes.limits[]
    Δ = (yl[2] - yl[1]) .* y
    ylims!(ax, ax.yaxis.attributes.limits[] .+ (-Δ, Δ))
    return nothing
end

land = getpolygon(PolygonData(NaturalEarth, Countries))

gr_params = ((left=12., right=35., bottom=57., top=71.), projection(itemp))

f = Figure(; size = (500, 400))
ax = Axis(f[1, 1]; aspect = DataAspect())
graticulegrid!(ax, gr_params...; color = :grey80, linestyle = :dash)
poly!(ax, reproject(clip(land, first(gr_params)), proj); color = :grey90)
hm = heatmap!(ax, itemp; colormap = :terrain)
lines!(ax, reproject(clip(land, first(gr_params)), proj); color = :grey40)
graticulebox!(ax, gr_params...; linewidth = 1.6, color = :black)
hidespines!(ax)
hidedecorations!(ax)
enlargelimits!(ax; x=0.2)
Colorbar(f[1, 2], hm; height = Relative(0.5), label = "Elevation", vertical = true)
current_figure()
