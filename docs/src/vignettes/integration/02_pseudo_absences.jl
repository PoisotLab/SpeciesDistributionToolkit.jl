# # Generating background points

# In this vignette, we will generate some background points (pseudo-absences) using the
# different algorithms present in the package.

using SpeciesDistributionToolkit
using CairoMakie

# In order to work on a region that is not too big, we will define our spatial extent:

spatial_extent = (left = 3.0, bottom = 55.2, right = 19.7, top = 64.9)

# Pseudo-absence generation requires occurrences super-imposed on a layer, so we will
# collect a few occurrences:

rangifer = taxon("Rangifer tarandus tarandus"; strict = false)
query = [
    "occurrenceStatus" => "PRESENT",
    "hasCoordinate" => true,
    "decimalLatitude" => (spatial_extent.bottom, spatial_extent.top),
    "decimalLongitude" => (spatial_extent.left, spatial_extent.right),
    "limit" => 300,
]
presences = occurrences(rangifer, query...)
for i in 1:3
    occurrences!(presences)
end

# We will get a single layer (temperature) from CHELSA1.

dataprovider = RasterData(CHELSA1, BioClim)
temperature = 0.1SimpleSDMPredictor(dataprovider; layer = "BIO1", spatial_extent...)

# Pseudo-absences generations always starts by masking a layer by the observations. The
# output of this command is a layer with Boolean values, where the cells in which at least
# one occurrence is reported are `true`.

presencelayer = mask(temperature, presences, Bool)

# We can for example generate a buffer for pseudo-absences in a radius of 120km around each
# point. Note that the `WithinRadius` method uses *kilometers* and not minutes of arc, so
# that the actual area is the same regardless of the latitude of the points. Note that the
# speed of the operation depends on the number of cells with an observation (linearly), and
# of the radius and raster resolution (to a power of 2). Internally, the code uses a variety
# of tricks to only look at cells that are susceptible to being pseudo-absences, but the
# `WithinRadius` method in particular can take a bit of time.

background = pseudoabsencemask(WithinRadius, presencelayer; distance = 120.0)

# The pseudo-absence generation functions will return a *mask*, *i.e.* a boolean layer where
# the cells in which we can place a pseudo-absence are `true`, and the rest of the cells are
# `false`. This is useful for a variety of reasons, including adding more and more
# constraints to the locations of pseudo-absences. For example, we can decide that we do not
# want background points too close to the actual observations, and put a buffer around each.

buffer = pseudoabsencemask(WithinRadius, presencelayer; distance = 25.0)

# We can now exclude the data that are in the buffer. There are a variety of ways to do
# this (for example using `mosaic` and `all`), but the fastest way is to use layer
# arithmetic (we can convert the layers to integer by mutliplying them by `0x01`, so that
# they are `UInt8`, and therefore do not take up much memory):

bgmask = convert(Bool, 0x01 * background - 0x01 * buffer)

# Finally, we can plot the area in which we can put pseudo-absences as a shaded region over
# the layer, and plot all known occurrences as well:

heatmap(
    sprinkle(temperature)...;
    colormap = :deep,
    axis = (; aspect = DataAspect()),
    figure = (; resolution = (800, 500)),
)
heatmap!(sprinkle(bgmask)...; colormap = cgrad([:transparent, :white]; alpha = 0.3))
plot!(longitudes(presences), latitudes(presences); color = :black)
current_figure()

# There are additional ways to produce pseudo-absences mask, notably the surface range
# envelope method, which uses the bounding box of observations to allow pseudo-absences:

sre = pseudoabsencemask(SurfaceRangeEnvelope, presencelayer)

heatmap(
    sprinkle(temperature)...;
    colormap = :deep,
    axis = (; aspect = DataAspect()),
    figure = (; resolution = (800, 500)),
)
heatmap!(sprinkle(sre)...; colormap = cgrad([:transparent, :white]; alpha = 0.3))
plot!(longitudes(presences), latitudes(presences); color = :black)
current_figure()

# The `RandomSelection` method (not shown) uses the entire surface of the layer as
# a possible pseudo-absence location.

# Note that we are not *yet* generating pseudo-absences, and in order to do so, we need to
# sample the mask generated by `pseudoabsencemask`. We can do so using `sample`, which uses
# the `StatsBase.sample` function internally.

bgpoints = SpeciesDistributionToolkit.sample(bgmask, floor(Int, 0.5sum(presencelayer)))

# But wait! The cells do not have the same size because the Earth is not flat.
# So we can generate a map of the cell size:

heatmap(
    sprinkle(cellsize(temperature))...;
    colormap = :lapaz,
    axis = (; aspect = DataAspect()),
    figure = (; resolution = (800, 500)),
)

# We can then sample the cells according to their surface as a weight:

bgpoints = SpeciesDistributionToolkit.sample(
    bgmask,
    elevation(bgmask),
    floor(Int, 0.5sum(presencelayer)),
)

# We can set the non-pseudo-absences to `nothing` (this helps with visualisation):

replace!(bgpoints, false => nothing)

# And finally, we can make a plot:

heatmap(
    sprinkle(temperature)...;
    colormap = :deep,
    axis = (; aspect = DataAspect()),
    figure = (; resolution = (800, 500)),
)
heatmap!(sprinkle(bgmask)...; colormap = cgrad([:transparent, :white]; alpha = 0.3))
plot!(longitudes(presences), latitudes(presences); color = :black)
scatter!(keys(bgpoints); color = :red)
current_figure()
