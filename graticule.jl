using Revise
using SpeciesDistributionToolkit
const SDT = SpeciesDistributionToolkit
using CairoMakie

pol =
    getpolygon(PolygonData(ESRI, Places))["Country of affiliation" => "Finland"]["Land type" => "Primary land"]
proj = "EPSG:3387"

temp =
    SDMLayer(
        RasterData(WorldClim2, AverageTemperature);
        SDT.boundingbox(pol)...,
        resolution = 5.0,
    )
mask!(temp, pol)
itemp = interpolate(temp; dest = proj)

@recipe GraticuleGrid (box, projection) begin
    """
    grid color
    """
    color = :grey80

    """
    linewidth
    """
    linewidth = 1

    """
    linestyle
    """
    linestyle = :solid

    """
    npoints
    """
    npoints = 20
end

@recipe GraticuleBox (box, projection) begin
    """
    color
    """
    color = :grey10

    """
    number of points in graticule
    """
    npoints = 20

    """
    style for the grid line
    """
    linestyle = :solid

    """
    grid line width
    """
    linewidth = 1.0

    """
    text label positions
    """
    labels = :lrtb

    """
    text label offset
    """
    offset = 8
end

Makie.convert_arguments(::Type{GraticuleBox}, layer::SDMLayer) = (SpeciesDistributionToolkit.boundingbox(layer), projection(layer), )
Makie.convert_arguments(::Type{GraticuleGrid}, layer::SDMLayer) = (SpeciesDistributionToolkit.boundingbox(layer), projection(layer), )

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
            text!(
                graticule,
                points;
                text = string.(ew_ticks),
                align = (:center, :bottom),
                offset = (0, graticule.offset[]),
            )
        end
        if occursin('b', String(graticule.labels[]))
            points = prj.([(p, box.bottom) for p in ew_ticks])
            text!(
                graticule,
                points;
                text = string.(ew_ticks),
                align = (:center, :top),
                offset = (0, -graticule.offset[]),
            )
        end
        if occursin('l', String(graticule.labels[]))
            points = prj.([(box.left, p) for p in ns_ticks])
            text!(
                graticule,
                points;
                text = string.(ns_ticks),
                align = (:right, :center),
                offset = (-graticule.offset[], 0),
            )
        end
        if occursin('r', String(graticule.labels[]))
            points = prj.([(box.right, p) for p in ns_ticks])
            text!(
                graticule,
                points;
                text = string.(ns_ticks),
                align = (:left, :center),
                offset = (graticule.offset[], 0),
            )
        end
    end
    # We return the plot now
    return graticule # return type doesn't actually matter
end

function Makie.plot!(gbox::GraticuleBox)
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

function _graticule_box_from_object(object; padding = 0.0)
    prj = SpeciesDistributionToolkit._projector(
        "EPSG:4326",
        SimpleSDMLayers.AG.toPROJ4(projection(object)),
    )
    box = SpeciesDistributionToolkit.boundingbox(object; padding = padding)
    bottom = prj.([(p, box.bottom) for p in LinRange(box.left, box.right, 20)])
    right = prj.([(box.right, p) for p in LinRange(box.bottom, box.top, 20)])
    top = prj.([(p, box.top) for p in LinRange(box.right, box.left, 20)])
    left = prj.([(box.left, p) for p in LinRange(box.top, box.bottom, 20)])
    cycle = Polygon(vcat(bottom, right, top, left))
    SimpleSDMPolygons._add_crs(cycle.geometry, projection(object))
    return cycle
end

# Let's figure out the land lines as background

land = getpolygon(PolygonData(NaturalEarth, Land))
# We need to get the graticule box, move it to lon/lat

f = Figure(; size = (500, 600))
ax = Axis(f[1, 1]; aspect = DataAspect())
#graticule!(ax, itemp; gridlinestyle = :dash, boxlinewidth = 2)
gbox = _graticule_box_from_object(temp; padding = 1.5)
poly!(ax, reproject(intersect(gbox, land), proj); color = :grey95)
lines!(ax, reproject(intersect(gbox, land), proj); color = :grey10)
lines!(ax, reproject(gbox, proj); color = :grey10)
hm = heatmap!(itemp; colormap = :rain)
lines!(reproject(pol, proj); color = :grey10)
hidespines!(ax)
hidedecorations!(ax)
enlargelimits!(ax; x = 0.05)
Colorbar(f[1, 2], hm; height = Relative(0.5), label = "Temperature", vertical = true)
current_figure()

# TODO
# - [ ] fix the example above
# - [ ] split the graticule and graticule grid functions
# - [ ] figure out API for clipping polygons
# - [ ] make graticule* dispatch on polygons as well