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

pointyhex = tessellate(model, 15.; tile=:hexagons, pointy=true)
flathex = tessellate(model, 15.; tile=:hexagons, pointy=false)
square = tessellate(model, 15.; tile=:squares)
triangle = tessellate(model, 15.; tile=:triangles)

tess = [pointyhex, flathex, square, triangle]

lay = [1 2; 3 4]

nfolds = 5
for t in tess
    SDT.cvlabel!(t; n = nfolds, order = :N)
end

colpal = cgrad(:managua, nfolds; categorical = true)

f = Figure(; size=(900, 600))
axs = [Axis(f[i,j]; aspect=DataAspect()) for i in 1:2, j in 1:2]
for a in axs
    poly!(a, pol, color=:grey90)
end
for i in eachindex(tess)
    for k in uniqueproperties(pointyhex)["__fold"]
        poly!(axs[i], tess[i]["__fold" => k]; color = colpal[k], alpha = 0.2)
    end
    lines!(axs[i], tess[i], color=:grey40)
end
current_figure()
