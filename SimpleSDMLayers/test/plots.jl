module SSLTestPlots
using SimpleSDMLayers
using Test
using Plots

temperature, precipitation = worldclim([1,12])

ispath("gallery") || mkpath("gallery")

plot(temperature, c=:magma, title="Temperature", frame=:box,
    xlabel = "Longitude",
    ylabel= "Latitude")
savefig(joinpath("gallery", "heatmap.png"))

contour(temperature, c=:viridis, title="Temperature", frame=:box,
    xlabel = "Longitude",
    ylabel= "Latitude")
savefig(joinpath("gallery", "contour.png"))

contour(temperature, c=:cividis, title="Temperature", frame=:box, fill=true,
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
savefig(joinpath("gallery", "density.png"))

plot(temperature, precipitation, leg=false, c=:grey, msc=:grey, alpha=0.5)
xaxis!("Temperature")
yaxis!("Precipitation")
savefig(joinpath("gallery", "scatter.png"))

histogram2d(temperature, precipitation, leg=false)
xaxis!("Temperature")
yaxis!("Precipitation")
savefig(joinpath("gallery", "scatter-2d.png"))

chelsa1 = bioclim(1; left=-5.0, right=7.0, bottom=30.0, top=45.0)
n_chelsa1 = zeros(Float32, size(chelsa1));
for (i,e) in enumerate(chelsa1.grid)
  n_chelsa1[i] = isnothing(e) ? NaN : Float32(e)
end
chelsa1 = SimpleSDMPredictor(n_chelsa1, chelsa1)
plot(chelsa1, c=:heat, title="Temperature", frame=:box,
    xlabel = "Longitude",
    ylabel= "Latitude")
savefig(joinpath("gallery", "chelsa-heatmap.png"))

lc1 = landcover(1; left=-5.0, right=7.0, bottom=30.0, top=45.0)
n_lc1 = zeros(Float32, size(lc1));
for (i,e) in enumerate(lc1.grid)
  n_lc1[i] = isnothing(e) ? NaN : Float32(e)
end
lc1 = SimpleSDMPredictor(n_lc1, lc1)
plot(lc1, c=:terrain, title="Landcover class 1", frame=:box,
    xlabel = "Longitude",
    ylabel= "Latitude")
savefig(joinpath("gallery", "lc-heatmap.png"))

end
