using Revise
using CairoMakie
using SpeciesDistributionToolkit
const SDT = SpeciesDistributionToolkit

# Get data
pol = getpolygon(PolygonData(NaturalEarth, Countries))["Uruguay"]
bb = SDT.boundingbox(pol)

layer = SDMLayer(RasterData(CHELSA2, AverageTemperature); bb...)
mask!(layer, pol)
L = interpolate(layer, dest="EPSG:5382")

grid = hexagons(layer, 60.; padding=0.2)

heatmap(layer)
lines!.(grid)
current_figure()