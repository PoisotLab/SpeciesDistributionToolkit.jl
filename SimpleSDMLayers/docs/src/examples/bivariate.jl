# # Bivariate maps

using SimpleSDMLayers
using StatsPlots
using StatsPlots.PlotMeasures

# **Justification for this use case:** We can show more than one (specifically,
# two) variables on a single map, using a bivariate color scale. In order to
# illustrate bivariate mapping, we will look at the joint distribution of two
# measures: eveness of land use, and terrain roughness. We will trasnform the
# values into quantiles, as this is generally prefered for bivariate maps.

boundaries = (left=-12.0, right=30.0, bottom=36.0, top=72.0)
layer1 = convert(
    Float16,
    SimpleSDMPredictor(EarthEnv, HabitatHeterogeneity, 2; resolution=5, boundaries...),
)
layer2 = convert(
    Float16, SimpleSDMPredictor(EarthEnv, Topography, 7; resolution=5, boundaries...)
)
q1 = rescale(layer1, collect(LinRange(0.0, 1.0, 100)));
q2 = mask(q1, rescale(layer2, collect(LinRange(0.0, 1.0, 100))));

# Note that bivariate maps usually work best when used with 9 classes in total
# (so 3 for each side). The next decision is to take a bivaraite color palette,
# and the combinations below are [commonly
# used](https://www.joshuastevens.net/cartography/make-a-bivariate-choropleth-map/).
# Note that you can definitely use [diverging
# colors](https://www.personal.psu.edu/cab38/ColorSch/Schemes.html) if you want.

p0 = colorant"#e8e8e8"
bv_pal_1 = (p0=p0, p1=colorant"#64acbe", p2=colorant"#c85a5a")
bv_pal_2 = (p0=p0, p1=colorant"#73ae80", p2=colorant"#6c83b5")
bv_pal_3 = (p0=p0, p1=colorant"#9972af", p2=colorant"#c8b35a")
bv_pal_4 = (p0=p0, p1=colorant"#be64ac", p2=colorant"#5ac8c8")

# The bivariate map itself is a call to plot:

plot(q1, q2; st=:bivariate, bv_pal_3...)

# Note that you can use the `bivariate` shorthand as well:

pl1 = bivariate(q1, q2; classes=3, frame=:box, bv_pal_4...)
xaxis!(pl1, "Longitude")
yaxis!(pl1, "Latitude")

# We can repeat essentially the same process for the legend:

pl2 = bivariatelegend(q1, q2; classes=3, bv_pal_4...)
xaxis!(pl2, layernames(EarthEnv, HabitatHeterogeneity)[2])
yaxis!(pl2, layernames(EarthEnv, Topography)[7])

# And now, we can plot the legend next to the map - future releases of the
# package will hopefully offer this in a far more user friendly way.

plot(pl1, pl2; layout=@layout [a{0.75w} b])

# Using the `subplot` and `inset` arguments of Plots.jl, we can have the legend
# within the figure. Note how in this example we expand the limits on the x axis
# to make the legend fit, but also use more classes in the map to have a
# smoother result.

p1 = bivariate(q1, q2; classes=6, bv_pal_2..., frame=:box, xlim=(-24, maximum(longitudes(q1))))
xaxis!(p1, "Longitude")
yaxis!(p1, "Latitude")
p2 = bivariatelegend!(
    q1,
    q2;
    bv_pal_2...,
    inset=(1, bbox(0.04, 0.05, 0.28, 0.28, :top, :left)),
    subplot=2,
    xlab=layernames(EarthEnv, HabitatHeterogeneity)[2],
    ylab=layernames(EarthEnv, Topography)[7],
    guidefontsize=7,
)
