# ## Turning a layer into occurrences

using Revise
using SpeciesDistributionToolkit
const SDT = SpeciesDistributionToolkit
using CairoMakie

# The package can generate occurrences from Boolean layers:

model = SDM(RawData, NaiveBayes, SDeMo.__demodata()...)

# layer

pol = getpolygon(PolygonData(OpenStreetMap, Places); place="Corse")
L = SDMLayer(RasterData(CHELSA2, AverageTemperature); SDT.boundingbox(pol)...)
mask!(L, pol)

# layer as series of occ

L₋ = !nodata(mask(L, Occurrences(model), absences), false)
L₊ = nodata(mask(L, Occurrences(model), presences), false)

#  We can get occurrences with

O₊ = Occurrences(L₊; entity="Sitta whiteheadi")
O₋ = Occurrences(L₋; entity="Sitta whiteheadi")

#  alternatively

O = Occurrences(L₊, !L₋; entity="Sitta whiteheadi")

# not that the second layer must have `true` to indicate that there is an absence here

# check

#figure Occurrences extracted from the layer
f = Figure()
ax = Axis(f[1,1]; aspect=DataAspect())
poly!(ax, pol, color=:grey90)
scatter!(ax, presences(O), color=:red, markersize=8, marker=:rect)
scatter!(ax, absences(O), color=:grey30, markersize=6)
hidedecorations!(ax)
hidespines!(ax)
current_figure() #hide