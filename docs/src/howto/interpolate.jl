# # ... interpolate to a new projection?

using SpeciesDistributionToolkit
using CairoMakie
CairoMakie.activate!(; type = "png", px_per_unit = 3.0) #hide

# The `interpolate` method can be used to project data into another coordinate
# system. For example, we can get data in ESPG:4326:

spatial_extent = (; left = -4.87, right=9.63, bottom=41.31, top=51.14)
dataprovider = RasterData(WorldClim2, BioClim)
layer = SDMLayer(dataprovider; layer="BIO1", resolution=2.5, spatial_extent...)

# And project them to the more locally appropriate EPSG:27574:

proj_string = 27574 |>
    SimpleSDMLayers.ArchGDAL.importEPSG  |>
    SimpleSDMLayers.ArchGDAL.toPROJ4 |>
    String
ws = interpolate(layer; dest=proj_string)

# By default, this produces a layer with the same dimension as the input, and
# uses bilinear interpolation:

fig, ax, hm = heatmap(
    ws;
    colormap = :navia,
    figure = (; size = (800, 400)),
    axis = (; aspect = DataAspect()),
)
Colorbar(fig[:, end + 1], hm)
current_figure() #hide

# ::: tip Overwrite a layer
# 
# There is an `interpolate!` method that will perform interpolation on an
# already existing layer. This is useful if you want to rapidly bring data from
# a layer to something compatible with another layer.
#
# :::