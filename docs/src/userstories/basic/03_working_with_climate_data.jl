# # Working with climate data

# The purpose of this vignette is to measure the projected change in temperature in Iceland,
# under a specific climate change scenario. We will also map areas representing temperature
# values that are outside of the current range.

using SpeciesDistributionToolkit
using CairoMakie, GeoMakie
using Dates

# As with other vignettes, we will define a bounding box encompassing out region of
# interest:

spatial_extent = (left = -24.785, right = -12.634, top = 66.878, bottom = 62.935)

# In order to get the temperature data, we will query the `AverageTemperature` dataset from
# the CHELSA1 provider.

dataprovider = RasterData(CHELSA1, AverageTemperature)

# The first step is quite simply to grab the reference state for the temperature, by
# specifying the spatial extent. The average temperature dataset has a single layer, but has
# one slice for every month in the year. Here, we will focus on the temperature in April:

current_temperature = SimpleSDMPredictor(dataprovider; month = Month(4), spatial_extent...)

# Note that we represent "April" as `Dates.Month(4)`, in order to convey that this is
# actually a date.

# We can have a little look at this dataset by checking the density of the values for
# temperature (we can pass a layer to a Makie function directly):

density(
    current_temperature; color = (:grey, 0.5),
    figure = (; resolution = (800, 300)),
    axis = (; xlabel = "Current temperature for April"),
)

# They look very high, because CHELSA1 stores the temperature-related data multiplied by
# ten; moving forward, we will need to call `0.1layer` to get a layer scaled by the correct
# amount.

# The packages interact with *Makie* (including *GeoMakie*) to make it easy to
# produce good quality maps:

figure = Figure(; resolution = (800, 700))
panel_current = GeoAxis(
    figure[1, 1];
    dest = "+proj=natearth2",
    lonlims = extrema(longitudes(current_temperature)),
    latlims = extrema(latitudes(current_temperature)),
)
current_heatmap = surface!(
    panel_current,
    0.1 .* current_temperature;
    shading = false,
    interpolate = false,
    colormap = :oslo,
)
current_figure()

# In the next step, we will download the projected climate data under RCP26. This requires
# setting up a projection object, which is composed of a scenario and a model. This
# information is used by the package to verify that this combination exists within the
# dataset we are working with.

projection = Projection(RCP26, IPSL_CM5A_MR)

# Future data are available for different years, so we will take a look at what years are
# available:

SimpleSDMDatasets.timespans(dataprovider, projection)

# If we do not specify an argument, the data retrieved will be the ones for the closest
# timespan. Getting the projected isothermality is the *same* call as before, except we now pass an
# additional argument -- the projection.

projected_temperature =
    SimpleSDMPredictor(dataprovider, projection; month = Month(4), spatial_extent...)

# With this information, we can update the existing figure, to add a second panel with the
# difference in isothermality:

panel_future = GeoAxis(
    figure[2, 1];
    dest = "+proj=natearth2",
    lonlims = extrema(longitudes(current_temperature)),
    latlims = extrema(latitudes(current_temperature)),
)
future_heatmap = surface!(
    panel_future,
    0.1 * (projected_temperature - current_temperature);
    shading = false,
    interpolate = false,
    colormap = :roma,
)
Colorbar(figure[2, end + 1]; height = Relative(0.7), colorrange = (-2, 2), colormap = :roma)
current_figure()

# We can also very easily look at the relationship between current and future
# temperature (the `scatter` function would work just as well, but `hexbin` is good
# at aggregating cells with more datapoints):

hexbin(
    current_temperature,
    projected_temperature;
    figure = (; resolution = (800, 700)),
    axis = (;
        aspect = DataAspect(),
        xlabel = "Historical temperature",
        ylabel = "Projected temperature",
    ),
)
