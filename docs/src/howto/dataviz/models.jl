# # Plotting models

# The SDMs are integrated with the [Makie](https://docs.makie.org/stable/)
# plotting package.

using SpeciesDistributionToolkit
using CairoMakie
CairoMakie.activate!(; type = "png", px_per_unit = 3) #hide

# We will use the demonstration data from the `SDeMo` package:

model = SDM(RawData, NaiveBayes, SDeMo.__demodata()...)

# ## Plotting instances

scatter(model)

# This can be coupled with information about the model itself, to provide more
# interesting visualisations:

scatter(model, color=labels(model))

# ## Model diagnostic plots

# These plots require a trained model:

train!(model)

# ::: info Coming soon
#
# These plots will be included in a future release of  `SDeMo`- stay tuned! 
#
# :::