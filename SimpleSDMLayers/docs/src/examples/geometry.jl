# # Working with geometry objects

# The `SimpleSDMLayers` package uses `Point`s to represent coordinates, which
# allows to easily use `GeometryBasics` objects for masking. In this example, we
# will illustrate how we can get the values around a given point, and within a
# polygon. These functions all rely on `mask` to extract the values.

using SimpleSDMLayers
using GeometryBasics
using Plots
using JSON

layer = SimpleSDMPredictor(WorldClim, BioClim; resolution=5.0, left=-89., right=-70., top=27., bottom=15.)

#-

plot(temperature)

# We will now define a center of 5 degree of radius centered on La Habana

la_habana = Point(-82.38304, 23.13302)
area = Circle(la_habana, 5.0)

# We can plot the background of the map, and add the clipped region:

plot(layer, c=:lightgrey, frame=:box)
plot!(mask(area, layer), c=:turku)
scatter!(la_habana, lab="", c=:white, msw=2.0)

# This approach is useful if you want to mask according to a polygon. In this
# case, we will keep the values within a polygon representing Cuba:

borders = download("https://raw.githubusercontent.com/AshKyd/geojson-regions/master/countries/50m/CUB.geojson")
cuba_data = JSON.parsefile(borders)
polys = cuba_data["geometry"]["coordinates"]
CUBA = SimpleSDMLayers._format_polygon.(polys)

# This object is actually a multi-polygon, or an array of polygons. The `mask`
# function can handle this:

plot(layer, c=:lightgrey, frame=:box)
plot!(mask(CUBA, layer), c=:turku)
scatter!(la_habana, lab="", c=:white, msw=2.0)

# The delimitation of the area to crop is only as good as the underlying GeoJSON
# polygons, which in this case is missing some coastal areas. As a sidenote, the
# *center* of the grid cell is checked for being in the polygon (not *any*
# coordinate within the grid cell) - for this reason, coarser rasters (*e.g.* at
# 10 minutes resolution) may not respond perfectly well to masking in this way.