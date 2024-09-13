# Layers and occurrence data

In this vignette, we will have a look at the ways in which occurrence data
(from GBIF) and layer data can interact. In order to illustrate this, we will
get information about the occurrences of *Sitta whiteheadi*, a species of bird
endemic to Corsica. Finally, we will rely on the `Phylopic` package to
download a silhouette of a bat to illustrate the figure.

```@example 1
using SpeciesDistributionToolkit
using CairoMakie
import Images
import Downloads
```

This sets up a bounding box for the region of interest:

```@example 1
spatial_extent = (left = 8.412, bottom = 41.325, right = 9.662, top = 43.060)
```

We will get our bioclimatic variable from CHELSA:

```@example 1
dataprovider = RasterData(CHELSA1, BioClim)
```

The next step is to download the layers, making sure to correct the scale of the
temperature (BIO1), which is multiplied by 10 in the CHELSA raw data:

```@example 1
temperature = 0.1SDMLayer(dataprovider; layer = "BIO1", spatial_extent...)
precipitation = SDMLayer(dataprovider; layer = "BIO12", spatial_extent...)
```

Once we have the layer, we can grab the occurrence data from GBIF:

```@example 1
species = taxon("Sitta whiteheadi")
observations = occurrences(
    species,
    "decimalLatitude" => (spatial_extent.bottom, spatial_extent.top),
    "decimalLongitude" => (spatial_extent.left, spatial_extent.right),
    "limit" => 300,
    "occurrenceStatus" => "PRESENT",
)
while length(observations) < count(observations)
    occurrences!(observations)
end
```

We can now setup a figure with the correct axes, and use the `layer[occurrence]`
indexing method to extract the values from the layers at the location of each
occurrence.

```@example 1
figure = Figure(; resolution = (800, 400))

envirovars =
    Axis(figure[1, 1]; xlabel = "Temperature (°C)", ylabel = "Precipitation (kg×m⁻²)")

scatter!(envirovars, temperature[observations], precipitation[observations], markersize=6, color=:black)
save("occlayers-scatter.png", current_figure()); nothing # hide
```

![Consensus map](occlayers-scatter.png)

In order to also show these on the map, we will add a simple heatmap to the left of the
figure, and overlay the points using `longitudes` and `latitudes` for the observations:

```@example 1
spmap = Axis(figure[1, 2]; aspect = DataAspect())
hidedecorations!(spmap)
hidespines!(spmap)
heatmap!(spmap, temperature; colormap = :heat)
scatter!(spmap, observations; color = :black, markersize=6)
current_figure()
save("occlayers-heatmap.png", current_figure()); nothing # hide
```

![Consensus map](occlayers-heatmap.png)

We can now add a silhouette of the species using Phylopic. We only want a single item here, and
the search will by default be restricted to images that can be used with the least
constraints. Note that we are searching using the `GBIFTaxon` object representing our
species.

```@example 1
sp_uuid = Phylopic.imagesof(species; items = 1)
```

The next step is to get the url of the image -- we are going to get the largest thumbnail
(which is the default):

```@example 1
sp_thumbnail_url = Phylopic.thumbnail(sp_uuid)
sp_thumbnail_tmp = Downloads.download(sp_thumbnail_url)
sp_image = Images.load(sp_thumbnail_tmp)
```

We can also check how to credit the person who created this image. This will create
a markdown string, with the node name, the contributor name, and a link to the license.

```@example 1
Phylopic.attribution(sp_uuid)
```

We can now use this image in a scatter plot -- this uses the thumbnail as a scatter
symbol, so we need to plot this like any other point. Because the thumbnail returned by
default is rather large, we can rescale it based on the image size:

```@example 1
sp_size = Vec2f(reverse(size(sp_image) ./ 3))
```

Finally, we can plot everything (note that the Phylopic images have a transparent
background, so we are not hiding any information!):

```@example 1
scatter!(envirovars, [3.0], [700.0]; marker = sp_image, markersize = sp_size)
current_figure()
save("occlayers-final.png", current_figure()); nothing # hide
```

![Consensus map](occlayers-final.png)