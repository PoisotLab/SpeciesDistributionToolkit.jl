# # Tessellation

using SpeciesDistributionToolkit
using CairoMakie
CairoMakie.activate!(; type = "png", px_per_unit = 2) #hide

# tessellate

pol = getpolygon(PolygonData(NaturalEarth, Countries))["Austria"]

# up

tiles = tessellate(pol, 10.)

# proj

proj = "EPSG:3416"

#figure fig-tess
f = Figure()
ax = Axis(f[1,1]; aspect=DataAspect())
poly!(ax, pol, color=:grey80)
lines!(ax, tiles, color=:grey20)
current_figure() #hide

#figure fig-projection
f = Figure()
ax = Axis(f[1,1]; aspect=DataAspect())
poly!(ax, reproject(pol, proj), color=:grey80)
lines!(ax, reproject(tiles, proj), color=:grey20)
current_figure() #hide

# check

# ```@meta
# CollapsedDocStrings = true
# ```

# ## Related documentation
# 
# ```@docs; canonical=false
# tessellate
# SpeciesDistributionToolkit.keeprelevant!
# ```
