# # Open Street Map polygons

using SpeciesDistributionToolkit
const SDT = SpeciesDistributionToolkit
using CairoMakie

# We rely on the [nominatim
# API](https://nominatim.openstreetmap.org/ui/search.html), which exposes a lot
# of information as polygons.

# landmass

lnd = getpolygon(PolygonData(NaturalEarth, Land))

# Because OSM is not a static provider, but instead returns the polygon based on
# a query, the `getpolygon` function must be called with additional arguments.

# ## Countries

# force result to be a country + manmade layer

osmpol = getpolygon(PolygonData(OpenStreetMap, Countries); country="Malaysia")

#figure map-laos
f = Figure()
ax = Axis(f[1,1]; aspect=DataAspect())
poly!(ax, clip(lnd, SDT.boundingbox(osmpol; padding=1.0)), color=:grey90)
lines!(ax, osmpol, color=:red)
tightlimits!(ax)
current_figure()

# Note that the polygons are returned with territorial waters, but [vignette
# op](/manual/polygons/operations/)

uniqueproperties(osmpol)

# ## Places

osmpol = getpolygon(PolygonData(OpenStreetMap, Places); place="Occitanie")

#figure map-alps
f = Figure()
ax = Axis(f[1,1]; aspect=DataAspect())
poly!(ax, clip(lnd, SDT.boundingbox(osmpol; padding=1.0)), color=:grey90)
lines!(ax, osmpol, color=:red)
tightlimits!(ax)
current_figure()


# ## Places

osmpol = getpolygon(PolygonData(OpenStreetMap, Places); place="Quebec")

#figure map-qc
f = Figure()
ax = Axis(f[1,1]; aspect=DataAspect())
poly!(ax, clip(lnd, SDT.boundingbox(osmpol; padding=1.0)), color=:grey90)
lines!(ax, osmpol, color=:red)
tightlimits!(ax)
current_figure()


# ## Related documentation

# ```@meta
# CollapsedDocStrings = true
# ```

# ```@docs; canonical=false
# OpenStreetMap
# ```

