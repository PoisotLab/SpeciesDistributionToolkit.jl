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

f = Figure()
ax = Axis(f[1,1]; aspect=DataAspect())
lines!(ax, hexagons(pol, 12.; pointy=false), color=:grey60)
scatter!(ax, model, color=labels(model), colormap=:Purples, strokecolor=:black, strokewidth=0.4, markersize=4)
current_figure()


h = hexagons(pol, 5.; pointy=true)
ab = SDT.keeprelevant(h, absences(model))
pr = SDT.keeprelevant(h, presences(model))

f = Figure()
ax = Axis(f[1,1], aspect=DataAspect())
poly!(ax, pr, color=(:red, 0.5))
poly!(ax, ab, color=(:skyblue, 0.4))
lines!(h, color=:grey10, linewidth=0.5)
current_figure()

h = hexagons(model, 8.; pointy=true)
SDT.cvlabel!(h; n=7, order=:NE)

colpal = cgrad(:Spectral, maximum(uniqueproperties(h)["__fold"]), categorical=true)

f = Figure()
ax = Axis(f[1,1], aspect=DataAspect())
for k in uniqueproperties(h)["__fold"]
    poly!(ax, h["__fold" => k], color = colpal[k], alpha=0.2)
end
for ft in h.features
    text!(ax, ft.properties["__centroid"], text = string(ft.properties["__fold"]), align = (:center, :center), color=:black)
end
lines!(ax, h, color=:grey20)
current_figure()

for k in uniqueproperties(h)["__fold"]
    o = Occurrences(mask(model, h["__fold" => k]))
    @info length(presences(o))/length(o) 
end