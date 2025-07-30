# # Shift and rotate

# In this tutorial, we will apply the [Shift and
# Rotate](https://onlinelibrary.wiley.com/doi/abs/10.1111/2041-210X.14443)
# technique to generate realistic maps of predictors to provide a null sample
# for the performance of an SDM. We will also look at the quantile mapping
# function, which ensures that the null sample has the exact same distribution
# of values compared to the original data.

using SpeciesDistributionToolkit
const SDT = SpeciesDistributionToolkit
using CairoMakie
CairoMakie.activate!(; type = "png", px_per_unit = 2) #hide
import Random #hide
Random.seed!(123451234123121); #hide

# We will get some occurrences from the butterfly *Aglais caschmirensis* in Pakistan:

pol = getpolygon(PolygonData(NaturalEarth, Countries))["Pakistan"]
presences = GBIF.download("10.15468/dl.emv5tj");
extent = SDT.boundingbox(pol)

# And then get some bioclimatic variables:

provider = RasterData(CHELSA2, BioClim)
L = SDMLayer{Float32}[
    SDMLayer(
        provider;
        layer = x,
        extent...,
    ) for x in 1:19
];
mask!(L, pol)

# As for the previous tutorials, we will generate some background points:

presencelayer = mask(first(L), Occurrences(mask(presences, pol)))
background = pseudoabsencemask(DistanceToEvent, presencelayer)
bgpoints = backgroundpoints(nodata(background, d -> d < 20), 2sum(presencelayer))

# And finally train an ensemble model:

sdm = Bagging(SDM(RawData, DecisionTree, L, presencelayer, bgpoints), 50)
bagfeatures!(sdm)

# Let's look at the first prediction of this model:

train!(sdm)

heatmap(predict(sdm, L))
lines!(pol)
current_figure()