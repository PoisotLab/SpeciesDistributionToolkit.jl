# # Future climate data

# For some data providers and datasets, `SimpleSDMLayers` offers access to future
# climate data. Future climates are usually specified by a model, and a
# scenario. For example, WorldClim 2.1 offers the full suite of BioClim variable
# under four SSPs and a number of CMIP6 models.

# We can use this to look at, for example, the temperature difference between the
# current and future climate. To illustrate this, we will do a simple example
# where we contrast the "historical" climate (*i.e.* what is assumed to be the
# current data) to the projected  data under SSP585 in the 2041-2060 period.

using SimpleSDMLayers
using Plots
using Statistics

# We will start by getting the contemporary data:

baseline = SimpleSDMPredictor(WorldClim, BioClim, 1; left=60.0, right=95.0, bottom=0.0, top=40.0)

plot(baseline, frame=:box, c=:heat)

# To get a future dataset, we need to specify the model:

instances(CMIP6)

# And we need to check the names of the SSP we want to use:

instances(SharedSocioeconomicPathway)

# We can now get our future temperature layer (and plot it):

future = SimpleSDMPredictor(WorldClim, BioClim, CanESM5, SSP585, 1; year="2041-2060", left=60.0, right=95.0, bottom=0.0, top=40.0)

plot(future, frame=:box, c=:heat)

# Note that the call to get the future data is almost the same as the historical
# one - the exception is the addition of the model and scenario, and the
# specification of the years.

# With this layer, we can now measure the difference in mean annual temperature:

plot(future - baseline, c=:lapaz, frame=:box)

# We might actually be interested in averaging multiple models. Because we know
# the variety of models worldclim has (`instances(CMIP6)`), we can do this
# fairly easily. One of the model has no predictions for SSP585 (which we would
# learn in the form of an error message), so we will filter it out directly.

ensemble = [
    SimpleSDMPredictor(
        WorldClim, BioClim, model, SSP585, 1;
        year="2041-2060", left=60.0, right=95.0, bottom=0.0, top=40.0
    ) for model in instances(CMIP6) if model != GFDLESM4
];

# We will measure the difference of each layer to the baseline:


differences = [component - baseline for component in ensemble]

plot(plot.(differences, c=:lapaz)..., frame=:box)

# From this, we can look at the average difference (across multiple models):

plot(mosaic(mean, differences), c=:lapaz, frame=:box)