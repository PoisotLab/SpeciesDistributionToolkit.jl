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

contour(temperature, c=:cividis, title="Temperature", frame=:box, clim=(-50,50), fill=true,
    xlabel = "Longitude",
    ylabel= "Latitude")
savefig(joinpath("gallery", "filled_contour.png"))

cmap = coarsen(temperature, minimum, (10,10))
@info cmap
@info eltype(cmap)
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

end
