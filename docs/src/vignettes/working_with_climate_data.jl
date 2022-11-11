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

Makie.to_color(::Makie.MakieCore.Automatic) = 0.0f0

figtemp = Figure(; resolution = (1000, 1000))
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
