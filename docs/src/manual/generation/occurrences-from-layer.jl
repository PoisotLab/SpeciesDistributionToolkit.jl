# # From layers to occurrences

using Revise
using SpeciesDistributionToolkit
const SDT = SpeciesDistributionToolkit
using CairoMakie

# The package can generate occurrences from Boolean layers. We will demonstrate
# this by generating a presence and absence layer based on the SDM demonstration
# data:

model = SDM(RawData, NaiveBayes, SDeMo.__demodata()...)

# This layer will serve as a reference for the boolean layer that will mark the
# presence or absence of the species.

pol = getpolygon(PolygonData(OpenStreetMap, Places); place="Corse")
L = SDMLayer(RasterData(CHELSA2, AverageTemperature); SDT.boundingbox(pol)...)
mask!(L, pol)

# ::: tip Spatial thinning
# 
# This process means that all the occurrences within a single cell are replaced
# by a single one, located at the center of the cell. This is a good way to
# ensure that cells that are oversampled are not over-represented.
# 
# :::

# ## Generating a layer from occurrences

# We will then mask this layer by the series of occurrences we get from the
# model. Note that for the presence layer, we remove (`nodata!`) all the cells
# with a value of `false`.

L₊ = nodata(
    mask(
        L,
        Occurrences(model),
        presences # [!code highlight]
    ),
    false
)

# Removing the cells with a value of `false` is extremely important here,
# because these can correspond to two things: either the species was absent at
# this cell, or we do not have any information at this cell. Note also that we
# are adding a third argument to `mask`, which will filter the occurrences by
# either `presences` or `absences`.

# We now do the same process again, this time on the `absences` from our
# occurrences collection. Note here that we end up with a layer containing
# `false` when the cell was assigned to the absence of the species, and nothing
# in all other cases.

L₋ = !nodata(mask(L, Occurrences(model), absences), false)

# ## Generating occurrences from a layer

#  We can get occurrences out of the layer with the following lines:

O₊ = Occurrences(L₊; entity="Sitta whiteheadi");
O₋ = Occurrences(L₋; entity="Sitta whiteheadi");

# ::: info Entity name
#
# We need to specify the entity name here, because the layers do not keep track
# of this information. It is very rarely important to actually do this, but this
# is demonstrated in case it may be useful.
#
# :::

#  Alternatively, we can create a presence/absence dataset with the following
#  syntax:

O = Occurrences(L₊, L₋; entity="Sitta whiteheadi")

# ::: tip Representation of the absences layer
#
# When used with two `SDMLayer{Bool}`, `Occurrences` will not care if the second
# layer (absences) is storing its data as `false` (species presence is recorded)
# or `true` (absence is recoded) - all it will check is that the layers contain
# a single `Bool` value.
#
# The line above is equivalent to `Occurrences(L₊, !L₋)`
#
# :::

# We can finally draw a [scatter plot of occurrences](/manual/dataviz/occurrences/):

#figure Occurrences extracted from the layer
f = Figure()
ax = Axis(f[1,1]; aspect=DataAspect())
poly!(ax, pol, color=:grey90)
scatter!(ax, presences(O), color=:red, markersize=8, marker=:rect)
scatter!(ax, absences(O), color=:grey30, markersize=6)
hidedecorations!(ax)
hidespines!(ax)
current_figure() #hide