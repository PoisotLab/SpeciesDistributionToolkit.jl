# # Layer arithmetic

# Layers can be manipulated as any other objects on which you can perform arithmetic. In
# other words, you can substract, add, multiply, and divide layers, either either with other
# layers or with numbers. In this vignette, we will take a look at how this can facilitate
# the creation of a resistance map for functional connectivity analysis.

using SpeciesDistributionToolkit
using CairoMakie

# We will work on the twelve classes of landcover provided by the *EarthEnv* data:

dataprovider = RasterData(EarthEnv, LandCover)

# In order to only read what is relevant to our illustration we will define a bounding
# box over Corsica.

spatial_extent = (left = 8.412, bottom = 41.325, right = 9.662, top = 43.060)

# As a good practice, we check the names of the layers again. Note that checking the name of
# the layers will *not* download the data, so this may be a good time to remove some layers
# you are not interested in (which of course would not be a good idea for this specific
# application).

landcover_classes = SimpleSDMDatasets.layers(dataprovider)

# To create a resistance map, we need to decide on a score for the resistance of each class
# of land use. For the sake of an hypothetical example, we will assume that the species we
# care about can easily traverse forested habitats, is less fond of shrubs, fields, etc.,
# and is a poor swimmer who is afraid of cities. Think of it as your typical forestry
# graduate student.

classes_resistance = [0.1, 0.1, 0.1, 0.2, 0.4, 0.5, 0.7, 0.9, 1.2, 0.8, 1.2, 0.95]
classes_resistance = classes_resistance ./ sum(classes_resistance)

# The next step is to download the layers -- we do so with a list comprehension, in order to
# get a vector of layers:

landuse = [
    SimpleSDMPredictor(dataprovider; layer = class, full = true, spatial_extent...) for
    class in landcover_classes
]

# The aggregation of the layers is simply ∑wᵢLᵢ, where wᵢ is the resistance of the *i*-th
# layer Lᵢ. In order to have the resistance layer expressed between 0 and 1, we finally call
# the `rescale!` method with new endpoints for the layer:

resistance_layer = sum([landuse[i] .* classes_resistance[i] for i in eachindex(landuse)])
rescale!(resistance_layer, (0.0, 1.0));

# The remaining step is to visualize this resistance map, and add a little colorbar to show
# which areas will be more difficult to cross:

resistance_map = heatmap(
    resistance_layer;
    colormap = Reverse(:linear_protanopic_deuteranopic_kbjyw_5_95_c25_n256),
    figure = (; resolution = (400, 350)),
    axis = (;
        aspect = DataAspect(),
        xlabel = "Latitude",
        ylabel = "Longitude",
        title = "Movement resistance",
    ),
)
Colorbar(resistance_map.figure[:, end + 1], resistance_map.plot; height = Relative(0.5))
current_figure()

# This layer can then be used in landscape connectivity analyses using *e.g.*
# Omniscape.jl.
