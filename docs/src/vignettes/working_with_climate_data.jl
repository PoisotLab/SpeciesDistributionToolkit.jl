# Working with climate data

using SpeciesDistributionToolkit
using CairoMakie, GeoMakie

# Bounding box

spatial_extent = (left = -24.785, right = -12.634, top = 66.878, bottom = 62.935)

# We will get the BioClim data from CHELSA v1. These are pretty large data, and so this
# operation may take a while in terms of download/read time.

dataprovider = RasterData(CHELSA1, BioClim)

# Get some info about what we want

data_info = (layer = "BIO1",)

# Note that we do not *need* to give the bounding box and layer data as distinct variables,
# but this is more convenient in terms of code re-use. For this reason, we follow this
# convention throughout the documentation.

# Get the baseline

baseline = SimpleSDMPredictor(dataprovider; data_info..., spatial_extent...)

# Makie histogram

hist(filter(!isnan, vec(last(sprinkle(baseline)))))

# The values are scaled by 10m so we correct

figtemp = Figure(; resolution = (1000, 800))
figpanel = GeoAxis(
    figtemp[1, 1];
    dest = "+proj=latlon",
    lonlims = extrema(longitudes(baseline)),
    latlims = extrema(latitudes(baseline)),
)
heatmap!(
    figpanel,
    sprinkle(convert(Float32, 0.1baseline))...;
    shading = false,
    interpolate = false,
    colormap = :heat,
)
current_figure()

# Get some future data

projection = Projection(RCP26, MIROC_ESM)

# Predicted temperatures

future_temperature =
    SimpleSDMPredictor(dataprovider, projection; data_info..., spatial_extent...)

# Figure of differences

varpanel = GeoAxis(
    figtemp[2, 1];
    dest = "+proj=latlon",
    lonlims = extrema(longitudes(baseline)),
    latlims = extrema(latitudes(baseline)),
)
hm = heatmap!(
    varpanel,
    sprinkle(convert(Float32, 0.1(future_temperature - baseline)))...;
    shading = false,
    interpolate = false,
    colormap = :deep,
)
Colorbar(figtemp[2, end + 1], hm; height = Relative(0.7))
current_figure()
