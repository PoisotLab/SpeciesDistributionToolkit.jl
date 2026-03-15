# # Plotting models

# The SDMs are integrated with the [Makie](https://docs.makie.org/stable/)
# plotting package.

using SpeciesDistributionToolkit
using CairoMakie
CairoMakie.activate!(; type = "png", px_per_unit = 2) #hide

# We will use the demonstration data from the `SDeMo` package:

model = SDM(RawData, NaiveBayes, SDeMo.__demodata()...)

# ## Plotting instances

f = Figure()
ax = Axis(f[1,1], aspect=DataAspect())
scatter!(ax, model)
current_figure()

# This can be coupled with information about the model itself, to provide more
# interesting visualisations:

f = Figure()
ax = Axis(f[1,1], aspect=DataAspect())
scatter!(ax, model, color=labels(model))
current_figure()

# Note that models also implement the occurences interface, so this is also
# valid:

import OccurrencesInterface as OI
f = Figure()
ax = Axis(f[1,1], aspect=DataAspect())
scatter!(ax, OI.presences(model), color=:white, strokecolor=:red, strokewidth=1, label="Presences")
scatter!(ax, OI.absences(model), color=:white, strokecolor=:pink, strokewidth=0.5, markersize=3, label="Absences")
axislegend(ax)
current_figure()

# ## Model diagnostic plots

# These plots require a trained model:

train!(model)

# ::: info Coming soon
#
# These plots will be included in a future release of  `SDeMo`- stay tuned! 
#
# :::