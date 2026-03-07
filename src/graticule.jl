using Revise
using SpeciesDistributionToolkit
const SDT = SpeciesDistributionToolkit
using CairoMakie

pol = getpolygon(PolygonData(ESRI, Places))["Place name" => "Quebec"]
proj = "EPSG:2138"

temp =
    SDMLayer(RasterData(WorldClim2, Elevation); SDT.boundingbox(pol)..., resolution = 2.5)
mask!(temp, pol)
itemp = interpolate(temp; dest = proj)

heatmap(itemp)
lines!(reproject(pol, proj))
current_figure()

@recipe Graticule (layer,) begin
    """
    grid color
    """
    gridcolor = :grey80

    """
    box color
    """
    boxcolor = :grey10

    """
    padding
    """
    padding = 0.0

    """
    number of points in graticule
    """
    npoints = 20

    """
    style for the grid line
    """
    gridlinestyle = :solid

    """
    grid line width
    """
    gridlinewidth = 1.0

    """
    box line width
    """
    boxlinewidth = 1.2

    """
    text label positions
    """
    labels = :lrtb

    """
    text label offset
    """
    offset = 8
end

Makie.convert_arguments(::Type{Graticule}, layer::SDMLayer) = (layer,)

function Makie.plot!(graticule::Graticule)
    # We start by getting the bounding box in latitude/longitude
    box = SpeciesDistributionToolkit.boundingbox(
        graticule.layer[];
        padding = graticule.padding[],
    )
    ew_ticks, _, _ = Makie.PlotUtils.optimize_ticks(
        box.left,
        box.right;
        k_min = 3,
        k_max = 10,
        k_ideal = 6,
    )
    ns_ticks, _, _ = Makie.PlotUtils.optimize_ticks(
        box.bottom,
        box.top;
        k_min = 3,
        k_max = 10,
        k_ideal = 6,
    )
    # Projection function
    prj = SpeciesDistributionToolkit._projector(
        "EPSG:4326",
        SimpleSDMLayers.AG.toPROJ4(projection(graticule.layer[])),
    )
    # Then we will do a line with a bunch of points for each of the ticks
    for i in eachindex(ew_ticks)
        points =
            prj.([
                (ew_ticks[i], p) for p in LinRange(box.bottom, box.top, graticule.npoints[])
            ])
        lines!(
            graticule,
            points;
            color = graticule.gridcolor[],
            linestyle = graticule.gridlinestyle[],
            linewidth = graticule.gridlinewidth[],
        )
    end
    for i in eachindex(ns_ticks)
        points =
            prj.([
                (p, ns_ticks[i]) for p in LinRange(box.left, box.right, graticule.npoints[])
            ])
        lines!(
            graticule,
            points;
            color = graticule.gridcolor[],
            linestyle = graticule.gridlinestyle[],
            linewidth = graticule.gridlinewidth[],
        )
    end
    # And then we do the box
    points =
        prj.([(p, box.bottom) for p in LinRange(box.left, box.right, graticule.npoints[])])
    lines!(
        graticule,
        points;
        color = graticule.boxcolor[],
        linewidth = graticule.boxlinewidth[],
    )
    points =
        prj.([(p, box.top) for p in LinRange(box.left, box.right, graticule.npoints[])])
    lines!(
        graticule,
        points;
        color = graticule.boxcolor[],
        linewidth = graticule.boxlinewidth[],
    )
    points =
        prj.([(box.left, p) for p in LinRange(box.bottom, box.top, graticule.npoints[])])
    lines!(
        graticule,
        points;
        color = graticule.boxcolor[],
        linewidth = graticule.boxlinewidth[],
    )
    points =
        prj.([(box.right, p) for p in LinRange(box.bottom, box.top, graticule.npoints[])])
    lines!(
        graticule,
        points;
        color = graticule.boxcolor[],
        linewidth = graticule.boxlinewidth[],
    )
    # Next we add the text
    if !isnothing(graticule.labels[])
        if occursin('t', String(graticule.labels[]))
            points = prj.([(p, box.top) for p in ew_ticks])
            text!(graticule, points; text=string.(ew_ticks), align=(:center, :bottom), offset=(0, graticule.offset[]))
        end
        if occursin('b', String(graticule.labels[]))
            points = prj.([(p, box.bottom) for p in ew_ticks])
            text!(graticule, points; text=string.(ew_ticks), align=(:center, :top), offset=(0, -graticule.offset[]))
        end
        if occursin('l', String(graticule.labels[]))
            points = prj.([(box.left, p) for p in ns_ticks])
            text!(graticule, points; text=string.(ns_ticks), align=(:right, :center), offset=(-graticule.offset[], 0))
        end
        if occursin('r', String(graticule.labels[]))
            points = prj.([(box.right, p) for p in ns_ticks])
            text!(graticule, points; text=string.(ns_ticks), align=(:left, :center), offset=(graticule.offset[], 0))
        end
    end
    # We return the plot now
    return graticule # return type doesn't actually matter
end

function enlargelimits!(ax::Axis; x::Float64=0.07, y::Float64=0.07)
    xl = ax.xaxis.attributes.limits[]
    Δ = (xl[2] - xl[1]) .* x
    xlims!(ax, ax.xaxis.attributes.limits[] .+ (-Δ, Δ))
    yl = ax.yaxis.attributes.limits[]
    Δ = (yl[2] - yl[1]) .* y
    ylims!(ax, ax.yaxis.attributes.limits[] .+ (-Δ, Δ))
    return nothing
end

f = Figure()
ax = Axis(f[1,1]; aspect=DataAspect())
graticule!(ax, itemp; gridlinestyle = :dash, boxlinewidth = 2)
poly!(reproject(pol, proj); color = :grey80)
hm = heatmap!(itemp; colormap = Reverse(:navia), colorrange=(0, 1200))
lines!(reproject(pol, proj); color = :grey10)
hidespines!(ax)
hidedecorations!(ax)
enlargelimits!(ax)
Colorbar(f[2,1], hm, width=Relative(0.5), label="Elevation", vertical=false)
current_figure()