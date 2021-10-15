# # Multivariate maps

using SimpleSDMLayers
using StatsPlots
using StatsPlots.PlotMeasures
using Statistics

# **Justification for this use case:** We can show more than one (specifically,
# two or three) variables on a single map, using a bivariate or trivariate color
# scale. In order to illustrate these mappings, we will look at the joint
# distribution of three measures: eveness of land use, terrain roughness, and
# proportion of urbanized land.

boundaries = (left=-12.0, right=30.0, bottom=36.0, top=72.0)
layer1 = convert(
    Float16,
    SimpleSDMPredictor(EarthEnv, HabitatHeterogeneity, 2; resolution=5, boundaries...),
)
layer2 = convert(
    Float16, SimpleSDMPredictor(EarthEnv, Topography, 7; resolution=5, boundaries...)
)

# The landcover data are finer than the other layers, so we will coarsen them.
# Because of rounding issues, the left and right cordinates need to be rounded.

layer3 = coarsen(convert(
    Float16, SimpleSDMPredictor(EarthEnv, LandCover, 9; boundaries...)
), mean, (5, 5))
layer3.left = round(layer3.left; digits=0)
layer3.right = round(layer3.right; digits=0)

# We finally mask everything according to the first layer

layer2 = mask(layer1, layer2);
layer3 = mask(layer1, layer3);

# Note that bivariate maps usually work best when used with 9 classes in total
# (so 3 for each side). The next decision is to take a bivaraite color palette,
# and the combinations below are [commonly
# used](https://www.joshuastevens.net/cartography/make-a-bivariate-choropleth-map/).
# Note that you can definitely use [diverging
# colors](https://www.personal.psu.edu/cab38/ColorSch/Schemes.html) if you want.
# If you use colors in the RGBA format (*e.g.* `colorant"#ef0ce8c4"`), the color
# map will account for transparency.

p0 = colorant"#e8e8e8"
bv_pal_1 = (p0=p0, p1=colorant"#64acbe", p2=colorant"#c85a5a")
bv_pal_2 = (p0=p0, p1=colorant"#73ae80", p2=colorant"#6c83b5")
bv_pal_3 = (p0=p0, p1=colorant"#9972af", p2=colorant"#c8b35a")
bv_pal_4 = (p0=p0, p1=colorant"#be64ac", p2=colorant"#5ac8c8")

# The bivariate map itself is a call to plot. Internally, this will transform
# the layers into quantiles (determined by the `classes` keyword, defaults to
# 3):

plot(layer1, layer3; st=:bivariate, bv_pal_3...)

# Note that you can use the `bivariate` shorthand as well:

pl1 = bivariate(layer1, layer3; classes=3, frame=:box, bv_pal_4...)
xaxis!(pl1, "Longitude")
yaxis!(pl1, "Latitude")

# We can repeat essentially the same process for the legend:

pl2 = bivariatelegend(layer1, layer3; classes=3, bv_pal_4...)
xaxis!(pl2, layernames(EarthEnv, HabitatHeterogeneity, 2))
yaxis!(pl2, layernames(EarthEnv, LandCover, 9))

# And now, we can plot the legend next to the map - future releases of the
# package will hopefully offer this in a far more user friendly way.

plot(pl1, pl2; layout=@layout [a{0.75w} b])

# Using the `subplot` and `inset` arguments of Plots.jl, we can have the legend
# within the figure. Note how in this example we expand the limits on the x axis
# to make the legend fit, but also use more classes in the map to have a
# smoother result.

p1 = bivariate(layer1, layer3; classes=6, bv_pal_2..., frame=:box, xlim=(-24, maximum(longitudes(layer1))))
xaxis!(p1, "Longitude")
yaxis!(p1, "Latitude")
p2 = bivariatelegend!(
    layer1,
    layer3;
    bv_pal_2...,
    inset=(1, bbox(0.04, 0.05, 0.28, 0.28, :top, :left)),
    subplot=2,
    xlab=layernames(EarthEnv, HabitatHeterogeneity, 2),
    ylab=layernames(EarthEnv, LandCover, 9),
    guidefontsize=7,
)

# Using a trivariate mapping follows the same process, with layers representing
# the red, green, and blue channel respectively.

plot(layer1, layer2, layer3; st=:trivariate)

# There are two options for this type of plots. The first is `quantiles=true`
# (which maps quantiles rather than raw values), and the second is
# `simplex=false`, which makes all values sum to 1 within a pixel. For example:

trivariate(layer1, layer2, layer3; quantiles=true, simplex=true)

# It is a good idea to question whether using `simplex` is appropriate. The
# legend can also be plotted using `trivariatelegend`:

trivariatelegend(layer1, layer2, layer3; quantiles=true, simplex=true)

# The legend function admits three additional arguments for the names of the
# `red`, `green`, and `blue` channels:

trivariatelegend(layer1, layer2, layer3; quantiles=true, simplex=true, red="Heterogeneity", green="Roughness", blue="Urban")

# We can also combine the two elements:

trivariate(layer1, layer2, layer3; xlim=(-24, maximum(longitudes(layer1))))
xaxis!(p1, "Longitude")
yaxis!(p1, "Latitude")
p2 = trivariatelegend!(layer1, layer2, layer3; inset=(1, bbox(0.04, 0.05, 0.28, 0.28, :top, :left)), subplot=2, red="Heterogeneity", green="Roughness", blue="Urban")