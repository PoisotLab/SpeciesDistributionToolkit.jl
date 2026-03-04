# # Working with projections

# This page shows how to work with projected data.

using SpeciesDistributionToolkit
const SDT = SpeciesDistributionToolkit
using CairoMakie
CairoMakie.activate!(; type = "png", px_per_unit = 3) #hide

# We get the polygon for Alaska:

AL = getpolygon(PolygonData(OpenStreetMap, Places); place="Alaska")
LD = getpolygon(PolygonData(NaturalEarth, Land), resolution=10)
AL = intersect(AL, LD)

# Intersecting with the land polygon is not necessary, but OpenStreetMap adds
# some buffer around the landmass, which changes the shape of the polygon.

# We can check that this goes over the 180° line:

albox = SDT.boundingbox(AL)

# As a result, this looks awful when plotted.

f = Figure()
ax = Axis(f[1,1]; aspect=DataAspect())
poly!(ax, AL)
current_figure()

# To avoid downloading a large amount of data, we will fill a layer with the
# latitude of the cell. This will be useful to demonstrate that we get the
# correct projection.

layersize = (800, 800)
lats = LinRange(albox.bottom, albox.top, layersize[1])
grid = reshape(repeat(lats, outer=layersize[2]), layersize)
L = SDMLayer(grid, x=(albox.left, albox.right), y=(albox.bottom, albox.top))
mask!(L, AL)

# From the how-to on interpolation, we know that we can reproject the layer to
# an appropriate representation:

R = interpolate(L, dest="+proj=aea +lat_0=50 +lon_0=-154 +lat_1=55 +lat_2=65 +x_0=0 +y_0=0 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs +type=crs", newsize=(2000, 2000))
R = trim(R)

# We can check that the plot is correct -- note that the bands represent
# latitudes:

f = Figure()
ax = Axis(f[1,1]; aspect=DataAspect())
heatmap!(ax, R, colormap=cgrad(:Greens, 10, categorical=true))
current_figure()

# We can use the `reproject` function to plot the polygon in the correct
# projection:

lines!(reproject(AL, R.crs), color=:black, linewidth=2)
current_figure()

# We can similarly reproject a series of occurrences. For example, we can
# correctly place the observations of bigfoot on the map:

occ = Occurrences(mask(OccurrencesInterface.__demodata(), AL))
scatter!(reproject(occ, R.crs), color=:orange, markersize=12)
hidespines!(current_axis())
hidedecorations!(current_axis())
current_figure()