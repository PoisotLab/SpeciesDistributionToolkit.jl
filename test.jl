using Revise
using CairoMakie
using SpeciesDistributionToolkit
const SDT = SpeciesDistributionToolkit

# Polygon data
pol = getpolygon(PolygonData(ESRI, Places))["Place name" => "Corse"]

# Bounding box data
bb = SDT.boundingbox(pol; padding = 0.1)

# Model occ data
model = SDM(RawData, Logistic, SDeMo.__demodata()...)

# Layer data
L = [SDMLayer(RasterData(CHELSA2, BioClim); layer=i, bb...) for i in layers(RasterData(CHELSA2, BioClim))]
mask!(L, pol)

# Get 

equivalent_radius = 6.

pointyhex = tessellate(model, equivalent_radius; tile=:hexagons, pointy=true)
flathex = tessellate(model, equivalent_radius; tile=:hexagons, pointy=false)
square = tessellate(model, equivalent_radius; tile=:squares)
triangle = tessellate(model, equivalent_radius; tile=:triangles)

tess = [pointyhex, flathex, square, triangle]

lay = [1 2; 3 4]

nfolds = 5
for t in tess
    SDT.cvlabel!(t; n = nfolds, order = :NE, group=false)
end

colpal = cgrad(:jet, nfolds; categorical = true)

f = Figure(; size=(900, 600))
axs = [Axis(f[i,j]; aspect=DataAspect()) for i in 1:2, j in 1:2]
for a in axs
    poly!(a, pol, color=:grey90)
end
for i in eachindex(tess)
    for k in uniqueproperties(pointyhex)["__fold"]
        poly!(axs[i], tess[i]["__fold" => k]; color = colpal[k], alpha = 0.3)
    end
    lines!(axs[i], tess[i], color=:grey40)
end
current_figure()

# Check byzone and mosaic
import Statistics

f = Figure()
ax1 = Axis(f[1,1]; aspect=DataAspect())
ax2 = Axis(f[1,2]; aspect=DataAspect())
ax3 = Axis(f[2,1]; aspect=DataAspect())

hm = heatmap!(ax1, mosaic(Statistics.mean, L[1], pointyhex, "__centroid"), colormap=:thermal, colorrange=extrema(L[1]))
heatmap!(ax2, mosaic(Statistics.mean, L[1], pointyhex, "__fold"), colormap=:thermal, colorrange=extrema(L[1]))

mean_by_tile = byzone(Statistics.mean, L[1], pointyhex, "__centroid")
for f in pointyhex.features
    poly!(ax3, f, color=mean_by_tile[f.properties["__centroid"]], colormap=:thermal, colorrange=extrema(L[1]))
end

Colorbar(f[2,2], hm, tellheight=false, tellwidth=false)
current_figure()