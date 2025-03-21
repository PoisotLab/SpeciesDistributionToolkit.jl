# # Statistics on layers

using SpeciesDistributionToolkit
using CairoMakie
using Statistics

# ...

spatial_extent = (left = 3.032, bottom = 55.178, right = 19.687, top = 64.717)

# 

rangifer = taxon("Rangifer tarandus tarandus"; strict = false)
query = [
    "occurrenceStatus" => "PRESENT",
    "hasCoordinate" => true,
    "country" => "NO",
    "country" => "SE",
    "country" => "FI",
    "country" => "DE",
]
presences = occurrences(rangifer, query...)

# layers

dataprovider = RasterData(CHELSA1, BioClim)
temperature = 0.1SimpleSDMPredictor(dataprovider; layer = "BIO1", spatial_extent...)
precipitation = 1.0SimpleSDMPredictor(dataprovider; layer = "BIO12", spatial_extent...)

#

mean(temperature)

# 

std(temperature)

# 

z_temperature = (temperature - mean(temperature)) / std(temperature)

# 

fig, ax, hm = heatmap(
    sprinkle(z_temperature)...;
    colormap = :roma,
    colorrange = (-2, 2),
    figure = (; resolution = (800, 400)),
    axis = (; aspect = DataAspect()),
)
Colorbar(fig[:, end + 1], hm)
current_figure()

# 

fig, ax, hm = heatmap(
    sprinkle(rescale(precipitation, (0.0, 1.0)))...;
    colormap = :bamako,
    figure = (; resolution = (800, 400)),
    axis = (; aspect = DataAspect()),
)
Colorbar(fig[:, end + 1], hm)
current_figure()

# 

fig, ax, hm = heatmap(
    sprinkle(rescale(precipitation, collect(0.0:0.05:1.0)))...;
    colormap = :bamako,
    figure = (; resolution = (800, 400)),
    axis = (; aspect = DataAspect()),
)
Colorbar(fig[:, end + 1], hm)
current_figure()

#

quantile(temperature, [0.05, 0.95])
