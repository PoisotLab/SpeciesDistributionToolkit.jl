# # Generating background points

# In this vignette, we will generate some background points (pseudo-absences) using the
# different algorithms present in the package.

using SpeciesDistributionToolkit
using CairoMakie

#

spatial_extent = (left = 3.032, bottom = 55.178, right = 19.687, top = 64.717)

# 

rangifer = taxon("Rangifer tarandus tarandus"; strict = false)
query = [
    "occurrenceStatus" => "PRESENT",
    "hasCoordinate" => true,
    "decimalLatitude" => (spatial_extent.bottom, spatial_extent.top),
    "decimalLongitude" => (spatial_extent.left, spatial_extent.right),
    "limit" => 300,
]
presences = occurrences(rangifer, query...)

# 

dataprovider = RasterData(CHELSA1, BioClim)
temperature = 0.1SimpleSDMPredictor(dataprovider; layer = "BIO1", spatial_extent...)

# 

presencelayer = mask(temperature, presences, Bool)

#

back1 = pseudoabsencemask(WithinRadius, presencelayer; distance = 120.0)

# but we might also not want to put points too *close* from occurrences:

back2 = pseudoabsencemask(WithinRadius, presencelayer; distance = 50.0)

# This is something we can do with layer arithmetic

background = convert(Int8, back1) - convert(Int8, back2)

# 

heatmap(
    sprinkle(temperature)...;
    colormap = :heat,
    axis = (; aspect = DataAspect()),
    figure = (; resolution = (800, 500)),
)
heatmap!(sprinkle(background)...; colormap = cgrad([:transparent, :white]; alpha = 0.5))
plot!(longitudes(presences), latitudes(presences); color = :black)
current_figure()
