# # Bivariate and value-suppressing maps

# The package has functions to deal with bivariate maps, as well as
# value-suppressing uncertainty palettes.

using Revise
using SpeciesDistributionToolkit
const SDT = SpeciesDistributionToolkit
import Statistics
using CairoMakie
CairoMakie.activate!(; type = "png", px_per_unit = 2) #hide

# ::: warning A note about legends
#  
# Makie does not currently make it easy (possible?) to define custom legends
# from recipes. For this reason, the legends for bivariate and VSUP plots are
# provided as plots,
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

# The color palette can be set for each axis separately, for example to use a
# diverging colormap. We get the z-scores of precipitation and temperature, and
# clamp them to the -1, 1 interval:

z(layer::SDMLayer) = (layer - Statistics.mean(layer)) / Statistics.std(layer)

z1 = clamp(z(L[1]), -1, 1)
z2 = clamp(z(L[12]), -1, 1)

# The two color maps use complementary colors, the same midpoints, and the
# resulting figure is, to use a technical term, an absolute abomination.

bivariate(
    z1,
    z2;
    xcolormap = [:gold, :seashell, :darkorchid2],
    ycolormap = [:skyblue, :seashell, :darkorange],
    xbins = 25,
    ybins = 25,
    axis = (aspect = DataAspect(),)
)

# ## VSUP

# Model
base_model = SDM(PCATransform, Logistic, SDeMo.__demodata()...)
variables!(base_model, BackwardSelection)
variables!(base_model, ForwardSelection)

# Bootstrapped model
model = Bagging(base_model, 20)
train!(model)

# Get the prediction and uncertainty
val = predict(base_model, L; threshold = false)
unc = predict(model, L; threshold = false, consensus = iqr)

# ## VSUP

vsup(val, unc)

# this needs to be ported

direction, angle = π / 2, -π

kwargs = (bins = 3, colormap = [:mediumseagreen, :darkorange2], color = colorant"#f0f0f0")

# full example with legend

f = Figure(; size = (400, 600))
ax = Axis(f[1, 1]; aspect = DataAspect())

le = PolarAxis(f[1, 1];
    width = Relative(0.69),
    height = Relative(0.23),
    halign = 0.0,
    valign = 1.0,
    thetaticks = vsuplegendticks(val, 4, direction - angle / 2, direction + angle / 2),
    rticks = vsuplegendticks(unc, 2, direction - angle / 2, direction + angle / 2),
    rticklabelrotation = pi / 2,
)

vsup!(ax, val, unc; kwargs...)
lines!(ax, pol; color = :black)
vsuplegend!(le, val, unc; kwargs..., direction = direction, span = angle)
autolimits!(le)
tightlimits!(le)
hidespines!(ax)
hidedecorations!(ax)
scatter!(
    le,
    rescale(val, direction - angle / 2, direction + angle / 2),
    rescale(unc, 3, 0);
    color = :grey20,
    markersize = 1,
    alpha = 0.5,
)
current_figure()