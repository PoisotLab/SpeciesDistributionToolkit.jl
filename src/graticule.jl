using Revise
using SpeciesDistributionToolkit
const SDT = SpeciesDistributionToolkit
using CairoMakie

pol = getpolygon(PolygonData(NaturalEarth, Countries))["Brazil"]
proj = "ESRI:54009"

temp =
    SDMLayer(RasterData(WorldClim2, Elevation); SDT.boundingbox(pol)..., resolution = 5.0)
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
end

Makie.convert_arguments(::Type{Graticule}, layer::SDMLayer) = (layer,)

function Makie.plot!(graticule::Graticule)
    # We start by getting the bounding box in latitude/longitude
    box = SpeciesDistributionToolkit.boundingbox(
        graticule.layer[];
        padding = graticule.padding[],
    )
    ew_ticks, _, _ = Makie.PlotUtils.optimize_ticks(box.left, box.right; k_min=3, k_max=10, k_ideal=6)
    ns_ticks, _, _ = Makie.PlotUtils.optimize_ticks(box.bottom, box.top; k_min=3, k_max=10, k_ideal=6)
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

    return graticule # return type doesn't actually matter
end

graticule(itemp; padding = 0.2, gridlinestyle = :dash, boxlinewidth=2)
poly!(reproject(pol, proj), color=:grey80)
heatmap!(itemp, colormap=:terrain)
lines!(reproject(pol, proj), color=:grey10)
graticule!(itemp; padding = 0.4, gridcolor=:transparent, boxcolor=:transparent)
hidespines!(current_axis())
hidedecorations!(current_axis())
current_figure()