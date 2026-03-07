# # Plotting polygons

# The polygons are integrated with the [Makie](https://docs.makie.org/stable/)
# plotting package.

using SpeciesDistributionToolkit
using CairoMakie
CairoMakie.activate!(; type = "png", px_per_unit = 2) #hide

# We start by getting a number of polygons to show how they can be plotted:

regions = getpolygon(PolygonData(OneEarth, Bioregions))["Region" => "Central America"]
landmass = getpolygon(PolygonData(NaturalEarth, Land))
regions = intersect(regions, landmass)

# ## Lines

lines(regions)

# The `color` argument will set the same color to all polygons:

lines(regions; color = :grey50)

# ## Polygons

poly(regions)

# The `color` argument will set the background:

poly(regions; color = :grey90)

# ## Combination

poly(regions; color = :grey90, label = "Central America region")
lines!(regions; color = :grey10, label = "Central America region")
poly!(regions["Subregion" => "Caribbean"]; color = :lime, label = "Caribbean sub-region")
lines!(
    regions["Subregion" => "Caribbean"];
    color = :darkgreen,
    label = "Caribbean sub-region",
)
axislegend(; unique = true, merge = true, position = :lb)
hidedecorations!(current_axis())
hidespines!(current_axis())
current_figure()

# ## Cross-hatching

# The `crosshatch` function returns a polygon that has cross-hatches, the
# spacing and angle of which can be modified.

poly(regions; color = :grey90, label = "Central America region")
poly!(
    regions["Name" => "Central American Mixed Forests"];
    color = :forestgreen,
    alpha = 0.2,
    label = "Central American Mixed Forests",
)
lines!(
    crosshatch(
        regions["Name" => "Central American Mixed Forests"];
        spacing = 0.8,
        angle = 45.0,
    );
    label = "Central American Mixed Forests",
    color = :forestgreen,
)
lines!(
    regions;
    color = :grey10,
    label = "Central America region",
)
axislegend(; unique = true, merge = true, position = :lb)
hidedecorations!(current_axis())
hidespines!(current_axis())
current_figure()

# In cases where we want to deal with multiple sub-regions within the same
# polygon, it is a good idea to start by cross-hatching the entire region, and
# the intersecting this with an area of interest.

hatch = crosshatch(regions; angle=35)

# For example, we will illsutrate this by having the regions of mixed and other
# forests hatched. Because the hatching is defined for the entire region, the
# lines flow across the region boundaries, which would not be the case if we had
# used the `crosshatch` function on all regions.

poly(regions; color = :grey90, label = "Central America region")
for region in regions
    region_name = region.properties["Name"]
    if contains(region_name, "Forests")
        if contains(region_name, "Mixed")
            lines!(intersect(region, hatch), color=:forestgreen, label="Mixed forests")
        else
            lines!(intersect(region, hatch), color=:orange, label="Other forests")
        end
    end
end
lines!(regions,color=:grey10)
axislegend(; unique = true, merge = true, position = :lb, framevisible=false)
hidedecorations!(current_axis())
hidespines!(current_axis())
current_figure()

# ## Generating polygons from layers

# There is a function to generate a polygon (or a multi-polygon) from a boolean
# layer. We will use it to highlight which area are in the top and bottom 15% of
# total annual precipitation:

camf = regions["Name" => "Central American Mixed Forests"]
precipitation = SDMLayer(RasterData(CHELSA2, Precipitation); SpeciesDistributionToolkit.boundingbox(camf)...)
mask!(precipitation, camf)

# This new layer is a Boolean layer with `true` corresponding to the area of interest.

import Statistics
dry = precipitation .<= Statistics.quantile(precipitation, 0.15)
wet = precipitation .>= Statistics.quantile(precipitation, 0.85)

# We generate the polygon through a call to `polygonize`:

dry_poly = polygonize(dry)
wet_poly = polygonize(wet)

# And we can finally plot. Note that the crosshatching is returned as a
# _striped_ polygon, so if you want to get bolder hatches, using `poly` is a
# decent solution.

f = Figure()
ax = Axis(f[1, 1]; aspect = DataAspect())
poly!(ax, camf, color=:grey94, label="Central American Mixed Forests")
poly!(ax, dry_poly, color=:orange, label="Low precipitation", alpha=0.2)
poly!(ax, wet_poly, color=:skyblue, label="High precipitation", alpha=0.2)
poly!(ax, crosshatch(dry_poly, spacing=0.3, angle=40); color = :orange, alpha=0.7)
poly!(ax, crosshatch(wet_poly, spacing=0.3, angle=40); color = :skyblue, alpha=0.7)
lines!(ax, dry_poly; color = :orange, label="Low precipitation")
lines!(ax, wet_poly; color = :skyblue, label="High precipitation")
lines!(ax, camf; color = :black, linewidth=2)
axislegend(; unique = true, merge = true, position = :lb, framevisible=false)
hidedecorations!(ax)
hidespines!(ax)
current_figure()
