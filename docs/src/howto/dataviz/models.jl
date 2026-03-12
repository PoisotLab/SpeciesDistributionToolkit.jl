# # Plotting models

# The SDMs are integrated with the [Makie](https://docs.makie.org/stable/)
# plotting package.

using SpeciesDistributionToolkit
using CairoMakie
CairoMakie.activate!(; type = "png", px_per_unit = 2) #hide

# We will use the demonstration data from the `SDeMo` package:

model = SDM(RawData, Logistic, SDeMo.__demodata()...)

# ## Plotting instances

scatter(model)

# This can be coupled with information about the model itself, to provide more
# interesting visualisations:

scatter(model, color=labels(model))

# ## Model diagnostic plots

# These plots require a trained model:

train!(model)

# ### Ceteris paribus

# The _ceteris paribus_ plot allows seeing the effect of all possible values of
# a feature on a specific instance. For exemple, this is how the prediction for
# instance 4 is affected by a change in the BIO1 variable (mean annual
# temperature):

cpplot(model, 4, 1)

# This plot can be drawn as a line rather than stairs:

cpplot(model, 4, 1; stairs=false)

# The line attributes can be changed:

cpplot(model, 4, 1; stairs=false, linewidth=2, color=:red, linestyle=:dash)

# The plot can also be presented by centering the x axis to the midpoint value:

cpplot(model, 4, 1; center=:midpoint)

# Or to the value of the feature for this specific instance:

cpplot(model, 4, 1; center=:value)

# ### Individual conditional expectations

# The ICE plot is the superposition of multiple CP plots. It uses the same
# arguments, but the instances are given as a range or collection.

# To plot all the instances, we can use:

iceplot(model, 1)

# Because this creates a lot of overplotting, it is a good idea to tweak the
# transparency:

iceplot(model, 1; alpha=0.2, center=:midpoint, stairs=false)

# The list of instances to use can also be given as a collection:

iceplot(model, findall(labels(model)), 1; alpha=0.2, stairs=false, color=:darkgreen, label="Presence")
iceplot!(model, findall(!, labels(model)), 1; alpha=0.2, stairs=false, color=:grey50, label="Absence")
axislegend(current_axis())
current_figure()

# ### Partial dependence

# The partial dependence plot is the average of all CP plots. The instances to
# use in it are specified like in the ICE plots.

partialdependenceplot(model, 1)

# We can also pass a `ribbon` function to draw a band around the line:

import Statistics
partialdependenceplot(model, 1; ribbon=Statistics.std, stairs=false, background=:skyblue, color=:darkblue)

# We can also only specify only some instances:

partialdependenceplot(model, findall(labels(model)), 1; ribbon=Statistics.std, stairs=false, background=:grey95, color=:orange)