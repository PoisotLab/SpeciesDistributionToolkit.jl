# # Statistics on layers

using SpeciesDistributionToolkit
using CairoMakie
using Statistics

# ...

spatial_extent = (left = 3.0, bottom = 54.0, right = 33.0, top = 73.0)

# 

rangifer = taxon("Rangifer tarandus tarandus"; strict = false)
query = [
    "occurrenceStatus" => "PRESENT",
    "hasCoordinate" => true,
    "country" => "NO",
    "country" => "SE",
    "country" => "FI",
    "country" => "DE",
    "limit" => 300,
]
presences = occurrences(rangifer, query...)
while length(presences) <= 3000
    occurrences!(presences)
end

# layers

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

# This can be plotted:

fig, ax, hm = heatmap(
    sprinkle(z_temperature)...;
    colormap = :roma,
    colorrange = (-2, 2),
    figure = (; resolution = (800, 400)),
    axis = (; aspect = DataAspect()),
)
Colorbar(fig[:, end + 1], hm)
current_figure()

# Another option to modify the layers is to use the `rescale` method. When given two values,
# it will rescale the layer to be between these two values. This is useful if you want to
# bring a series of arbitrary values to some interval:

fig, ax, hm = heatmap(
    sprinkle(rescale(precipitation, (0.0, 1.0)))...;
    colormap = :bamako,
    figure = (; resolution = (800, 400)),
    axis = (; aspect = DataAspect()),
)
scatter!(ax, longitudes(presences), latitudes(presences))
Colorbar(fig[:, end + 1], hm)
current_figure()

# When `rescale` is called with a series of values between 0 and 1, it will return the layer
# of quantiles (where the quantiles of interest are given by the series). For example, to
# get a little more insights about the distribution of precipitation, we can look at the
# quantiles:

fig, ax, hm = heatmap(
    sprinkle(rescale(precipitation, collect(0.0:0.05:1.0)))...;
    colormap = :bamako,
    figure = (; resolution = (800, 400)),
    axis = (; aspect = DataAspect()),
)
Colorbar(fig[:, end + 1], hm)
current_figure()

# The `quantiles` function also has an overload, and so we can get the 5th and 95th
# percentiles of the distribution in the layer:

quantile(temperature, [0.05, 0.95])

# We can attempt to use this information to build a presence-only range map of the species
# of interest using the BIOCLIM model. In order to do so, we need to identify the value of
# each predictor corresponding to the top abd bottom 5% of the ranges of values where the
# species is:

temp_limits = quantiles(temperature[presences], [0.05, 0.95])

# This can be used to mask the temperature layer:

temperature_range = broadcast(v -> temp_limits[1] <= v <= temp_limits[2], temperature)

# We can do the same for the precipitation:

prec_limits = quantiles(precipitation[presences], [0.05, 0.95])
precipitation_range = broadcast(v -> prec_limits[1] <= v <= prec_limits[2], precipitation)

# The combined range map is simply the places where both variables match with species
# occurrences:

fig, ax, hm = heatmap(
    sprinkle(temperature_range * precipitation_range)...;
    colormap = :bamako,
    figure = (; resolution = (800, 400)),
    axis = (; aspect = DataAspect()),
)
current_figure()
