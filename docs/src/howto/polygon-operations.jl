# # Operations on Polygons

# Polygons can be manipulated with various different operations: _(1) adding_,
# which returns the union of polygons, _(2) subtracting_, which returns the
# difference of two polygons, _(3) intersecting_, which returns the regions both
# polygons contain, and _(4) inverting_, which takes a single polygon and
# returns a new polygon that encloses all the area within the original polygons
# bounding box that is not contained in the original. 

using SpeciesDistributionToolkit
using CairoMakie
CairoMakie.activate!(; type = "png", px_per_unit = 2) #hide

# ## Adding Polygons

# Let's start with the simplest version: adding polygons. Let's load the
# polygons for two US states, Texas and Oklahoma

texas = getpolygon(PolygonData(OpenStreetMap, Places); place = "Texas")
oklahoma = getpolygon(PolygonData(OpenStreetMap, Places); place = "Oklahoma")

# We can plot them to show that they are two adjacent states (that don't overlap):

# fig-tex-ok-separate
lines(texas)
lines!(oklahoma)
current_figure() #hide

# By default, these are both downloaded as `FeatureCollection`s with a single
# feature. We can add them as `FeatureCollection`s to yield a single polygon
# that consists of all regions enclosed by both of them. 

tex_and_ok = add(texas, oklahoma)

# which we can then visualize:

# fig-tex-ok-together
lines(tex_and_ok)
current_figure() #hide

# We can also do this with the single features directly

add(texas[1], oklahoma[1])

# or the polygons those features contain

add(texas[1].geometry, oklahoma[1].geometry)

# which yields the same result.

# Alternatively, we can also just use the `+` operator, which does that same
# thing as `add`:

texas + oklahoma

# Sometimes we may have `FeatureCollection`s with more than one feature. For
# example, lets combine Texas and Oklahoma `FeatureCollection`s with `vcat`

vcat(texas, oklahoma)

# We'll also load another state to combine 

louisiana = getpolygon(PolygonData(OpenStreetMap, Places); place = "Louisiana")

# By default, `add` unions all features _within_ collections too, e.g. the
# following creates a single polygon with the entire area of all three states

tx_ok_la = texas + oklahoma + louisiana

# which we can visualize:

# fig-added-tx-ok-la
lines(tx_ok_la)
current_figure() #hide

# If we want to keep their separate boundaries, we should use vcat

tx_ok_la_separate = vcat(texas, oklahoma, louisiana)

# and plot to show they keep their individual boundaries

# fig-tx-ok-la-separate
lines(tx_ok_la_separate)
current_figure() #hide

# ## Subtracting polygons

# We subtract polygons in a similar way. The method `subtract(x, y)` removes the
# area contained in `y` from `x`.

# For example, let's remove the two largest metropolitan regions from Texas,
# first by loading them 

dallas = getpolygon(PolygonData(OpenStreetMap, Places); place = "Dallas")
houston = getpolygon(PolygonData(OpenStreetMap, Places); place = "Houston")

# We can use subtract them iteratively

rural_texas = texas
rural_texas = subtract(rural_texas, dallas)
rural_texas = subtract(rural_texas, houston)

# and visualize:

# fig-rural-texas
lines(rural_texas)
current_figure() #hide

# Or in a single line using the `-` operator

rural_texas = texas - dallas - houston

# which results in the same thing:

# fig-rural-texas-sub-symbol
lines(rural_texas)
current_figure() #hide

# ## Intersecting a Polygon

# We can also use the `intersect` method to extract the region where two
# polygons intersect. 

# As an example, let's consider trying to make a map of Texas, which different
# polygons corresponding to different ecoregions. We'll start by downloading the
# EPA North America 2nd level ecoregions

ecoregions = getpolygon(PolygonData(EPA, Ecoregions); level = 3)

# and then intersect them

tx_ecoregions = intersect(texas, ecoregions)

# and visualize the different ecoregions in texas

# fig-tx-ecoregions
poly(tx_ecoregions)
current_figure() #hide
