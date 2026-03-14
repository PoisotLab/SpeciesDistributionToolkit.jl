using Revise
using CairoMakie
using SpeciesDistributionToolkit
const SDT = SpeciesDistributionToolkit

# Get data
pol = getpolygon(PolygonData(NaturalEarth, Countries))["Kenya"]
bb = SDT.boundingbox(pol)

layer = SDMLayer(RasterData(CHELSA2, AverageTemperature); bb...)
mask!(layer, pol)
L = interpolate(layer, dest="EPSG:5382")

grid = hexagons(layer, 200.; padding=0.2)
heatmap(layer, axis=(;aspect=DataAspect()), colormap=:cividis)
lines!(intersect(grid, pol), color=:white)
lines!(pol, color=:black)
current_figure()
