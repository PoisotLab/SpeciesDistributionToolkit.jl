module SSLTestPlots
using SimpleSDMLayers
using Test
using Plots

temperature, precipitation = worldclim([1,12])

ispath("gallery") || mkpath("gallery")

plot(temperature, c=:RdYlBu, title="Temperature", frame=:box, clim=(-50,50),
    xlabel = "Longitude",
    ylabel= "Latitude")
savefig(joinpath("gallery", "heatmap.png"))

contour(temperature, c=:RdYlBu, title="Temperature", frame=:box, clim=(-50,50),
    xlabel = "Longitude",
    ylabel= "Latitude")
savefig(joinpath("gallery", "contour.png"))

contour(temperature, c=:RdYlBu, title="Temperature", frame=:box, clim=(-50,50), fill=true,
    xlabel = "Longitude",
    ylabel= "Latitude")
savefig(joinpath("gallery", "filled_contour.png"))

heatmap(coarsen(temperature, minimum, (10,10)), c=:RdYlBu, title="Temperature", frame=:box, clim=(-50,50))
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
