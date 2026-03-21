# # Tessellation

using SpeciesDistributionToolkit
const SDT = SpeciesDistributionToolkit
using CairoMakie
CairoMakie.activate!(; type = "png", px_per_unit = 2) #hide

# tessellate

pol = getpolygon(PolygonData(NaturalEarth, Countries))["Austria"]

# bbox

bb = SDT.boundingbox(pol)

# layer

#

layer = SDMLayer(RasterData(EarthEnv, LandCover); layer=1, bb...)
mask!(layer, pol)

# proj

proj = "EPSG:3416"

# second layer

L = interpolate(layer; dest=proj)

heatmap(L)
lines!(reproject(pol, proj))
current_figure()

# units

const AG = SDT.SimpleSDMPolygons.AG

tessellate(L, 10.; proj=projection(L))


# ```@meta
# CollapsedDocStrings = true
# ```

# ## Related documentation
# 
# ```@docs; canonical=false
# tessellate
# SpeciesDistributionToolkit.keeprelevant!
# ```
