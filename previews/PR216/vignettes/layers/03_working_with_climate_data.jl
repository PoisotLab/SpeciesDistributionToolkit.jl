# # Working with climate data

# The purpose of this vignette is to show how isothermality will change in Corsica under
# a specific climate change scenario, and to map the results.

using SpeciesDistributionToolkit
using CairoMakie

# As with other vignettes, we will define a bounding box encompassing out region of
# interest:

spatial_extent = (left = 8.412, bottom = 41.325, right = 9.662, top = 43.060)

# We will get the BioClim data from CHELSA v1. CHELSA v1 offers access to the 19 original
# bioclim variable, and their projection under a variety of CMIP5 models/scenarios.
# These are pretty large data, and so this operation may take a while in terms of download/read
# time. The first time you run this command will download the data, and the next calls will
# read them from disk.

dataprovider = RasterData(CHELSA1, BioClim)

# In the BioClim parlance, isothermality is `"BIO3"`, so this is the layer we will request.
# We wrap this inside a tuple to make the subsequent function calls faster to write.

data_info = (layer = "BIO1",)

# We could also check the layer descriptions directly:

layerdescriptions(dataprovider)["BIO1"]

# Note that we do not *need* to give the bounding box and layer data as distinct variables,
# but this is more convenient in terms of code re-use. For this reason, we follow this
# convention throughout the documentation.

# The first step is quite simply to grab the reference state for the isothermality, by
# specifying the layer and the spatial extent:

temperature_current = SimpleSDMPredictor(dataprovider; data_info..., spatial_extent...)

# We can have a little look at this dataset by checking the density of the values for
# temperature (we can pass a layer to a Makie function directly):

density(
    temperature_current; color = (:grey, 0.5),
    figure = (; resolution = (800, 300)),
    axis = (; xlabel = "Raw temperature data"),
)

# They look very high, because CHELSA1 stores the temperature-related data multiplied by
# ten; moving forward, we will need to call `0.1layer` to get a layer scaled by the correct
# amount.

# The packages interact with *Makie* (including *GeoMakie*) to make it easy to
# produce good quality maps:

figure = Figure(; resolution = (800, 700))
panel_current = Axis(
    figure[1, 1];
)
temp_current_hm = heatmap!(
    panel_current,
    0.1temperature_current;
    colormap = :dense,
)
current_figure()

# In the next step, we will download the projected climate data under RCP26. This requires
# setting up a projection object, which is composed of a scenario and a model. This
# information is used by the package to verify that this combination exists within the
# dataset we are working with.

projection = Projection(RCP85, IPSL_CM5A_MR)

# Future data are available for different years, so we will take a look at what years are
# available:

SimpleSDMDatasets.timespans(dataprovider, projection)

# If we do not specify an argument, the data retrieved will be the ones for the closest
# timespan. Getting the projected temperature is the *same* call as before, except we now pass an
# additional argument -- the projection.

temperature_proj =
    SimpleSDMPredictor(dataprovider, projection; data_info..., spatial_extent...)

# With this information, we can update the existing figure, to add a second panel with the
# difference in temperature:

panel_future = Axis(
    figure[2, 1];
)
tmp_future_hm = heatmap!(
    panel_future,
    0.1(temperature_proj .- temperature_current);
    colormap = :dense,
)
Colorbar(figure[2, end + 1]; height = Relative(0.7), colorrange = (1, 3), colormap = :dense)
current_figure()

# We can also very easily look at the relationship between current and future
# climate (the `scatter` function would work just as well, but `hexbin` is good
# at aggregating cells with more datapoints):

hexbin(
    0.1temperature_current,
    0.1temperature_proj;
    figure = (; resolution = (800, 700)),
    axis = (;
        aspect = DataAspect(),
        xlabel = "Historical temperature",
        ylabel = "Projected temperature",
    ),
)