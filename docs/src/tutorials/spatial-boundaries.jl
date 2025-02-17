# # Integration with SpatialBoundaries

# In this tutorial, we will use methods from `SpatialBoundaries` to estimate
# boundaries for (*i.e.* patches of) wooded areas on the Southwestern islands of
# the Hawaiian Islands using landcover data from the EarthEnv project. The
# `SpatialBoundaries` package works with `SpeciesDistributionToolkit` through an
# extension, so that you can get access to the integration when
# `SpatialBoundaries` is loaded in your project:

using SpeciesDistributionToolkit
using SpatialBoundaries # [!code highlight]
using CairoMakie
using StatsBase
CairoMakie.activate!(; type = "png", px_per_unit = 2) #hide

# Because there are four different layers in the EarthEnv database that
# represent different types of woody cover, we will use the overall mean wombling
# value.

# First we can start by defining the extent of the Southwestern islands of
# Hawaii, which can be used to restrict the extraction of the various landcover
# layers from the EarthEnv database.

hawaii = (left = -160.2, right = -154.5, bottom = 18.6, top = 22.5)
dataprovider = RasterData(EarthEnv, LandCover)
landcover_classes = layers(dataprovider)
landcover = [SDMLayer(dataprovider; layer=class, full=true, hawaii...) for class in landcover_classes]

# We can remove all the areas that contain 100% water from the landcover data as
# our question of interest is restricted to the terrestrial realm. We do this by
# using the "Open Water" layer to mask over each of the landcover layers
# individually:

ow_index = findfirst(isequal("Open Water"), landcover_classes)
not_water = landcover[ow_index] .!== 0x64
nodata!(not_water, false)
[mask!(layer, not_water) for layer in landcover]

# As layers one through four of the EarthEnv data are concerned with data on
# woody cover (*i.e.* "Evergreen/Deciduous Needleleaf Trees", "Evergreen
# Broadleaf Trees", "Deciduous Broadleaf Trees", and "Mixed/Other Trees") we
# will work with only these layers. For a quick idea we of what the raw
# landcover data looks like we can sum these four layers and plot the total
# woody cover:

classes_with_trees = findall(contains.(landcover_classes, "Trees"))
tree_lc = convert(SDMLayer{Float64}, reduce(+, landcover[classes_with_trees]))
heatmap(tree_lc; colormap=:linear_kbgyw_5_98_c62_n256)

# Although we have previously summed the four landcover layers for the actual
# wombling part we will apply the wombling function to each layer before we
# calculate the overall mean wombling value. We will do this using `broadcast`,
# this will apply `wombling` in an element-wise fashion to the four different
# woody cover layers. This will give as a vector containing four `LatticeWomble`
# objects (since the input data was in the form of a matrix).

wombled_layers = wombling.(landcover[classes_with_trees]);

# As we are interested in overall woody cover for Southwestern islands we can
# take the `wombled_layers` vector and use them with the `mean` function to get
# the overall mean wombling value of the rate and direction of change for woody
# cover. This will 'flatten' the four wombled layers into a single
# `LatticeWomble` object.

rate = mosaic(mean, (x -> x.rate).(wombled_layers))
direction = mosaic(a -> atan(mean(sin.(deg2rad.(a))), mean(cos.(deg2rad.(a)))), (x -> x.direction).(wombled_layers))

# Lastly we can identify candidate boundaries using the `boundaries`. Here we
# will use a thresholding value (t) of 0.1 and save these candidate boundary
# cells as `b`. Note that we are now working with a `SimpleSDMResponse` object
# and this is simply for ease of plotting.

(quantize(rate).>=0.1) |> heatmap

# We will overlay the identified boundaries (in green) over the rate of change
# (in levels of grey):

heatmap(rate, colormap=[:grey95, :grey5])
#heatmap!(b, colormap=[:transparent, :green])
current_figure()

# For this example we will plot the direction of change as radial plots to get
# an idea of the prominent direction of change. Here we will plot *all* the
# direction values from `direction` for which the rate of change is greater than
# zero (so as to avoid denoting directions for a slope that does not exist) as
# well as the `direction` values from only candidate cells using the same
# masking principle as what we did for the rate of change. It is of course also
# possible to forgo the radial plots and plot the direction of change in the
# same manner as the rate of change should one wish.

# Before we plot let us create our two 'masked layers'. For all direction values
# for which there is a corresponding rate of change greater than zero we can use
# `rate` as a masking layer but first replace all zero values with 'nothing'.
# For the candidate boundary cells we can simply mask `direction` with `b` as we
# did for the rate of change.

direction_all = mask(nodata(direction, 0), direction)

direction_candidate = mask(direction_all, direction)

# Because stephist() requires a vector of radians for plotting we must first
# collect the cells and convert them from degrees to radians. Then we can start
# by plotting the direction of change of *all* cells.

f = Figure()
ax = PolarAxis(f[1, 1])
h = fit(Histogram, values(direction); nbins = 100)
stairs!(ax, h.edges[1], h.weights[[axes(h.weights, 1)..., 1]]; color = :teal, linewidth = 2)
current_figure()

# Followed by plotting the direction of change only for cells that are
# considered as candidate boundary cells.

f = Figure()
ax = PolarAxis(f[1, 1])
h = fit(Histogram, values(direction_candidate); nbins = 100)
stairs!(ax, h.edges[1], h.weights[[axes(h.weights, 1)..., 1]]; color = :orange, linewidth = 2)
current_figure()
