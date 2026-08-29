# # Statistics on layers

using SpeciesDistributionToolkit
using CairoMakie
using Statistics
import StatsBase

# In this vignette, we will have a look at the ways to transform layers and apply some
# functions from `Statistics`. As an illustration, we will produce a map of suitability for
# *Sitta whiteheadi* based on temperature and precipitation.

spatial_extent = (left = 8.412, bottom = 41.325, right = 9.662, top = 43.060)

species = taxon("Sitta whiteheadi"; strict = false)
query = [
    "occurrenceStatus" => "PRESENT",
    "hasCoordinate" => true,
    "decimalLatitude" => (spatial_extent.bottom, spatial_extent.top),
    "decimalLongitude" => (spatial_extent.left, spatial_extent.right),
    "limit" => 300,
]
presences = occurrences(species, query...)
while length(presences) < count(presences)
    occurrences!(presences)
end

# We will get our layers from CHELSA1. Because these layers are returned as `UInt16`, we
# multiply them by a float to get `Float64` layers.

dataprovider = RasterData(CHELSA1, BioClim)
temperature = 0.1SimpleSDMPredictor(dataprovider; layer = "BIO1", spatial_extent...)
precipitation = 1.0SimpleSDMPredictor(dataprovider; layer = "BIO12", spatial_extent...)

# A large number of functions from `Statistics` have overloads to be applied directly to the
# layers. We can get the mean temperature:

mean(temperature)

# Likewise, we can get the standard deviation:

std(temperature)

# Because of the way layers support arithmetic operations, we can esasily get the z-score of
# temperature as a layer:

z_temperature = (temperature - mean(temperature)) / std(temperature)

# This can be plotted. Note that we do not need to do anything on the layer
# itself, since the package comes pre-loaded with `Makie` recipes. This will be
# very useful when we start using `GeoMakie` axes to incorporate projections
# into our figures (which we will not do here...).

fig, ax, hm = heatmap(
    z_temperature;
    colormap = :broc,
    colorrange = (-2, 2),
    figure = (; resolution = (800, 400)),
    axis = (; aspect = DataAspect()),
)
Colorbar(fig[:, end + 1], hm)
current_figure()

# Another option to modify the layers is to use the `rescale` method. When given
# two values, it will rescale the layer to be between these two values. This is
# useful if you want to bring a series of arbitrary values to some interval. As
# before, note that we can directly pass the GBIF object to `scatter` to show it
# on a map:

fig, ax, hm = heatmap(
    rescale(precipitation, (0.0, 1.0));
    colormap = :bamako,
    figure = (; resolution = (800, 400)),
    axis = (; aspect = DataAspect()),
)
scatter!(ax, presences)
Colorbar(fig[:, end + 1], hm)
current_figure()

# When `rescale` is called with a series of values between 0 and 1, it will return the layer
# of quantiles (where the quantiles of interest are given by the series). For example, to
# get a little more insights about the distribution of precipitation, we can look at the
# quantiles:

fig, ax, hm = heatmap(
    rescale(precipitation, 0.0:0.05:1.0);
    colormap = :bamako,
    figure = (; resolution = (800, 400)),
    axis = (; aspect = DataAspect()),
)
Colorbar(fig[:, end + 1], hm)
current_figure()

# The `quantiles` function also has an overload, and so we can get the 5th and 95th
# percentiles of the distribution in the layer:

quantile(temperature, [0.05, 0.95])

# We can attempt to use this information to build a presence-only range map of
# the species of interest using a simplified BIOCLIM model. In order to do so,
# we need to identify the value of each predictor corresponding to various
# quantiles of the distribution:

temp_limits = quantile(temperature[presences], [0.05, 0.95])

# This can be used to mask the temperature layer -- we can do this very
# naturally using the broadcast notation, as it is fully supported on layers:

temperature_range = temp_limits[begin] .<= temperature .<= temp_limits[end]

# We can do the same for the precipitation:

prec_limits = quantile(precipitation[presences], [0.05, 0.95])
precipitation_range = prec_limits[begin] .<= precipitation .<= prec_limits[end]

# The combined range map is simply the places where both variables match with species
# occurrences, which we can get by multiplying the two boolean layers:

fig, ax, hm = heatmap(
    temperature_range * precipitation_range;
    colormap = :bamako,
    figure = (; resolution = (800, 400)),
    axis = (; aspect = DataAspect()),
)
current_figure()

# This is a *reasonable* approximation of the range of *Sitta whiteheadi* (given
# the simplicity of the approach).
