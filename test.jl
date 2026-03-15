using Revise
using CairoMakie
using SpeciesDistributionToolkit
const SDT = SpeciesDistributionToolkit

# Get data
pol = getpolygon(PolygonData(ESRI, Places))["Place name" => "Corse"]
bb = SDT.boundingbox(pol; padding=0.1)

model = SDM(RawData, NaiveBayes, SDeMo.__demodata()...)

h = hexagons(bb, 12.; offset=(0, 0))

pointy = hexagons(bb, 12.; pointy=true)
flat = hexagons(bb, 8.; pointy=false)

f = Figure()
ax1 = Axis(f[1,1], aspect=DataAspect(), title="Flat side up")
ax2 = Axis(f[1,2], aspect=DataAspect(), title="Pointy side up")
poly!(ax1, pol, color=:grey95)
poly!(ax2, pol, color=:grey95)
lines!(ax1, intersect(pol, flat), color=:black)
lines!(ax2, intersect(pol, pointy), color=:black)
current_figure()