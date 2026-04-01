# # Bivariate maps

# The package has functions to deal with bivariate maps.

using Revise
using SpeciesDistributionToolkit
const SDT = SpeciesDistributionToolkit
import Statistics
using CairoMakie

# ::: info A note about legends
#  
# Makie does not currently make it easy (possible?) to define custom legends
# from recipes. For this reason, the legends for bivariate plots are provided as
# plots. Note that Makie recipes also (as far as we can tell) do not set default
# axis properties, so getting the legends is a little more awkward than we'd
# like.
#
# :::

# ## Getting data

pol = getpolygon(PolygonData(OpenStreetMap, Places); place = "Corsica");
spatialextent = SDT.boundingbox(pol; padding = 0.1)

# We will get a series of layers here for illustrations:

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