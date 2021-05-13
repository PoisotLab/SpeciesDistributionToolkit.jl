module SSLTestPlots
using SimpleSDMLayers
using Test
using Plots
using StatsPlots

temperature, precipitation = SimpleSDMPredictor(WorldClim, BioClim, [1,12])

ispath("gallery") || mkpath("gallery")

chelsa1 = SimpleSDMPredictor(CHELSA, BioClim, 1; left=-11.0, right=31.1, bottom=29.0, top=71.1)
n_chelsa1 = zeros(Float32, size(chelsa1));
for (i,e) in enumerate(chelsa1.grid)
  n_chelsa1[i] = isnothing(e) ? NaN : Float32(e)
end
chelsa1 = SimpleSDMPredictor(n_chelsa1, chelsa1)
plot(chelsa1, c=:heat, title="Temperature from CHELSA", frame=:box,
    xlabel = "Longitude",
    ylabel= "Latitude")
savefig(joinpath("gallery", "range-comparison-chelsa.png"))

wc1 = SimpleSDMPredictor(WorldClim, BioClim, 1; left=-11.0, right=31.1, bottom=29.0, top=71.1)
plot(wc1, c=:heat, title="Temperature from worldclim @ 10", frame=:box,
    xlabel = "Longitude",
    ylabel= "Latitude")
savefig(joinpath("gallery", "range-comparison-worldclim-10.png"))

wc1 = SimpleSDMPredictor(WorldClim, BioClim, 1; resolution=5.0, left=-11.0, right=31.1, bottom=29.0, top=71.1)
plot(wc1, c=:heat, title="Temperature from worldclim @ 5", frame=:box,
    xlabel = "Longitude",
    ylabel= "Latitude")
savefig(joinpath("gallery", "range-comparison-worldclim-5.png"))

lc1 = SimpleSDMPredictor(EarthEnv, LandCover, 1; left=-11.0, right=31.1, bottom=29.0, top=71.1)
n_lc1 = zeros(Float32, size(lc1));
for (i,e) in enumerate(lc1.grid)
  n_lc1[i] = isnothing(e) ? NaN : Float32(e)
end
lc1 = SimpleSDMPredictor(n_lc1, lc1)
plot(lc1, c=:terrain, title="Landcover class 1", frame=:box,
    xlabel = "Longitude",
    ylabel= "Latitude")
savefig(joinpath("gallery", "range-comparison-landcover.png"))

plot(temperature, c=:magma, title="Temperature", frame=:box,
    xlabel = "Longitude",
    ylabel= "Latitude")
savefig(joinpath("gallery", "heatmap.png"))

contour(temperature, c=:viridis, title="Temperature", frame=:box,
    xlabel = "Longitude",
    ylabel= "Latitude")
savefig(joinpath("gallery", "contour.png"))

contour(temperature, c=:cividis, title="Temperature", frame=:box,
    fill=true, lw=0.0,
    xlabel = "Longitude",
    ylabel= "Latitude")
savefig(joinpath("gallery", "filled_contour.png"))

cmap = coarsen(temperature, minimum, (10,10))
heatmap(cmap, c=:RdYlBu, title="Temperature", frame=:box)
xaxis!("Longitude")
yaxis!("Latitude")
savefig(joinpath("gallery", "heatmap_scaledown.png"))

histogram(precipitation, leg=false)
xaxis!("Precipitation")
savefig(joinpath("gallery", "histogram.png"))

density(precipitation, leg=false)
xaxis!("Precipitation")
savefig(joinpath("gallery", "density.png"))

plot(temperature, precipitation, leg=false, c=:grey, msc=:grey, alpha=0.5)
xaxis!("Temperature")
yaxis!("Precipitation")
savefig(joinpath("gallery", "scatter.png"))

histogram2d(temperature, precipitation, leg=false)
xaxis!("Temperature")
yaxis!("Precipitation")
savefig(joinpath("gallery", "scatter-2d.png"))

a = rand(Bool, 100, 100)
a = convert(Matrix{Union{Bool,Nothing}}, a)
a[rand(eachindex(a), 100)] .= nothing
S = SimpleSDMResponse(a)

plot(convert(Float64, S))
savefig(joinpath("gallery", "booltype.png"))

end
