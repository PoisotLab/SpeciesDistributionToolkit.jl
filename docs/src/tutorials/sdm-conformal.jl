# # Conformal prediction of species range

# TODO

using SpeciesDistributionToolkit
using CairoMakie
CairoMakie.activate!(; type = "png", px_per_unit = 3) #hide
import Random #hide
Random.seed!(123451234123121); #hide

# todo

records = OccurrencesInterface.__demodata()
landmass = getpolygon(PolygonData(OpenStreetMap, Places); place="Idaho")
records = Occurrences(mask(records, landmass))
spatial_extent = SpeciesDistributionToolkit.boundingbox(landmass)


# todo

provider = RasterData(CHELSA2, BioClim)
L = SDMLayer{Float32}[
    SDMLayer(
        provider;
        layer = x,
        spatial_extent...,
    ) for x in eachindex(layers(provider))
];

# todo

mask!(L, landmass)

# todo

presencelayer = mask(first(L), records)
absencemask = pseudoabsencemask(BetweenRadius, presencelayer; closer = 15.0, further = 90.0)
absencelayer = backgroundpoints(absencemask, 2sum(presencelayer))

# model

model = SDM(PCATransform, Logistic, L, presencelayer, absencelayer)

# georef?

isgeoreferenced(model)

# train

train!(model)

# ::: warning Model performance
# 
# todo
# 
# :::

# make model prediction

Y = predict(model, L; threshold=false)

# train a conformal with alpha 0.05

conformal = train!(Conformal(0.05), model)

# apply conformal

present, absent, unsure, undetermined = predict(conformal, Y)

# these can then be mapped

heatmap(sure, colormap=[:darkgreen])
heatmap!(unsure, colormap=[:grey80])
current_figure()

# and we can see what the risk level does to the estimation of range size

