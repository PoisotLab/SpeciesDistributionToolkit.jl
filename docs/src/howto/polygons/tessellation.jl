# # Tessellation

# It is possible to generate tessellations (homogenous tilings of a surface)
# from several type of objects.

using SpeciesDistributionToolkit
const SDT = SpeciesDistributionToolkit
using CairoMakie
CairoMakie.activate!(; type = "png", px_per_unit = 2) #hide

# We will start by getting the different type of data that can be used to
# generate a tessellation, starting with polygons:

EUR = getpolygon(PolygonData(NaturalEarth, Countries))["Region" => "Europe"]
pol = EUR["Switzerland"]
bb = SDT.boundingbox(pol; padding = 0.5)
EUR = clip(EUR, bb)

# We will also grab some occurrences:

records = GBIF.download("10.15468/dl.wye52h")

# And we will also get a layer:

layer = SDMLayer(RasterData(CHELSA2, AverageTemperature); bb...)
mask!(layer, pol)

# Finally, we will show how the tessellation can be generated in a
# projection-aware way, so we'll also define a correct projection for this area.

proj = "EPSG:2056"

# ## Generating a tessellation

# The `tessellate` function has method for layers, occurrences (including SDMs),
# and polygons. They all share the same options.

T = tessellate(pol, 20.0)

# This will generate a tessellation where each division of the space has a
# radius equivalent to 20km.

#figure tess-basic
f = Figure()
ax = Axis(f[1, 1]; aspect = DataAspect())
lines!(ax, EUR; color = :grey40)
poly!(ax, pol; color = :grey85)
lines!(ax, pol; color = :black)
poly!(ax, T; color = (:green, 0.2))
lines!(ax, T; color = :green)
tightlimits!(ax)
current_figure() #hide

# ## Changing the type of tiling

# The `tile` argument determines which type of tiling is created, and the
# different options are `:hexagons`, `:squares`, and `:triangles`. When using
# `:hexagons`, the `pointy` (boolean) keyword can be used to have the hexagons
# pointy side up.

# The distance given as the second argument to `tessellate` is handled in the
# same way for all type of tiles. fFirst, the function calculates the area that
# would be covered by a circle with this radius. Second, the function generates
# the characteristic length of each tiling shape (side for a square,
# circumradius for an hexagons, altitude for a triangle) that gives it the same
# surface as this circle.

T = tessellate(pol, 25.0; tile = :squares)

#figure tess-squares
f = Figure()
ax = Axis(f[1, 1]; aspect = DataAspect())
lines!(ax, EUR; color = :grey40)
poly!(ax, pol; color = :grey85)
lines!(ax, pol; color = :black)
poly!(ax, T; color = (:green, 0.2))
lines!(ax, T; color = :green)
tightlimits!(ax)
current_figure() #hide

T = tessellate(pol, 25.0; tile = :triangles)

#figure tess-squares
f = Figure()
ax = Axis(f[1, 1]; aspect = DataAspect())
lines!(ax, EUR; color = :grey40)
poly!(ax, pol; color = :grey85)
lines!(ax, pol; color = :black)
poly!(ax, T; color = (:green, 0.2))
lines!(ax, T; color = :green)
tightlimits!(ax)
current_figure() #hide

# ## Changing the projection

# The tiling will by default be generated using long./lat., but it is possible
# to use any different projection. When generating a tiling in long./lat., the
# distance is converted to a number of degrees _at the median latitude_.

T = tessellate(pol, 10.0; tile = :squares, proj = proj)

#figure tess-projected
f = Figure()
ax = Axis(f[1, 1]; aspect = DataAspect())
lines!(ax, EUR; color = :grey40)
poly!(ax, pol; color = :grey85)
lines!(ax, pol; color = :black)
poly!(ax, T; color = (:green, 0.2))
lines!(ax, T; color = :green)
tightlimits!(ax)
current_figure() #hide

# Note that the tessellation is always returned in long./lat., but the
# `reproject` function can be used when plotting.

# ## Properties of tessellations

# All tessellations are returned as a `FeatureCollection` with different
# properties. By default, they will only get a `"__centroid"` property giving
# the center of mass of each polygon in the tiling.

