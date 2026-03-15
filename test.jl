using Revise
using CairoMakie
using SpeciesDistributionToolkit
const SDT = SpeciesDistributionToolkit

# Get data
pol = getpolygon(PolygonData(ESRI, Places))["Place name" => "Corse"]
bb = SDT.boundingbox(pol; padding=0.1)

model = SDM(RawData, NaiveBayes, SDeMo.__demodata()...)

L = SDMLayer(RasterData(CHELSA2, BioClim); bb...)
mask!(L, pol)

h = hexagons(bb, 12.; offset=(0, 0))

pointy = hexagons(pol, 12.; padding=0.2, pointy=true)
flat = hexagons(pol, 12.; padding=0.2, pointy=false)

f = Figure()
ax1 = Axis(f[1,1], aspect=DataAspect(), title="Flat side up")
ax2 = Axis(f[1,2], aspect=DataAspect(), title="Pointy side up")
poly!(ax1, pol, color=:grey90)
poly!(ax2, pol, color=:grey90)
lines!(ax1, flat, color=(:black, 0.6))
lines!(ax2, pointy, color=(:black, 0.6))
current_figure()

f = Figure()
ax = Axis(f[1,1]; aspect=DataAspect())
lines!(ax, hexagons(model, 12.))
scatter!(ax, model, color=labels(model), colormap=:Purples, strokecolor=:black, strokewidth=0.4, markersize=4)
current_figure()

f = Figure()
ax = Axis(f[1,1]; aspect=DataAspect())
heatmap!(ax, L, colormap=:navia)
lines!(ax, hexagons(L, 12.; pointy=false), color=:grey60)
current_figure()
