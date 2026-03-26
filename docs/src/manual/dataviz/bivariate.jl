# # Bivariate and value-suppressing maps

# The package has functions to deal with bivariate maps, as well as
# value-suppressing uncertainty palettes.

using Revise
using SpeciesDistributionToolkit
const SDT = SpeciesDistributionToolkit
import Statistics
using CairoMakie

# ::: info A note about legends
#  
# Makie does not currently make it easy (possible?) to define custom legends
# from recipes. For this reason, the legends for bivariate and VSUP plots are
# provided as plots. Note that Makie recipes also (as far as we can tell) do not
# set default axis properties, so getting the legends is a little more awkward
# than we'd like.
#
# :::

# ## Getting data

pol = getpolygon(PolygonData(OpenStreetMap, Places); place = "Corsica");
spatialextent = SDT.boundingbox(pol; padding = 0.1)

# some layers

provider = RasterData(CHELSA2, BioClim)
L = SDMLayer{Float32}[
    SDMLayer(
        provider;
        layer = i,
        spatialextent...,
    ) for i in layers(provider)
]

mask!(L, pol)

# ## Bivariate

# Bivariate maps encode two dimensions of information in a single palette. They
# take two layers as arguments.

bivariate(L[1], L[12]; axis = (aspect = DataAspect(),))

# The number of bins for each dimension can be changed.

bivariate(L[1], L[12]; xbins = 25, ybins = 25, axis = (aspect = DataAspect(),))

# The extension comes with a handful of robust color choices, which need to be
# called and then splatted.

bivariate(L[1], L[12]; StevensRedBlue()..., axis = (aspect = DataAspect(),))

#

bivariate(L[1], L[12]; StevensYellowPurple()..., axis = (aspect = DataAspect(),))

#

bivariate(L[1], L[12]; StevensBluePurple()..., axis = (aspect = DataAspect(),))

#

bivariate(L[1], L[12]; StevensBlueGreen()..., axis = (aspect = DataAspect(),))

#

bivariate(L[1], L[12]; ArcMapOrangeBlue()..., axis = (aspect = DataAspect(),))

# The legend of a bivariate colormap is simply a heatmap.

f = Figure()
ax = Axis(f[1, 1]; aspect = DataAspect())
le = Axis(f[1, 2]; aspect = 1, xlabel = "Temperature", ylabel = "Precipitation")

bivariate!(ax, L[1], L[12]; ArcMapOrangeBlue()..., xbins = 3, ybins = 3)

bivariatelegend!(le, L[1], L[12];
    ArcMapOrangeBlue()...,
    xbins = 3,
    ybins = 3)

tightlimits!(ax)
hidespines!(ax)
hidedecorations!(ax)
tightlimits!(le)
scatter!(le, L[1], L[12]; color = :grey30, markersize = 1)

current_figure()

# The color palette can be set for each axis separately, for example to use a
# diverging colormap. We get the z-scores of precipitation and temperature, and
# clamp them to the -1, 1 interval:

z(layer::SDMLayer) = (layer - Statistics.mean(layer)) / Statistics.std(layer)

z1 = clamp(z(L[1]), -1.5, 1.5)
z2 = clamp(z(L[12]), -1.5, 1.5)

# The two color maps use complementary colors, the same midpoints, and the
# resulting figure is, to use a technical term, an absolute abomination.

palettes = (
    xcolormap = [:gold, :seashell, :darkorchid2],
    ycolormap = [:skyblue, :seashell, :darkorange],
)

f = Figure()
ax = Axis(f[1, 1]; aspect = DataAspect())
le = Axis(
    f[1, 2];
    aspect = 1,
    xlabel = "Normalized temperature",
    ylabel = "Normalized precipitation",
)
bivariate!(
    ax,
    z1,
    z2;
    palettes...,
    xbins = 7,
    ybins = 7)

bivariatelegend!(le, z1, z2;
    palettes...,
    xbins = 7,
    ybins = 7)

tightlimits!(ax)
hidespines!(ax)
hidedecorations!(ax)
tightlimits!(le)

current_figure()

# ## VSUP

# Value Suppressing Uncertainty Palettes (VSUPs) are a way to downgrade a color
# palette towards a specific color in order to mask values that are increasingly
# uncertain. We will illustrate this by showing the prediction of an SDM, but
# also convey some information about uncertainty (through bootstrap).

base_model = SDM(RawData, Logistic, SDeMo.__demodata()...)
variables!(base_model, ForwardSelection)
model = Bagging(base_model, 20)
train!(model)

# We get two layers: one for the prediction, and one for the uncertainty.

val = predict(base_model, L; threshold = false)
unc = predict(model, L; threshold = false, consensus = iqr)

# This is the default output of a VSUP:

vsup(val, unc; axis = (; aspect = DataAspect()))

# Because VSUP are binary partitions, the number of uncertainty bins n will
# determine the number of value bins. In our experience, a number of bins
# between 4 (8 classes for value) and 5 (16 classes for values) is ideal. Larger
# number of bins give a smoother output, but can make interpretation less
# obvious:

vsup(val, unc; axis = (; aspect = DataAspect()), bins = 10)

# We can change the color associated to uncertain areas:

vsup(val, unc; axis = (; aspect = DataAspect()), color = colorant"#ff0000")

# We can also change the color map used to display the value:

vsup(
    val,
    unc;
    axis = (; aspect = DataAspect()),
    colormap = [:cadetblue, :tan3],
    color = colorant"#d0d0d0",
)

# The legend of a VSUP is presented as a wedge, where increasingly uncertain
# cells are merged together, and averaged towards the color for uncertain
# values. It must be added to a _polar_ axis, which has two key parameters: the
# direction towards which it points, and the angle covered by the values:

kwargs = (bins = 4, colormap = [:purple, :skyblue], color = colorant"#f0f0f0")
vsuplegend(val, unc; kwargs..., direction = π / 4, span = π / 2)

# Note that this is returned as a default polar axis, and so needs a little bit
# of work. We can start by setting the correct limits:

direction, angle = π / 5, π / 2.5

f, ax, pl = vsuplegend(val, unc; kwargs..., direction = direction, span = angle)
autolimits!(ax)
tightlimits!(ax)
f

# We also need to change the ticks for the uncertainty dimension. The order of
# arguments for the `vsuplegendticks` function is the layer, the desired number
# of ticks, and then the axis limits (for the uncertainty, this goes _from_ the
# number of bins _to_ 0):

ax.rticks = vsuplegendticks(unc, 7, 5, 0)
f

# We can do the same thing for the value ticks

ax.thetaticks = vsuplegendticks(val, 10, direction - angle / 2, direction + angle / 2)
f

# Putting everyhing together, we can get to a fairly good result:

f = Figure(; size = (400, 600))
ax = Axis(f[1, 1]; aspect = DataAspect())

le = PolarAxis(f[1, 1];
    width = Relative(0.69),
    height = Relative(0.235),
    halign = 0.0,
    valign = 1.0,
    thetaticks = vsuplegendticks(val, 5, direction - angle / 2, direction + angle / 2),
    rticks = vsuplegendticks(unc, 3, 5, 0),
    rticklabelrotation = pi / 2,
)

vsup!(ax, val, unc; kwargs...)
lines!(ax, pol; color = :black)
vsuplegend!(le, val, unc; kwargs..., direction = direction, span = angle)
autolimits!(le)
tightlimits!(le)
hidespines!(ax)
hidedecorations!(ax)
current_figure()