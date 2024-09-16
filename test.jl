using Revise
using SpeciesDistributionToolkit
import Downloads
import GeoJSON
using CairoMakie

provider = RasterData(WorldClim2, Elevation)
layer = SDMLayer(provider; resolution=0.5, left=0.0, right=20.0, bottom=35.0, top=55.0)

heatmap(trim(layer); colormap = :navia, axis = (; aspect = DataAspect()))



mask!(layer, SpeciesDistributionToolkit.gadm("CHE")[1].geometry)
heatmap(trim(layer); colormap = :navia, axis = (; aspect = DataAspect()))
