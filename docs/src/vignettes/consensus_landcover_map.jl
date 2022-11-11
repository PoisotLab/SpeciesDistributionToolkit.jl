# Creating a landcover consensus map

using SpeciesDistributionToolkit
using CairoMakie
using GeoMakie

# bounding box for ireland

iceland = (left = -24.785, right = -12.634, top = 66.878, bottom = 62.935)

# landcover

dataprovider = RasterData(EarthEnv, LandCover)

# list of available layers

landcover_types = SimpleSDMDatasets.layers(dataprovider)

# get the stack

stack = [
    SimpleSDMPredictor(dataprovider; layer = layer, full = true, iceland...) for
    layer in landcover_types
]

# create an empty object for storage

consensus = similar(first(stack))

# we will set to `nothing` the positions in the consensus that are fully open water
open_water_idx = findfirst(isequal("Open Water"), landcover_types)

for k in keys(stack[open_water_idx])
    if isequal(100)(stack[open_water_idx][k])
        consensus[k] = nothing
    end
end

# fill the object

for coordinate in keys(consensus)
    consensus[coordinate...] = argmax([s[coordinate...] for s in stack])
end

# define a colormap for the classes

landcover_colors = [
    :forestgreen,
    :forestgreen,
    :forestgreen,
    :forestgreen,
    :darkseagreen3,
    :goldenrod1,
    :wheat2,
    :blue,
    :red,
    :aqua,
    :grey74,
    :transparent,
]

# We can now make the plot - because the area is relatively small, we will keep the `latlon`
# projection as the destination. Most of this code is really manually setting up a figure
# with a legend.

fig = Figure(; resolution = (1000, 800))
panel = GeoAxis(
    fig[1:4, 1];
    source = "+proj=longlat +datum=WGS84",
    dest = "+proj=longlat",
    lonlims = extrema(longitudes(consensus)),
    latlims = extrema(latitudes(consensus)),
    xlabel = "Longitude",
    ylabel = "Latitude",
)
heatmap!(
    panel,
    sprinkle(convert(Float32, consensus))...;
    shading = false,
    interpolate = false,
    colormap = landcover_colors,
)
Legend(
    fig[5, 1],
    [PolyElement(; color = landcover_colors[i]) for i in eachindex(landcover_colors)],
    landcover_types;
    orientation = :horizontal,
    nbanks = 4,
)
current_figure()
