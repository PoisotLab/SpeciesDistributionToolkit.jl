# # Future climate data

using SimpleSDMLayers
using Plots
using Statistics

# **Justification for this use case:** we will often want to forecast the range
# of species under a variety of climate change scenarios. For this reason,
# `SimpleSDMLayers` offers access to CMIP5 and CMIP6 scenarios or models, to be
# used in these situations.

# For some data providers and datasets, `SimpleSDMLayers` offers access to future
# climate data. Future climates are usually specified by a model, and a
# scenario. For example, WorldClim 2.1 offers the full suite of BioClim variable
# under four SSPs and a number of CMIP6 models.

# We can use this to look at, for example, the temperature difference between the
# current and future climate. To illustrate this, we will do a simple example
# where we contrast the "historical" climate (*i.e.* what is assumed to be the
# current data) to the projected  data under SSP585 in the 2041-2060 period.

# We will start by getting the contemporary data:

boundaries = (left=-169.0, right=-50.0, bottom=24.0, top=71.0)
baseline = SimpleSDMPredictor(WorldClim, BioClim, 1; boundaries...)
contour(baseline; c=:cork, frame=:box, fill=true, clim=(-30, 30), levels=6)

# To get a future dataset, we need to specify the model - models are
# combinations of a CMIP version, and either a RCP or SSP:

instances(CMIP6)

# And we need to check the names of the SSP we want to use:

instances(SharedSocioeconomicPathway)

# We can now get our future temperature layer (and plot it), for a valid
# model/scenario combination, and plot it. We will pick an extreme scenario at a
# long (yet frighteningly short) time in the future. In order to facilitate the
# comparison with the previous plot, we will re-use the same color limites,
# where blue is negatuve temperatures.

future = SimpleSDMPredictor(WorldClim, BioClim, CanESM5, SSP585, 1; year="2061-2080", boundaries...)
contour(future; c=:cork, frame=:box, fill=true, clim=(-30, 30), levels=6)

# Note that the call to get the future data is almost the same as the historical
# one - the exception is the addition of the model and scenario, and the
# specification of the years. With this layer, we can now measure the difference
# in mean annual temperature, because layers can be substracted. Note that we
# are switching the scale: the difference between the two layers here is always
# positive.

plot(future - baseline, frame=:box, c=:lajolla)

# We might actually be interested in averaging multiple models. Because we know
# the variety of models worldclim has (`instances(CMIP6)`), we can do this
# fairly easily. One of the model has no predictions for SSP585 (which we would
# learn in the form of an error message), so we will filter it out directly.

ensemble = [
    SimpleSDMPredictor(
        WorldClim, BioClim, model, SSP585, 1;
        year="2061-2080", boundaries...
    ) for model in instances(CMIP6) if model != GFDLESM4
];

# We can create a layer of differences from each scenario to the baseline:

differences = [component - baseline for component in ensemble];

# This can be plotted as a grid of differences, using the same colorscale as in
# the previous plot:

plot(plot.(differences, c=:lajolla, grid=:none, axes=false, frame=:none, leg=false)...)

# Finally, we can plot the average of the expected conditions under the scenario we considered:

contour(mosaic(mean, ensemble); c=:cork, frame=:box, fill=true, clim=(-30, 30), levels=6)