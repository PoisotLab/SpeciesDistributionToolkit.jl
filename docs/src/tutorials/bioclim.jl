# # The BIOCLIM model

using SpeciesDistributionToolkit
using CairoMakie
CairoMakie.activate!(; type = "png", px_per_unit = 3.0) #hide

spatial_extent = (left = 8.412, bottom = 41.325, right = 9.662, top = 43.060)

# Pseudo-absence generation requires occurrences super-imposed on a layer, so we
# will collect a few occurrences:

species = taxon("Sitta whiteheadi"; strict = false)
query = [
    "occurrenceStatus" => "PRESENT",
    "hasCoordinate" => true,
    "decimalLatitude" => (spatial_extent.bottom, spatial_extent.top),
    "decimalLongitude" => (spatial_extent.left, spatial_extent.right),
    "limit" => 300,
]
presences = occurrences(species, query...)
for i in 1:5
    occurrences!(presences)
end

# We will get a single layer (temperature) from CHELSA1.

dataprovider = RasterData(CHELSA1, BioClim)

# Layers

temp = SDMLayer(dataprovider; layer=1, spatial_extent...)
prec = SDMLayer(dataprovider; layer=12, spatial_extent...)

# quantize

Qt = quantize(temp, presences)
Qp = quantize(prec, presences)

# check

fig, ax, hm = heatmap(
    Qp;
    colormap = :navia,
    figure = (; size = (800, 400)),
    axis = (; aspect = DataAspect()),
)
Colorbar(fig[:, end + 1], hm)
current_figure() #hide

# turn into score

BIOCLIM(score::Float64) = 2*(0.5-abs(score-0.5))
BIOCLIM(layer::SDMLayer) = BIOCLIM.(layer)
BIOCLIM(layers::Vector{<:SDMLayer}) = mosaic(minimum, BIOCLIM.(layers))

# produce layer

bc = BIOCLIM([Qt, Qp])

# output

fig, ax, hm = heatmap(
    bc;
    colormap = :navia,
    figure = (; size = (800, 400)),
    axis = (; aspect = DataAspect()),
)
scatter!(presences, color=:black, markersize=2)
Colorbar(fig[:, end + 1], hm)
current_figure() #hide

# rangemap

heatmap(bc .> .05)
