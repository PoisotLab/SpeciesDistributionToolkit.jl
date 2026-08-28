# # Retrieving data from a STAC catalogue

# The purpose of this vignette is to demonstrate how we can use the `STAC`
# package to get data from STAC services.

# This functionality is supported through an extension, which is only active
# when the `STAC` package is loaded.

using SpeciesDistributionToolkit
using CairoMakie
using STAC # [!code highlight]

# The support is currently very bare-bones, and can return a layer when given
# an asset. To demonstrate, we will get data from the
# [OpenLandMap](https://stac.openlandmap.org/) STAC catalogue. The OLM catalog
# contains quite a lot of information, and for this analysis we will grab a
# layer about human pressure:

countries = getpolygon(PolygonData(NaturalEarth, Countries); resolution=10)
aoi = add(
  countries["Ireland"],
  countries["United Kingdom"]
)

olm = STAC.Catalog("https://s3.eu-central-1.wasabisys.com/stac/openlandmap/catalog.json")
wild_collection = olm["wilderness_li2022.human.footprint"]
wild_item = wild_collection.items["wilderness_li2022.human.footprint_20180101_20181231"]
wild_assets = wild_item.assets["wilderness_li2022.human.footprint_p_1km_s"]
L = SDMLayer(wild_assets; SpeciesDistributionToolkit.boundingbox(aoi, padding=1.0)...)

# Note that the first argument is a STAC asset, but the usual keywords arguments
# to crop a layer apply here. The ability to crop is important, because the STAC
# layers can be very, very large. Information about the resolution and extent of
# the assets is provided by the STAC catalogue / API.

# Most public STAC instances are available through the
# [stacindex.org](stacindex.org) website.

# We can visualize the resulting layer:

#figure ghmts
f = Figure()
ax = Axis(f[1, 1], aspect=DataAspect())
heatmap!(ax, L; colormap=:tempo)
lines!(ax, aoi, color=:black)
current_figure() #hide
