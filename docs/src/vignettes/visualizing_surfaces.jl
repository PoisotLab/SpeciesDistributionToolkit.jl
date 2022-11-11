# Surfaces

using SpeciesDistributionToolkit
using CairoMakie
using Dates

# In this example, we will look at a 3D visualisation of a layer (representing elevation),
# and apply color from another layer (average temperature in June) to see how the `sprinkle`
# function allows the package to interact with the *Makie* plotting ecosystem.

spatial_extent = (left = -169.0, right = -110.0, bottom = 50.0, top = 71.0)

# The first step is to download the elevation layer, specifically from `WorldClim2`:

elevation = SimpleSDMPredictor(RasterData(WorldClim2, Elevation); spatial_extent...)

# Next, we will download a layer of climatic data to overlay on top of the elevation
# surface -- note that we request the month by using the `Dates.Month` constructor. This is
# an important design point of the packages: as much as possible, we refer to temporal
# information using types meant to represent temporal data.

temperature_june =
    SimpleSDMPredictor(
        RasterData(WorldClim2, AverageTemperature);
        spatial_extent...,
        month = Month(6),
    )

# The final step is to plot everything, splatting the output of `sprinkle` (longitudes,
# latitudes, and a grid of values with missing values returned as `NaN`). For the color
# grid, we use the `last` element returned by `sprinkle`, and set a colorbar to the right of
# the figure:

fig = Figure(; resolution = (1000, 1000))
axs = Axis3(fig[1, 1]; aspect = (1, 1, 0.1), xlabel = "Longitude")
srf = surface!(
    axs,
    sprinkle(elevation)...;
    color = last(sprinkle(temperature_june)),
    colormap = :heat,
    shading = false,
    interpolate = true,
)
Colorbar(fig[:, end + 1], srf; height = Relative(0.5))
current_figure()
