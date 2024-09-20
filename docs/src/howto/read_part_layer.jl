# # ... only read part of a layer?

using SpeciesDistributionToolkit
using CairoMakie
CairoMakie.activate!(; type = "png", px_per_unit = 3.0) #hide

# To illustrate the process, we will load the demo dataset:

t = SimpleSDMLayers.__demodata(; reduced = true)
f = tempname() * ".tiff"
SimpleSDMLayers.save(f, t)

# We can check the look of this layer as a reference:

heatmap(t; colormap = :magma)

# We now define a bounding box:

bbox = (left = -78.0, right = -75.0, bottom = 47.0, top = 49.0)

# ::: warning WGS84 is used for the bounding box
# 
# We are assuming that there is not information about the CRS of the layer we
# are working on until it is read, and for this reason the bounding box limits
# are given in lat/lon.
# 
# :::

# We can now pass all of these arguments to the `SDMLayer` function:

k = SDMLayer(f; bandnumber = 1, bbox...)

# Note that this layer is indeed cropped, but has retained its CRS:

heatmap(k; colormap = :magma)

# We can also plot this layer projected under WGS84, and overlay the
# boundingbox:

poly = [
    (bbox.left, bbox.bottom),
    (bbox.right, bbox.bottom),
    (bbox.right, bbox.top),
    (bbox.left, bbox.top),
    (bbox.left, bbox.bottom),
]
heatmap(
    interpolate(k; dest = "+proj=longlat +datum=WGS84 +no_defs +type=crs");
    colormap = :magma,
)
lines!(poly; color = :black, linewidth = 2, linestyle = :dash)
current_figure() #hide

# Note that the definition of the bounding box is that *all of the content in
# the bounding box* is included in the final layer, even if it results in some
# values *outside* the bounding box being included as well.