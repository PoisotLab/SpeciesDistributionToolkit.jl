# # Zonal statistics

# In this tutorial, we will grab some bioclimatic variables for Bretagne, and
# then identify the departments that have extreme values of this variable.

using SpeciesDistributionToolkit
using Statistics
using CairoMakie
CairoMakie.activate!(; type = "png", px_per_unit = 2) #hide

# We can get polygon data from Open Street Map:

BZH = getpolygon(PolygonData(OpenStreetMap, Places), place="Bretagne")
departements = ["Ille-et-Vilaine", "Morbihan", "Côtes-d'Armor", "Finistère"]
DPTs = map(dpt->getpolygon(PolygonData(OpenStreetMap, Places), place = dpt), departements)

# We will get the BIO1 layer from CHELSA2 (average annual temperature):

spatial_extent = SpeciesDistributionToolkit.boundingbox(BZH; padding = 0.2)
dataprovider = RasterData(CHELSA2, BioClim)
layer = SDMLayer(dataprovider; layer = "BIO1", spatial_extent...)

# This layer is trimmed to the landmass (according to GADM):

mask!(layer, BZH)
layer = trim(layer)

#-

# fig-trimmed-layer
fig, ax, plt = heatmap(layer; axis = (; aspect = DataAspect()), colormap = :Greys)
hidespines!(ax)
hidedecorations!(ax)
lines!.(DPTs)
current_figure() #hide

# We can start looking at how the departments map onto the landscape, using the `zone`
# function. It will return a layer where the value of each pixel is the index of
# the polygon containing this pixel:

# fig-districts
heatmap(zone(layer, DPTs); colormap = :hokusai, axis = (; aspect = DataAspect()))
current_figure() #hide

# Note that the pixels that are not within a polygon are turned off, which can
# sometimes happen if the overlap between polygons is not perfect. There is a
# variant of the `mosaic` method that uses polygon to assign the values:

z = mosaic(mean, layer, DPTs)
nodata!(z, 0.0)

#-

# fig-zone-index
fig, ax, plt = heatmap(z; axis = (; aspect = DataAspect()))
hidespines!(ax)
hidedecorations!(ax)
current_figure() #hide

# Finally, we can get the mean value within each of these polygons using the
# `byzone` method:

depts_ranked = sort(
    byzone(mean, layer, DPTs, departements);
    by = (x) -> x.second,
    rev = true,
)

# The index of the department with the highets value is

i = findfirst(isequal(depts_ranked[1].first), departements)

#-

# fig-highlight-areas
fig, ax, plt =
    heatmap(layer; axis = (; aspect = DataAspect()), colormap = [:grey80, :grey20])
lines!(ax, DPTs[i]; label = departements[i], linewidth = 2, color=:red)
axislegend(; position = (0, 0.1), nbanks = 1, framevisible=false)
hidedecorations!(ax) #hide
hidespines!(ax) #hide
current_figure() #hide
