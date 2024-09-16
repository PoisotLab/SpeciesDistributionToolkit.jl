using Revise
using SpeciesDistributionToolkit
import Downloads
import GeoJSON
using CairoMakie
using PolygonOps

url_gadm = "https://geodata.ucdavis.edu/gadm/gadm4.1/json/gadm41_CHE_0.json"
poly = GeoJSON.read(Downloads.download(url_gadm, tempname()))

provider = RasterData(WorldClim2, Elevation)
layer = SDMLayer(provider; resolution=0.5, left=0.0, right=20.0, bottom=35.0, top=55.0)

heatmap(trim(layer); colormap = :navia, axis = (; aspect = DataAspect()))

mask!(layer, poly[1].geometry)
heatmap(trim(layer); colormap = :navia, axis = (; aspect = DataAspect()))
