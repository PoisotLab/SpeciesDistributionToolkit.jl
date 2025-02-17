# # Clustering layers

# The purpose of this vignette is to demonstrate how we can use the `Clustering`
# package to apply k-means or fuzzy C-means on layers.

# This functionality is supported through an extension, which is only active
# when the `Clustering` package is loaded. For versions of Julia that do not
# support extensions, this is handled through the `Require` package.

using SpeciesDistributionToolkit
using CairoMakie
using Statistics
import StatsBase
using Clustering # [!code highlight]
CairoMakie.activate!(; type = "png", px_per_unit = 2) #hide

# We will get two layers to work with:

spatial_extent = (left = 8.412, bottom = 41.325, right = 9.662, top = 43.060)
dataprovider = RasterData(CHELSA1, BioClim)
temperature = SDMLayer(dataprovider; layer = "BIO1", spatial_extent...)
precipitation = SDMLayer(dataprovider; layer = "BIO12", spatial_extent...)

# We can get the 

# Likewise, we can get the standard deviation:

std(temperature)

# Because of the way layers support arithmetic operations, we can esasily get the
# z-score of temperature as a layer:

z_temperature = (temperature - mean(temperature)) / std(temperature)

# This can be plotted. Note that we do not need to do anything on the layer
# itself, since the package comes pre-loaded with `Makie` recipes. This will be
# very useful when we start using `GeoMakie` axes to incorporate projections into
# our figures (which we will not do here...).

# fig-zscore
fig, ax, hm = heatmap(
    z_temperature;
    colormap = :broc,
    colorrange = (-2, 2),
    figure = (; size = (800, 400)),
    axis = (; aspect = DataAspect()),
)
Colorbar(fig[:, end + 1], hm)
current_figure() #hide

# Another option to modify the layers is to use the `rescale` method. When given
# two values, it will rescale the layer to be between these two values. This is
# useful if you want to bring a series of arbitrary values to some interval. As
# before, note that we can directly pass the GBIF object to `scatter` to show it
# on a map:

# fig-rescale
fig, ax, hm = heatmap(
    rescale(precipitation, (0.0, 1.0));
    colormap = :bamako,
    figure = (; size = (800, 400)),
    axis = (; aspect = DataAspect()),
)
Colorbar(fig[:, end + 1], hm)
current_figure() #hide

# To get a little more insights about the distribution of precipitation, we can
# look at the quantiles, given by the `quantize` function:

# fig-quantize
fig, ax, hm = heatmap(
    quantize(precipitation, 5);
    colormap = :bamako,
    figure = (; size = (800, 400)),
    axis = (; aspect = DataAspect()),
)
Colorbar(fig[:, end + 1], hm)
current_figure() #hide

# The `quantile` function also has an overload, and so we can get the 5th and 95th
# percentiles of the distribution in the layer:

quantile(temperature, [0.05, 0.95])
