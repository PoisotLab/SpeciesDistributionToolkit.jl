# # Getting data from a STAC catalogue

# The purpose of this vignette is to demonstrate how we can use the `STAC`
# package to get data from STAC services.

# This functionality is supported through an extension, which is only active
# when the `STAC` package is loaded.

using SpeciesDistributionToolkit
using CairoMakie
using STAC # [!code highlight]
CairoMakie.activate!(; type = "png", px_per_unit = 2) #hide

# The support is currently very bare-bones, and can return a layer when given an
# asset. To demonstrate, we will get the time to the nearest city (in minutes)
# from the BON in a Box STAC catalogue:

biab = STAC.Catalog("https://stac.geobon.org/")
access = biab["accessibility_to_cities"].items["accessibility"].assets["data"]
L = SDMLayer(access; left=-76.0, right=-72.0, bottom=45.1, top=47.5)

# Note that the first argument is a STAC asset, but the usual keywords arguments
# to crop a layer apply here. The ability to crop is important, because the STAC
# layers can be very, very large. Information about the resolution and extent of
# the assets is provided by the STAC catalogue / API.

# Most public STAC instances are available through the
# [stacindex.org](stacindex.org) website.

# We can visualize the resulting layer:

# fig-ghmts
heatmap(L; colormap=:tempo)
current_figure() #hide
