using SpeciesDistributionToolkit
const SDT = SpeciesDistributionToolkit
using CairoMakie

pol = getpolygon(PolygonData(NaturalEarth, Countries))["Region" => "Europe"]["Subregion" => "Eastern Europe"]
proj = "+proj=ortho"

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
end

function _bbox_to_grid(obj; kwargs...)
    box = SDT.boundingbox(obj; kwargs...)
    lonticks = Makie.PlotUtils.optimize_ticks(box.left, box.right)
    latticks = Makie.PlotUtils.optimize_ticks(box.bottom, box.top)
    lons = [lonticks[2], lonticks[1]..., lonticks[3]]
    lats = [latticks[2], latticks[1]..., latticks[3]]
    pols = Feature[]
    # Longitudes
    for i in eachindex(lons)
        if i > 1
            points = (
                (lons[i - 1], box.bottom),
                (lons[i - 1], box.top),
                (lons[i], box.top),
                (lons[i], box.bottom),
                (lons[i - 1], box.bottom),
            )
            p = SimpleSDMPolygons.Polygon(
                points...,
            )
            push!(pols, Feature(p, Dict()))
        end
    end
    # Latitudes
    for i in eachindex(lats)
        if i > 1
            points = (
                (box.left, lats[i - 1]),
                (box.right, lats[i - 1]),
                (box.right, lats[i]),
                (box.left, lats[i]),
                (box.left, lats[i - 1]),
            )
            p = SimpleSDMPolygons.Polygon(
                points...,
            )
            push!(pols, Feature(p, Dict()))
        end
    end
    # Box
    boxpoints = (
        (box.left, box.bottom),
        (box.right, box.bottom),
        (box.right, box.top),
        (box.left, box.top),
        (box.left, box.bottom),
    )
    outer = SimpleSDMPolygons.Polygon(
        boxpoints...,
    )

    # Return
    return FeatureCollection(pols), FeatureCollection(Feature(outer, Dict()))
end

Makie.convert_arguments(::Type{Graticule}, layer::SDMLayer) = (layer,)

function Makie.plot!(graticule::Graticule)
    grid, box = _bbox_to_grid(graticule.layer[]; padding = graticule.padding[])
    grid = reproject(grid, graticule.layer[].crs)
    box = reproject(box, graticule.layer[].crs)
    lines!(graticule, grid; color = graticule.gridcolor[])
    lines!(graticule, box; color = graticule.boxcolor[])
    return graticule # return type doesn't actually matter
end

graticule(itemp; padding = 2.5)
heatmap!(itemp)
hidespines!(temp)
current_figure()