# # Bivariate maps

using SimpleSDMLayers
using StatsPlots
using Colors, ColorBlendModes
using StatsPlots.PlotMeasures

# **Justification for this case study:** We can show more than one
# (specifically, two) variables on a single map, using a bivariate color scale.
# This currently involves a bit of manual manipulation, but will become part of
# the core package functionalities in the future.

layer1, layer2 = SimpleSDMPredictor(WorldClim, BioClim, [1, 12]; bottom=-60.0)#; left=-12., right=20., bottom=36., top=62.)

#-

plot(layer1)

# We need to decide on quantiles breakpoints

breakpoints = LinRange(0.0, 1.0, 4)

# Bivariate color scales (these combinations are the most common)

p0 = colorant"#f8f8f8"
#p1, p2 = colorant"#64acbe", colorant"#c85a5a"
#p1, p2 = colorant"#be64ac", colorant"#5ac8c8"
p1, p2 = colorant"#73ae80", colorant"#6c83b5"
#p1, p2 = colorant"#9972af", colorant"#c8b35a"

# Palette

c1 = palette([p0, p1], length(breakpoints) - 1)
c2 = palette([p0, p2], length(breakpoints) - 1)

# Quantile transformation of layers

q1 = rescale(layer1, collect(LinRange(0.0, 1.0, 4 * length(breakpoints))))
q2 = rescale(layer2, collect(LinRange(0.0, 1.0, 4 * length(breakpoints))))

# bivariate map plot

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

# Legend inset

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

# Output - it would be better for the legend to be within the first plot

plot(pl1, pl2; layout=@layout [a{0.75w} b])
