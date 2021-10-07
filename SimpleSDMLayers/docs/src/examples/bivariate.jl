# # Bivariate maps

using SimpleSDMLayers
using StatsPlots
using Colors, ColorBlendModes
using StatsPlots.PlotMeasures

# **Justification for this case study:** We can show more than one
# (specifically, two) variables on a single map, using a bivariate color scale.
# This currently involves a bit of manual manipulation, but will become part of
# the core package functionalities in the future.

# In order to illustrate bivariate mapping, we will look at the joint
# distribution of temperature and precipitation:

layer1, layer2 = SimpleSDMPredictor(WorldClim, BioClim, [1, 12]; left=-12., right=20., bottom=36., top=62.)

# The next step is to decide on quantiles breakpoints; for $n$ breakpoints,
# there will be $n-1$ classes, so if we want (for example) 4 classes, we will
# need:

breakpoints = LinRange(0.0, 1.0, 5)

# We set the breakpoints for 0 to 1 because we will convert the raw layers to
# this space, either by using quantiles, or by ranging them. Note that 16
# classes is a lot to take in, and bivariate maps usually work best when used
# with 9 classes.

# The next decision is to take a bivaraite color palette, and the combinations
# below are [commonly
# used](https://www.joshuastevens.net/cartography/make-a-bivariate-choropleth-map/).
# Note that you can definitely use [diverging
# colors](https://www.personal.psu.edu/cab38/ColorSch/Schemes.html) if you want.
#

p0 = colorant"#e8e8e8"
#p1, p2 = colorant"#64acbe", colorant"#c85a5a"
#p1, p2 = colorant"#73ae80", colorant"#6c83b5"
#p1, p2 = colorant"#9972af", colorant"#c8b35a"
p1, p2 = colorant"#be64ac", colorant"#5ac8c8"

# To make the code easier, we will simply create a palette with a set number of
# steps - this will be the first dimension:

c1 = palette([p0, p1], length(breakpoints) - 1)

# This will be the second dimension:

c2 = palette([p0, p2], length(breakpoints) - 1)

# Transforming the data into quantiles is a very good idea - it usually gives
# more readable maps:

q1 = rescale(layer1, collect(LinRange(0.0, 1.0, 10 * length(breakpoints))));
q2 = rescale(layer2, collect(LinRange(0.0, 1.0, 10 * length(breakpoints))));

# In order to produce the plot proper, we "simply" extract the values between
# breakpoints for either variables, and only plot this section in the correct
# color *blend*. This example uses `BlendMultiply`, but darkening blend also
# works.

pl1 = plot(; aspectratio=1, frame=:box, leg=false)
for i in 2:length(breakpoints)
    m1 = broadcast(v -> breakpoints[i - 1] <= v <= breakpoints[i], q1)
    for j in 2:length(breakpoints)
        m2 = broadcast(v -> breakpoints[j - 1] <= v <= breakpoints[j], q2)
        m = reduce(*, [m1, m2])
        replace!(m, false => nothing)
        plot!(pl1, convert(Float32, m); c=BlendMultiply(c1[i - 1], c2[j - 1]))
    end
end

xaxis!(pl1, "Longitude")
yaxis!(pl1, "Latitude")

# We can repeat essentially the same process for the legend:

pl2 = plot(; grid=:none, ticks=:none, aspectratio=1, leg=false)
w = breakpoints[2] - breakpoints[1]
h = breakpoints[2] - breakpoints[1]
for i in 2:length(breakpoints)
    for j in 2:length(breakpoints)
        c = BlendMultiply(c1[i - 1], c2[j - 1])
        plot!(
            pl2,
            Shape(breakpoints[i - 1] .+ [0, w, w, 0], breakpoints[j - 1] .+ [0, 0, h, h]);
            c=c,
        )
    end
end

xaxis!(pl2, (0, 1), "Temperature")#, ticks=breakpoints)
yaxis!(pl2, (0, 1), "Precipitation")#, ticks=breakpoints)

# And now, we can plot the legend next to the map - future releases of the
# package will hopefully offer this in a far more user friendly way.

plot(pl1, pl2; layout=@layout [a{0.75w} b])
