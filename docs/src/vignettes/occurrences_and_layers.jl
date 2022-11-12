# # Occurrences and layers

# In this vignette, we will have a look at the ways in which occurrence data (from GBIF) and
# layer data can interact. In order to illustrate this, we will get information about the
# occurrences of *Mystacina tuberculata*, a species of bat endemic to Aotearoa New Zealand.

using SpeciesDistributionToolkit
using CairoMakie

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
observations = occurrences(bat, "country" => "NZ", "hasCoordinate" => true, "limit" => 300)

# We can now setup a figure with the correct axes, and use the `layer[occurrence]` indexing
# method to extrac the values from the layers at the location of each occurrence.

figure = Figure(; resolution = (800, 400))

envirovars =
    Axis(figure[1, 1]; xlabel = "Temperature (°C)", ylabel = "Precipitation (kg×m⁻²)")

plot!(envirovars, temperature[observations], precipitation[observations])

# In order to also show these on the map, we will add a simple heatmap to the left of the
# figure, and overlay the points using `longitudes` and `latitudes` for the observations:

map = Axis(figure[1, 2]; aspect = DataAspect())
hidedecorations!(map)
hidespines!(map)
heatmap!(map, sprinkle(temperature)...; colormap = :heat)
plot!(map, longitudes(observations), latitudes(observations))
