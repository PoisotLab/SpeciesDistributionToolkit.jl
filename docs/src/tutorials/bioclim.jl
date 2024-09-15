# # The BIOCLIM model

# In this tutorial, we will build the BIOCLIM model of species distribution,
# using only basic functions from `SpeciesDistributionToolkit`.

using SpeciesDistributionToolkit
using CairoMakie
CairoMakie.activate!(; type = "png", px_per_unit = 3.0) #hide

# We will get the same occurrence and spatial data as in other examples in this
# documentation (*Sitta whiteheadi* in Corsica):

spatial_extent = (left = 8.412, bottom = 41.325, right = 9.662, top = 43.060)
species = taxon("Sitta whiteheadi"; strict = false)
query = [
    "occurrenceStatus" => "PRESENT",
    "hasCoordinate" => true,
    "decimalLatitude" => (spatial_extent.bottom, spatial_extent.top),
    "decimalLongitude" => (spatial_extent.left, spatial_extent.right),
    "limit" => 300,
]
presences = occurrences(species, query...)
while length(presences) < count(presences)
    occurrences!(presences)
end

# We will get our environmental variables from [CHELSA](/datasets/CHELSA1#BioClim):

dataprovider = RasterData(CHELSA1, BioClim)

# The two layers we use to build this model are annual mean temperature and
# annual total precipitation:

temp = SDMLayer(dataprovider; layer=1, spatial_extent...)
prec = SDMLayer(dataprovider; layer=12, spatial_extent...)

#::: details The BIOCLIM model
# 
# The [BIOCLIM
# model](https://support.bccvl.org.au/support/solutions/articles/6000083201-bioclim)
# is an envelope model in which the percentile of an environmental condition in
# the sites where the species is found is transformed into a score.
# Specifically, a species at the 50th percentile has a score of 0, and a species
# at the 1st and 99th percentile are considered to be equivalent. In other
# words, species should "prefer" their median environment.
# 
# The score is calculated as 
#
# ```math
# 2 \times (\frac{1}{2} - \|Q - \frac{1}{2} \|)
# ```
# 
# where ``Q`` is the quantile for one variable at one pixel; the final score is
# the minimum value for each pixel across all variables.
# 
#:::

# To calculate the scores of the BIOCLIM model, we need to get the quantiles for
# each variable by *only* considering the sites where the species is present:

Qt = quantize(temp, presences)
Qp = quantize(prec, presences)

# We can plot the map of quantiles for precipitation:

fig, ax, hm = heatmap(
    Qp;
    colormap = :navia,
    figure = (; size = (800, 400)),
    axis = (; aspect = DataAspect()),
)
Colorbar(fig[:, end + 1], hm)
current_figure() #hide

# In order to turn the quantiles into a score, we will be chaining together a
# few operations. First, the transformation of layers into layers of quantiles,
# then the transformation of the score, and finally the selection of the minimum
# value across all layers:

function BIOCLIM(layers::Vector{<:SDMLayer}, presences::GBIFRecords)
    score = (Q) -> 2*(0.5-abs(Q-0.5))
    Q = [quantize(layer, presences) for layer in layers]
    S = score.(Q)
    return mosaic(minimum, S)
end

# ::: warning Be careful about the occurrence status!
#
# We have requested only presences from the GBIF API, but if we were to write a
# more general version of this function, it would make sense to filter the
# records with an occurrence status of "absent".
#
# :::

# We can now call this function to get the score at each pixel:

bc = BIOCLIM([temp, prec])

# The interpretation of this score is, essentially, the most restrictive
# environmental condition found at this specific place. We can map this, and
# also superimpose the presence data:

fig, ax, hm = heatmap(
    bc;
    colormap = :navia,
    figure = (; size = (800, 400)),
    axis = (; aspect = DataAspect()),
)
scatter!(presences, color=:orange, markersize=1, colorrange=(0,1))
Colorbar(fig[:, end + 1], hm)
current_figure() #hide
