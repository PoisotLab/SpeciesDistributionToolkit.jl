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
base_model = SDM(PCATransform, DecisionTree, SDeMo.__demodata()...)
model = Bagging(base_model, 50)
bagfeatures!(model)
train!(model)

# Get the prediction and uncertainty
val = predict(model, L; threshold = false)
unc = predict(model, L; threshold = false, consensus = iqr)


# ## Bivariate

bivariate(val, unc)

# change number of bins

bivariate(val, unc; xbins=25, ybins=25)

# 

bivariate(val, unc; StevensRedBlue()...)

#

bivariate(val, unc; StevensYellowPurple()...)

#

bivariate(val, unc; StevensBluePurple()...)

#

bivariate(val, unc; StevensBlueGreen()...)

#

bivariate(val, unc; ArcMapOrangeBlue()...)

# ## VSUP

vsup(val, unc)

#

vsup(val, unc; bins=4, colormap=:cividis)