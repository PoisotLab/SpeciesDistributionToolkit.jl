# # Plotting models

# The SDMs are integrated with the [Makie](https://docs.makie.org/stable/)
# plotting package.

using SpeciesDistributionToolkit
using CairoMakie

# We will use the demonstration data from the `SDeMo` package:

model = SDM(RawData, NaiveBayes, SDeMo.__demodata()...)

# ## Plotting instances

f = Figure()
ax = Axis(f[1, 1]; aspect = DataAspect())
scatter!(ax, model)
current_figure()

# This can be coupled with information about the model itself, to provide more
# interesting visualisations:

f = Figure()
ax = Axis(f[1, 1]; aspect = DataAspect())
scatter!(ax, model; color = labels(model))
current_figure()

# Note that models also implement the occurences interface, so we can easily
# split presence and absences from the model.

f = Figure()
ax = Axis(f[1, 1]; aspect = DataAspect())
scatter!(
    ax,
    presences(model);
    color = :white,
    strokecolor = :orange,
    strokewidth = 1,
    label = "Presences",
)
scatter!(
    ax,
    absences(model);
    color = :white,
    strokecolor = :teal,
    strokewidth = 0.5,
    markersize = 5,
    label = "Absences",
)
axislegend(ax; position = :lt)
hidespines!(ax)
hidedecorations!(ax)
current_figure()

# The models currently do _not_ have a field for the species name, but this will
# be part of a future release. If you need to specify the species name from a
# model, for now you need to use `Occurrences(model; name="Sitta whiteheadi")`.

# ## Model diagnostic plots

# These plots require a trained model:

train!(model)

# ### Ceteris paribus

# The _ceteris paribus_ plot allows seeing the effect of all possible values of
# a feature on a specific instance. For example, this is how the prediction for
# instance 4 is affected by a change in the BIO1 variable (mean annual
# temperature).

# All of these plots have a feature (values of) in the x axis, and the resulting
# prediction on the y axis.

cpplot(model, 4, 1)

# This plot can be drawn as a line rather than stairs:

cpplot(model, 4, 1; stairs=false)

# The line attributes can be changed:

cpplot(model, 4, 1; stairs=false, linewidth=2, color=:red, linestyle=:dash)

# The plot can also be presented by centering the x axis to the midpoint value:

cpplot(model, 4, 1; center=:midpoint)

# Or to the value of the feature for this specific instance:

cpplot(model, 4, 1; center=:value)

# CP plots can also be produced for two variables:

cpplot(model, 4, 4, 6; colormap=:YlGnBu)

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

# We can also specify to only run the plot for some instances:

partialdependenceplot(model, findall(labels(model)), 1; ribbon=Statistics.std, stairs=false, background=:grey95, color=:orange)