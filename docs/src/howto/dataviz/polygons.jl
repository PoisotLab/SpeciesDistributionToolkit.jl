# # Plotting polygons

# The layers are integrated with the [Makie](https://docs.makie.org/stable/)
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
    label = "Central America region"
)
axislegend(; unique = true, merge = true, position = :lb)
hidedecorations!(current_axis())
hidespines!(current_axis())
current_figure()