#figure scatter-centroid
centroids = uniqueproperties(T)["__centroid"]
f = Figure()
ax = Axis(f[1, 1]; aspect = DataAspect())
lines!(ax, EUR; color = :grey40)
poly!(ax, pol; color = :grey85)
lines!(ax, pol; color = :black)
scatter!(ax, centroids; color = :green)
tightlimits!(ax)
current_figure() #hide

# When the tiling is generated from a layer, each polygon will get the number of
# cells within it:

T = tessellate(layer, 12.0; tile = :hexagons, pointy = true, proj = proj)

# This value is stored in the `"__cells"` property.

#figure tess-numbercells
f = Figure()
ax = Axis(f[1, 1]; aspect = DataAspect())
lines!(ax, EUR; color = :grey40)
poly!(ax, pol; color = :grey85)
lines!(ax, pol; color = :black)
for f in T.features
    poly!(
        ax,
        f;
        color = f.properties["__cells"],
        colorrange = extrema(uniqueproperties(T)["__cells"]),
        colormap = :Greens
    )
end
lines!(ax, T; color = :green)
tightlimits!(ax)
current_figure() #hide

# When generated from a collection of occurrences, the tiles wil get a
# `"__presences"` and `"__absences"` property, with the number of presences and
# absences. Note that this also works with `AbstractSDM` models, as they can
# supporting the occurrences interface.

T = tessellate(records, 6.; tile=:hexagons, proj=proj)

#figure tess-numberocc
f = Figure()
ax = Axis(f[1, 1]; aspect = DataAspect())
lines!(ax, EUR; color = :grey40)
poly!(ax, pol; color = :grey85)
lines!(ax, pol; color = :black)
for f in T.features
    poly!(
        ax,
        f;
        color = f.properties["__presences"],
        colorrange = extrema(uniqueproperties(T)["__presences"]),
        colormap = :Greens
    )
end
lines!(ax, T; color = :green)
tightlimits!(ax)
current_figure() #hide

# Note a very important feature of tessellations here -- they are _sparse_, and
# will only return polygons that are relevant to the object we are interested
# in.

# ## Selection of tiles

# The (unexported) `keeprelevant` and `keeprelevant!` method can be used to
# filter _any_ tiling. For example, we can generate a tiling from a layer, then
# refine it so it only covers a given occurrence dataset:

T = tessellate(layer, 8.; tile=:squares, proj=proj)
P = SDT.keeprelevant(T, records)

# Note that this will result in a tessellation with the properties gained from
# the layer _and_ the occurrences:

keys(uniqueproperties(P))

# Note also that we used `keeprelevant` in order to return a copy of the initial
# tessellation.

#figure tess-keeprelevant
f = Figure()
ax = Axis(f[1, 1]; aspect = DataAspect())
lines!(ax, EUR; color = :grey40)
poly!(ax, pol; color = :grey85)
lines!(ax, pol; color = :black)
for f in P.features
    poly!(
        ax,
        f;
        color = f.properties["__presences"],
        colorrange = extrema(uniqueproperties(P)["__presences"]),
        colormap = :Greens
    )
end
lines!(ax, T; color = :green)
tightlimits!(ax)
current_figure() #hide

# ## Zonal statistics

# The tessellations can be used for zonal statistics:

using Statistics
T = tessellate(layer, 10.0; tile = :squares, proj = proj)
M = mosaic(mean, layer, T, "__centroid")

#figure tess-zonal
f = Figure()
ax = Axis(f[1, 1]; aspect = DataAspect())
lines!(ax, EUR; color = :grey40)
poly!(ax, pol; color = :grey85)
heatmap!(ax, M, colormap=:Greens)
lines!(ax, pol; color = :black)
tightlimits!(ax)
current_figure() #hide

# ```@meta
# CollapsedDocStrings = true
# ```

# ## Related documentation
# 
# ```@docs; canonical=false
# tessellate
# SpeciesDistributionToolkit.keeprelevant!
# SpeciesDistributionToolkit.keeprelevant
# ```
