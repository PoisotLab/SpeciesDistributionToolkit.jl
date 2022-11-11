# Working with climate data

using SpeciesDistributionToolkit
using CairoMakie, GeoMakie

# Bounding box

spatial_extent = (left = -169.0, right = -50.0, bottom = 24.0, top = 71.0)

# Get some data

dataprovider = RasterData(WorldClim2, BioClim)

# Get some info about what we want

data_info = (resolution = 10.0, layer = "BIO1")

# Get the baseline

baseline = SimpleSDMPredictor(dataprovider; data_info..., spatial_extent...)

# We can do a little GeoMakie plot

# Makie.to_color(::Makie.MakieCore.Automatic) = 0.0f0

figtemp = Figure(; resolution = (1000, 800))
figpanel = GeoAxis(figtemp[1, 1]; dest = "+proj=moll")
heatmap!(
    figpanel,
    sprinkle(convert(Float32, baseline))...;
    shading = false,
    interpolate = false,
    colormap = :heat,
)
datalims!(figpanel)
current_figure()

# Get some future data

projection = Projection(SSP245, MIROC6)

# Predicted temperatures

future_temperature =
    SimpleSDMPredictor(dataprovider, projection; data_info..., spatial_extent...)

# Figure of differences

figdiff = Figure(; resolution = (1000, 1000))
diffpanel = GeoAxis(figdiff[1, 1]; dest = "+proj=moll")
hm = heatmap!(
    diffpanel,
    sprinkle(convert(Float32, future_temperature - baseline))...;
    shading = false,
    interpolate = false,
    colormap = :roma,
)
Colorbar(figdiff[:, end + 1], hm; height = Relative(0.7))
datalims!(figpanel)
current_figure()
