# # Layer arithmetic

using SpeciesDistributionToolkit
using CairoMakie

# intro - might want this information for input to Omniscape

dataprovider = RasterData(EarthEnv, LandCover)

# 

spatial_extent = (left = -80.00, bottom = 43.19, right = -70.94, top = 46.93)

#

landcover_classes = SimpleSDMDatasets.layers(dataprovider)

# scores

classes_resistance = [0.1, 0.1, 0.1, 0.2, 0.4, 0.5, 0.7, 0.9, 1.2, 0.8, 1.2, 0.95]

# get the layers

landuse = [
    SimpleSDMPredictor(dataprovider; layer = class, full = true, spatial_extent...) for
    class in landcover_classes
]

# aggregate

resistance_layer =
    reduce(+, 0.01landuse .* classes_resistance) * (1 / length(landcover_classes))

#

heatmap(
    sprinkle(resistance_layer)...;
    colormap = :Reds,
    figure = (; resolution = (800, 450)),
    axis = (;
        aspect = DataAspect(),
        xlabel = "Latitude",
        ylabel = "Longitude",
        title = "Movement resistance",
    ),
)
current_figure()
