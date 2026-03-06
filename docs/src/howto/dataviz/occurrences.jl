# # Plotting occurrences

# The layers are integrated with the [Makie](https://docs.makie.org/stable/)
# plotting package.

using SpeciesDistributionToolkit
using CairoMakie
CairoMakie.activate!(; type = "png", px_per_unit = 2) #hide

# We can get the demo occurrences:

occ = OccurrencesInterface.__demodata()

# ## Scatterplot

scatter(occ, color=:darkgreen)

# ## Density

hexbin(occ, bins=50, colormap=Reverse(:navia))