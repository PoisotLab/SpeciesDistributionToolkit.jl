# Surfaces

using SpeciesDistributionToolkit
using CairoMakie

# Get data

spatial_extent = (left = -169.0, right = -50.0, bottom = 24.0, top = 71.0)

# ...

elevation = SimpleSDMPredictor(RasterData(WorldClim2, Elevation); spatial_extent...)
precipitation =
    SimpleSDMPredictor(RasterData(WorldClim2, BioClim); spatial_extent..., layer = "BIO12")

# plot

fig = Figure(; resolution = (1000, 1000))
axs = Axis2(fig[1, 1]; aspect = :data)
surface!(
    axs,
    sprinkle(elevation);
    color = last(sprinkle(precipitation)),
    colormap = :lapaz,
    shading = false,
)
current_figure()
