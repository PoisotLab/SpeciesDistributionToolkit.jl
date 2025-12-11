# # Shift and rotate

# In this tutorial, we will apply the [Shift and
# Rotate](https://onlinelibrary.wiley.com/doi/abs/10.1111/2041-210X.14443)
# technique to generate realistic maps of predictors to provide a null sample
# for the performance of an SDM. We will also look at the quantile mapping
# function, which ensures that the null sample has the exact same distribution
# of values compared to the original data.

using SpeciesDistributionToolkit
const SDT = SpeciesDistributionToolkit
using CairoMakie
CairoMakie.activate!(; type = "png", px_per_unit = 2) #hide
import Random #hide
Random.seed!(123451234123121); #hide

# We will get some occurrences from the butterfly *Aglais caschmirensis* in Pakistan:

pol = getpolygon(PolygonData(ESRI, Places))["Country" => "Tanzania"]
records = GBIF.download("10.15468/dl.7ddsb7");
extent = SDT.boundingbox(pol)

# And then get some bioclimatic variables:

provider = RasterData(WorldClim2, BioClim)
L = SDMLayer{Float32}[
    SDMLayer(
        provider;
        layer = x,
        resolution = 5.,
        extent...,
    ) for x in 1:19
];
mask!(L, pol)

# As for the previous tutorials, we will generate some background points:

presencelayer = mask(first(L), records)
background = pseudoabsencemask(DistanceToEvent, presencelayer)
bgpoints = backgroundpoints(nodata(background, d -> d < 20), 2sum(presencelayer))

# And finally train a model:

sdm = SDM(RawData, Logistic, L, presencelayer, bgpoints)
variables!(sdm, ForwardSelection)

# Now, we can make the prediction based on this model

# fig-shift-heatmap
fig = Figure(; size = (900, 700))
panel = Axis(
    fig[1, 1];
    xlabel = "Easting",
    ylabel = "Northing",
    aspect = DataAspect(),
)
hidedecorations!(panel)
hidespines!(panel)
heatmap!(
    panel,
    predict(sdm, L),
    colormap=[:white, :purple]
)
lines!(panel, pol, color=:black)
current_figure() #hide

# This represents the prediction on the original data. Now, we will identify a
# rotation under which we can generate a different landscape. Before we do this,
# we need a pool of layers to get the potential values from, so we will use a
# version with a padding:

poolextent = SDT.boundingbox(pol; padding=10.0)
P = SDMLayer{Float32}[
    SDMLayer(
        provider;
        layer = x,
        resolution = 5.,
        poolextent...,
    ) for x in 1:19
];

# We now find a rotation:

θ = findrotation(first(L), first(P))

# The rotation is a shift in latitude and longitude, and then a rotation around
# the axis.

# It can be turned into a function to generate the rotation:

rotator(θ...)

# We can, for example, shift and rotate the first layer:

Y = shiftandrotate(first(L), first(P), rotator(θ...))

# We can visualize the output of this transformation:

# fig-shift-transform
f = Figure()
ax = Axis(f[1, 1]; aspect=DataAspect())

heatmap!(ax, P, colormap=:greys)
scatter!(ax, lonlat(L), markersize=1, color=:black)
scatter!(ax, trf(lonlat(L)), markersize=1, color=:red)
xlims!(ax, extrema(first.(vcat(lonlat(L), trf(lonlat(L))))) .+ (-1, 1))
ylims!(ax, extrema(last.(vcat(lonlat(L), trf(lonlat(L))))) .+ (-1, 1))
current_figure() #hide

# Now, also ensure that although the spatial structure of this layer has
# changed, it should have the same distribution of values as the original layer.
# This can be done with the quantile transfer function:

quantiletransfer!(Y, L)

# We can check the extrema of both layers:

extrema(Y)

# and the original layer

extrema(L)

# All things together, we can now create a series of shifted and rotated layers
# with the original distribution of values:

Z = [
    quantiletransfer!(
        shiftandrotate(L[i], P[i], rotator(θ...)), 
        L[i])
    for i in eachindex(L)
]

# We can apply the previously trained SDM on the new layers

# fig-shift-heatmap2
fig = Figure(; size = (900, 700))
panel = Axis(
    fig[1, 1];
    xlabel = "Easting",
    ylabel = "Northing",
    aspect = DataAspect(),
)
hidedecorations!(panel)
hidespines!(panel)
heatmap!(
    panel,
    predict(sdm, Z),
    colormap=[:white, :purple]
)
lines!(panel, pol, color=:black)
current_figure() #hide

# We can, of course, also decide to train a different model based on these data, etc.