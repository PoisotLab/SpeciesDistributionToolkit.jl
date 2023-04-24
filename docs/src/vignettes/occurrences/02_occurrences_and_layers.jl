# # Occurrences and layers

# In this vignette, we will have a look at the ways in which occurrence data (from GBIF) and
# layer data can interact. In order to illustrate this, we will get information about the
# occurrences of *Mystacina tuberculata*, a species of bat endemic to Aotearoa New Zealand.
# Finally, we will rely on the `Phylopic` package to download a silhouette of a bat to
# illustrate the figure.

using SpeciesDistributionToolkit
using CairoMakie
import Images
import Downloads

# This sets up a bounding box for the region of interest:

spatial_extent =
    (left = 163.828125, bottom = -48.672068, right = 181.230469, top = -33.410924)

# We will get our bioclimatic variable from CHELSA:

dataprovider = RasterData(CHELSA1, BioClim)

# The next step is to download the layers, making sure to correct the scale of the
# temperature (BIO1), which is multiplied by 10 in the CHELSA raw data:

temperature = 0.1SimpleSDMPredictor(dataprovider; layer = "BIO1", spatial_extent...)
precipitation = SimpleSDMPredictor(dataprovider; layer = "BIO12", spatial_extent...)

# Once we have the layer, we can grab the occurrence data from GBIF. There is a very small
# number of occurrences, so we only need to do a single call to collect them all:

bat = taxon("Mystacina tuberculata")
observations = occurrences(
    bat,
    "country" => "NZ",
    "hasCoordinate" => true,
    "limit" => 300,
    "occurrenceStatus" => "PRESENT",
)

# We can now setup a figure with the correct axes, and use the `layer[occurrence]` indexing
# method to extract the values from the layers at the location of each occurrence.

figure = Figure(; resolution = (800, 400))

envirovars =
    Axis(figure[1, 1]; xlabel = "Temperature (°C)", ylabel = "Precipitation (kg×m⁻²)")

plot!(envirovars, temperature[observations], precipitation[observations])

current_figure()

# In order to also show these on the map, we will add a simple heatmap to the left of the
# figure, and overlay the points using `longitudes` and `latitudes` for the observations:

map = Axis(figure[1, 2]; aspect = DataAspect())
hidedecorations!(map)
hidespines!(map)
heatmap!(map, temperature; colormap = :heat)
scatter!(observations; color = :black)
current_figure()

# We can now add a silhouette of a bat using Phylopic. We only want a single item here, and
# the search will by default be restricted to images that can be used with the least
# constraints.

bat_uuid = Phylopic.names("chiroptera"; items = 1)

# The next step is to get the url of the image -- we are going to get the largest thumbnail
# (which is the default):

bat_thumbnail_url = Phylopic.thumbnail(bat_uuid)
bat_thumbnail_tmp = Downloads.download(bat_thumbnail_url)
bat_image = Images.load(bat_thumbnail_tmp)

# We can now use this image in a scatter plot -- this uses the thumbnail as a scatter
# symbol, so we need to plot this like any other point. Because the thumbnail returned by
# default is rather large, we can rescale it based on the image size:

bat_size = Vec2f(reverse(size(bat_image) ./ 3))

# Finally, we can plot everything (note that the Phylopic images have a transparent
# background, so we are not hiding any information!):

scatter!(envirovars, [14.0], [2400.0]; marker = bat_image, markersize = bat_size)
current_figure()
