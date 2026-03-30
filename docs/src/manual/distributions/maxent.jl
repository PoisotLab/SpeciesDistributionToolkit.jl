# # SDM with maximum entropy

using SpeciesDistributionToolkit
const SDT = SpeciesDistributionToolkit
using CairoMakie

# In addition to [downloading GBIF data](/manual/retrieval/gbif-download/), we
# can work with locally downloaded GBIF files in either Darwin Core or Simple
# formats. 

records = GBIF.download("0069567-260226173443078");

# pol

borders = getpolygon(PolygonData(NaturalEarth, Countries))
aoi = borders["Belize"]
bb = SDT.boundingbox(records; padding=0.5)
landmass = clip(borders, bb)

# layers

L = SDMLayer{Float32}[SDMLayer(RasterData(CHELSA2, BioClim); bb..., layer=i) for i in 1:19]
mask!(L, aoi)

# PseudoAbsences

presencelayer = mask(L[1], records)
background = pseudoabsencemask(WithoutRadius, presencelayer; distance = 15.0)
absencelayer = backgroundpoints(background, 2sum(presencelayer))

# model

m = SDM(RawData, Maxent, L, presencelayer, absencelayer)
train!(m)

# 

cv = crossvalidate(m, kfold(m))

# is it good?

mcc(cv.validation)

#-

mcc(cv.training)

# compare with logistic

n = SDM(RawData, Logistic, L, presencelayer, absencelayer)
train!(n)


#figure Maxent map
f = Figure()
ax = Axis(f[1,1]; aspect=DataAspect(), title="Maxent")
ax2 = Axis(f[1,2]; aspect=DataAspect(), title="Logistic")
for a in [ax, ax2]
    poly!(a, landmass, color=:grey95)
end
hm = heatmap!(ax, predict(m, L; threshold=false), colormap=Reverse(:navia))
heatmap!(ax2, predict(n, L; threshold=false), colormap=Reverse(:navia))
for a in [ax, ax2]
    lines!(a, landmass, color=:black)
    scatter!(a, records, color=:orange, markersize=3)
    tightlimits!(a)
    hidedecorations!(a)
end
Colorbar(f[1,3], hm)
current_figure() #hide

#-

#figure bivariate
f = Figure()
ax = Axis(f[1,1]; aspect=DataAspect(), title="Maxent")
poly!(ax, landmass, color=:grey95)
bivariate!(ax, predict(m, L; threshold=false), predict(n, L; threshold=false); ArcMapOrangeBlue()..., xbins=10, ybins=10)
lines!(ax, landmass, color=:black)
tightlimits!(ax)
hidedecorations!(ax)
current_figure() #hide

# gainloss?

#figure gainloss
f = Figure()
ax = Axis(f[1,1]; aspect=DataAspect())
poly!(ax, landmass, color=:grey95)
heatmap!(gainloss(predict(m, L), predict(n, L)), colormap=[:skyblue, :black, :lime])
lines!(ax, landmass, color=:black)
scatter!(ax, records, color=:orange, markersize=6)
current_figure() #hide
