module SSLTestPlots
using SimpleSDMLayers
using Test
using Plots

wc1, wc2 = worldclim([1,2])

heatmap(wc1)
savefig(joinpath("..", "gallery", "heatmap.png"))

histogram(wc1)
savefig(joinpath("..", "gallery", "density.png"))

plot(wc2)

end
