# # ... plot layers using Makie?

# The layers are integrated with the [Makie](https://docs.makie.org/stable/)
# plotting package.

using SpeciesDistributionToolkit
using CairoMakie
CairoMakie.activate!(; type = "png", px_per_unit = 3.0) #hide

# Let's grab two layers:

spatial_extent = (; left = -4.87, right=9.63, bottom=41.31, top=51.14)
data_prov = RasterData(CHELSA1, BioClim)
temperature = 0.1SDMLayer(data_prov; layer="BIO1", spatial_extent...)
precipitation = SDMLayer(data_prov; layer="BIO8", spatial_extent...)

# ::: info Additional arguments
# 
# All of these plots can be further customized by passing the usual arguments to
# Makie plots.
# 
# :::

# ## Recipes for a single layer

# ### Heatmap

heatmap(temperature; axis=(; aspect=DataAspect()))

# ### Contour

contour(temperature; axis=(; aspect=DataAspect()))

# ### Filled contour

contourf(temperature; axis=(; aspect=DataAspect()))

# ### Histogram

hist(temperature)

# ### Density

density(temperature)

# ### Step histogram

stephist(temperature)

# ### ECDF plot

ecdfplot(temperature)

# ## Recipes for two layers

# ### Scatterplot

scatter(precipitation, temperature)

# ### Density

hexbin(precipitation, temperature)

# ## Recipes that you probably should not use

surface(0.0005precipitation)