# # SDM with maximum entropy

using SpeciesDistributionToolkit
const SDT = SpeciesDistributionToolkit
using CairoMakie

# In this vignette, we will use the Maxent model [phillips2006maximum](@cite).
# Specifically, we rely on the maxnet version from
# [phillips2017opening](@citet).

# We will collect observations of the Northern Cardinal (_Cardinalis
# cardinalis_) for the country of Belize. They are available on GBIF as a
# DarwinCore archive, which we can [download and use
# directly](/manual/retrieval/gbif-download/).

records = GBIF.download("10.15468/dl.y8d8yb");

# We will first grab a series of polygons to highlight our study area.

borders = getpolygon(PolygonData(NaturalEarth, Countries))
aoi = borders["Belize"]
bb = SDT.boundingbox(records; padding=0.5)
landmass = clip(borders, bb)

# We finally get the BioClim variables from CHELSA2, and mask them using the
# area of interest:

L = SDMLayer{Float32}[SDMLayer(RasterData(CHELSA2, BioClim); bb..., layer=i) for i in 1:19]
mask!(L, aoi)

# PseudoAbsences

presencelayer = mask(L[1], records)
background = pseudoabsencemask(BetweenRadius, presencelayer; closer = 10.0, further = 40.0)
absencelayer = backgroundpoints(background, 2sum(presencelayer))

# model

m = SDM(RawData, Maxent, L, presencelayer, absencelayer)
variables!(m, ForwardSelection)


# 

cv = crossvalidate(m, kfold(m))

# is it good?

mcc(cv.validation)

#

#-

mcc(cv.training)

# compare with logistic

n = SDM(RawData, Logistic, L, presencelayer, absencelayer)
variables!(n, ForwardSelection)

#figure Maxent map
f = Figure()
ax = Axis(f[1,1]; aspect=DataAspect(), title="Maxent")
ax2 = Axis(f[1,2]; aspect=DataAspect(), title="Logistic")
for a in [ax, ax2]
    poly!(a, landmass, color=:grey95)
end
hm = heatmap!(ax, predict(m, L; threshold=false), colormap=Reverse(:navia), colorrange=(0, 1))
heatmap!(ax2, predict(n, L; threshold=false), colormap=Reverse(:navia), colorrange=(0, 1))
for a in [ax, ax2]
    lines!(a, landmass, color=:black)
    scatter!(a, records, color=:orange, markersize=2)
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
bivariate!(ax, predict(m, L; threshold=false), predict(n, L; threshold=false); ArcMapOrangeBlue()..., xbins=5, ybins=5)
lines!(ax, landmass, color=:black)
tightlimits!(ax)
hidedecorations!(ax)
current_figure() #hide

# gainloss?
