using Revise
using CairoMakie
using SpeciesDistributionToolkit
const SDT = SpeciesDistributionToolkit

# Get data
pol = getpolygon(PolygonData(ESRI, Places))["Place name" => "Corse"]
bb = SDT.boundingbox(pol)

model = SDM(RawData, NaiveBayes, SDeMo.__demodata()...)

offset = (0, 0)
h = hexagons(bb, 10.; offset=offset)

f = Figure()
ax = Axis(f[1,1]; aspect=DataAspect())
poly!(ax, pol, color=:grey90)
scatter!(ax, model, color=labels(model), colormap=[:black, :orange], markersize=4)
lines!(ax, intersect(h, pol), color=:red)
lines!(ax, pol, color=:grey20)
current_figure()