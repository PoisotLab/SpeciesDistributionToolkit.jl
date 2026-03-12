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



# ### Partial dependence