# # ... plot layers using Makie?

# The layers are integrated with the [Makie](https://docs.makie.org/stable/)
# plotting package.

using SpeciesDistributionToolkit
using CairoMakie
CairoMakie.activate!(; type = "png", px_per_unit = 3.0) #hide

# Let's grab two layers:

spatial_extent = (; left = -4.87, right=9.63, bottom=41.31, top=51.14)
temp_prov = RasterData(WorldClim2, BioClim)
elev_prov = RasterData(WorldClim2, Elevation)
temperature = SDMLayer(temp_prov; layer="BIO1", resolution=2.5, spatial_extent...)
elevation = SDMLayer(elev_prov; resolution=2.5, spatial_extent...)

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

scatter(elevation, temperature)

# ### Density

hexbin(elevation, temperature)

# ## Recipes that you probably should not use

surface(0.0005elevation)