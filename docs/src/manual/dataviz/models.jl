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