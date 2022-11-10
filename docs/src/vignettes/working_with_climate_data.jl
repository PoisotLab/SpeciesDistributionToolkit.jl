# Working with climate data

using SpeciesDistributionsToolkit
using CairoMakie
using GeoMakie

# Bounding box

spatial_extent = (left = -169.0, right = -50.0, bottom = 24.0, top = 71.0)

# Get some data

dataprovider = RasterData(WorldClim2, BioClim)

# Get some info about what we want

we_want = (resolution = 5.0, layer = "BIO1")

# Get the baseline

baseline = SimpleSDMPredictor(dataprovider; we_want..., spatial_extent...)

# We can do a little GeoMakie plot

function sprinkle(layer::T) where {T <: SimpleSDMLayer}
    return (
        longitudes(layer),
        latitudes(layer),
        transpose(replace(layer.grid, nothing => NaN)),
    )
end

Makie.to_color(::Makie.MakieCore.Automatic) = 0.0f0

# Make a plot

temperature_map = Figure(; resolution = (1000, 1000))
main_plot = GeoAxis(
    temperature_map[1, 1];
    coastlines = false,
    dest = "+proj=moll",
)
heatmap!(
    main_plot,
    sprinkle(convert(Float32, baseline))...;
    shading = false,
    interpolate = false,
    colormap = :heat,
)
datalims!(main_plot)
current_figure()
