# # Bivariate and value-suppressing maps

# The package has functions to deal with bivariate maps, as well as
# value-suppressing uncertainty palettes.

using Revise
using SpeciesDistributionToolkit
const SDT = SpeciesDistributionToolkit
using CairoMakie
CairoMakie.activate!(; type = "png", px_per_unit = 2) #hide

# ## Getting data

pol = getpolygon(PolygonData(OpenStreetMap, Places); place = "Corsica");
spatialextent = SDT.boundingbox(pol; padding = 0.1)

# some layers

provider = RasterData(CHELSA2, BioClim)
L = SDMLayer{Float16}[
    SDMLayer(
        provider;
        layer = i,
        spatialextent...,
    ) for i in layers(provider)
]

mask!(L, pol)

# Model
model = SDM(RawData, Logistic, SDeMo.__demodata()...)
variables!(model, ForwardSelection)
predict(model, L; threshold = false) |> heatmap

ens = Bagging(model, 50)
bagfeatures!(ens)
train!(ens)

# Get the prediction and uncertainty
val = predict(model, L; threshold = false)
unc = predict(ens, L; threshold = false, consensus = iqr)


# ## Bivariate

bivariate(val, unc)

# 

bivariate(val, unc; StevensRedBlue()...)

#

bivariate(val, unc; ArcMapOrangeBlue()...)

#

bivariate(val, unc; StevensYellowPurple()...)

#

bivariate(val, unc; StevensBluePurple()...)

#

bivariate(val, unc; StevensBlueGreen()...)

# ## VSUP

vsup(val, unc)
