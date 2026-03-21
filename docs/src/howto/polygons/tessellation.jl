# # Tessellation

using SpeciesDistributionToolkit
const SDT = SpeciesDistributionToolkit
using CairoMakie
CairoMakie.activate!(; type = "png", px_per_unit = 2) #hide

# tessellate

EUR = getpolygon(PolygonData(NaturalEarth, Countries))["Region" => "Europe"]
pol = EUR["Austria"]


# bbox

bb = SDT.boundingbox(pol; padding=2.5)
EUR = clip(EUR, bb)

proj = "EPSG:4096"

# from a polygon

f = Figure()
ax = Axis(f[1,1]; aspect=DataAspect())
poly!(ax, EUR, color=:grey80)
poly!(ax, pol, color=:grey60)
lines!(ax, EUR, color=:black)
lines!(ax, tessellate(pol, 25.; proj=proj), color=:orange, linewidth=2)
current_figure()

# 

f = Figure()
ax = Axis(f[1,1]; aspect=DataAspect())
poly!(ax, EUR, color=:grey80)
poly!(ax, pol, color=:grey60)
lines!(ax, EUR, color=:black)
lines!(ax, tessellate(pol, 25.; proj=proj, tile=:squares), color=:orange, linewidth=2)
current_figure()

#

f = Figure()
ax = Axis(f[1,1]; aspect=DataAspect())
poly!(ax, EUR, color=:grey80)
poly!(ax, pol, color=:grey60)
lines!(ax, EUR, color=:black)
lines!(ax, tessellate(pol, 25.; proj=proj, tile=:triangles), color=:orange, linewidth=2)
current_figure()

# next with a layer

# next with occurrences

# ```@meta
# CollapsedDocStrings = true
# ```

# ## Related documentation
# 
# ```@docs; canonical=false
# tessellate
# SpeciesDistributionToolkit.keeprelevant!
# ```
