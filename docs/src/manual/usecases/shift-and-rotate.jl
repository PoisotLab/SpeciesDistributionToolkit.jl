# # Shift and rotate

# In this tutorial, we will apply the "Shift and Rotate" technique
# [ridder2024generating](@cite) to generate realistic maps of predictors to
# provide a null sample for the performance of an SDM. We will also look at the
# quantile mapping function, which ensures that the null sample has the exact
# same distribution of values compared to the original data.

using SpeciesDistributionToolkit
const SDT = SpeciesDistributionToolkit
using PrettyTables
using CairoMakie

# We will get some occurrences about the observations of _Cardinalis cardinalis_
# in Belize, which we used in the [Maxent](/manual/distributions/maxent/)
# vignette.

records = GBIF.download("10.15468/dl.y8d8yb");
extent = SDT.boundingbox(records; padding = 3.5)

# We will first grab a series of polygons to define our study area. We get a
# polygon for the country borders, and then a second polygon for the landmass,
# which we will use as the background of our maps.

aoi = getpolygon(PolygonData(NaturalEarth, Countries))["Belize"]
land = getpolygon(PolygonData(NaturalEarth, Land))
landmass = clip(land, extent)

# To train the model, we will collect all 19 BioClim variables from CHELSA2, and
# mask them _to the landmass_ we have selected before.

provider = RasterData(CHELSA2, BioClim)
L = SDMLayer{Float32}[SDMLayer(provider; extent..., layer = i) for i in 1:19]
mask!(L, landmass)

# Note that are not masking the layer to the _area of interest_ (Belize, the
# country for which we have data), because we will construct null layers from
# the value of predictors within the larger region. For this reason, it is very
# important that all the relevant pixels in the larger region have a value.

# ## Layer interpolation

# In order to facilitate the search for rotation parameters, it is a good idea
# to downscale the layer a little.

# We start by picking the first layer, and make a copy of it.

T = copy(first(L))

# We will interpolate it so that each cell is about 25 times as large as before

NS = ceil.(Int, size(T)./5)
P = interpolate(T, dest=T.crs, newsize=NS)

# At this point, we can collect the actual area that we want to replace with
# shifted and rotated values:

C = trim(mask(P, aoi))

# figure Full area
f = Figure()
ax = Axis(f[1,1]; aspect=DataAspect())
heatmap!(ax, P, colormap=:batlowW, alpha=0.5, colorrange=extrema(P))
lines!(ax, landmass, color=:grey50)
hm = heatmap!(ax, C, colormap=:batlowW, colorrange=extrema(P))
lines!(ax, aoi, color=:black)
Colorbar(f[1,2], hm, label="Average temperature")
current_figure() #hide

# ## Finding a rotation

# With the two layers, we will now attempt to identify a shift and a rotation.
# Conceputally, we are attempting to figure out how we can rotate the Earth
# underneath our layer of interest, both across the latitude and longitude axes,
# and also along the axis that goes through the center of the layer, while
# keeping all the cells in the layer having a value.

θ = findrotation(C, P)

# This output represents the rotation as a shift in latitude and longitude, and
# then a rotation around the axis. It is returned as a tuple, which can be
# passed to the `rotator` closure, which handles the actual rotation:

𝐑 = rotator(θ...)

# The next figure shows the original laer, as well as the coordinates of the
# points from which its replacement values will be drawn. Note that the 

# figure Full area with rotation
f = Figure()
ax = Axis(f[1,1]; aspect=DataAspect())
hm = heatmap!(ax, P, colormap=:batlowW, alpha=0.4)
lines!(ax, aoi, color=:black)
scatter!(ax, 𝐑(lonlat(C)), color=:red, markersize=4)
Colorbar(f[1,2], hm, label="Average temperature")
current_figure() #hide

# We can, for example, shift and rotate the first layer:

Y = shiftandrotate(C, P, 𝐑)

# We can apply this transformation to the original (full resolution) data

X = trim.(mask(copy.(L), aoi))
M = [shiftandrotate(X[i], L[i], θ) for i in eachindex(X)]

#figure Rotated target landscape
f = Figure()
ax = Axis(f[1,1]; aspect=DataAspect())
heatmap!(ax, P, colormap=:batlowW, alpha=0.5)
lines!(ax, landmass, color=:grey50)
hm = heatmap!(ax, M[1], colormap=:batlowW, colorrange=extrema(P))
lines!(ax, aoi, color=:black)
Colorbar(f[1,2], hm, label="Average temperature")
current_figure() #hide

# compare the distributions

#figure Density of the two layers
f = Figure()
ax = Axis(f[1,1])
density!(ax, M[1], label="Shift and rotate")
density!(ax, X[1], label="True values", color=:transparent, strokecolor=:black, linestyle=:dash, strokewidth=1)
axislegend(ax, position=:lt)
ylims!(ax, low=0)
current_figure() #hide

# Now, also ensure that although the spatial structure of this layer has
# changed, it should have the same distribution of values as the original layer.
# This can be done with the quantile transfer function:

X2 = [quantiletransfer(M[i], X[i]) for i in eachindex(X)]

#figure Density of the two layers after transfer
f = Figure()
ax = Axis(f[1,1])
density!(ax, M[1], label="Shift and rotate")
density!(ax, X[1], label="True values", color=:transparent, strokecolor=:black, linestyle=:dash, strokewidth=1)
density!(ax, X2[1], label="After transfer", color=:transparent, strokecolor=:red, strokewidth=2)
axislegend(ax, position=:lt)
ylims!(ax, low=0)
current_figure() #hide

# now we plot side by side

#figure Side by side
f = Figure()
a1 = Axis(f[1,1]; aspect=DataAspect(), title="True values")
a2 = Axis(f[1,2]; aspect=DataAspect(), title="Shift, rotate, transfer")
hm = heatmap!(a1, X[1], colormap=:batlowW, colorrange=extrema(X[1]))
heatmap!(a2, X2[1], colormap=:batlowW, colorrange=extrema(X[1]))
Colorbar(f[1,3], hm, label="Average temperature")
current_figure() #hide

# ## Train both models

presencelayer = mask(X[1], records)
background = pseudoabsencemask(BetweenRadius, presencelayer; closer = 10.0, further = 40.0)
absencelayer = backgroundpoints(background, 2sum(presencelayer))

# true model

model = SDM(RawData, NaiveBayes, X, presencelayer, absencelayer)
variables!(model, ForwardSelection)

# null model

null = SDM(RawData, NaiveBayes, M, presencelayer, absencelayer)
variables!(null, ForwardSelection)

# corrected null model

cnull = SDM(RawData, NaiveBayes, X2, presencelayer, absencelayer)
variables!(cnull, ForwardSelection)

# ::: info Variable selection and model performance
#
# Note on what is important to test here -- same variables, or best suite of
# variables -- will give different results, this test is more stringent because
# performance of each model can be increased as much as possible
# 
# :::

# cv

folds = kfold(model)
cvm = crossvalidate(model, folds);
cvn = crossvalidate(null, folds);
cvc = crossvalidate(cnull, folds);

# stats

ms = [mcc, ppv, npv, f1]
CVM = permutedims([
    m(c) for m in ms, c in [cvm.training, cvm.validation, cvn.training, cvn.validation, cvc.training, cvc.validation]
]);
CVM = hcat(["Real data", "", "Shift & rotate", "", "Quant. transf.", ""], ["Train.", "Val.", "Train.", "Val.", "Train.", "Val."], CVM);

# These are the results:

pretty_table(
    CVM;
    alignment = [:l, :l, :c, :c, :c, :c],
    backend = :markdown,
    column_labels = [""; "Dataset"; string.(ms)],
    formatters = [fmt__printf("%5.3f", [3, 4, 5, 6])],
)

# Compare the outputs

#figure model-comp
f = Figure()
axs = [
    Axis(f[1,1]; aspect=DataAspect(), title="Original data"),
    Axis(f[1,2]; aspect=DataAspect(), title="Shift/rotate"),
    Axis(f[1,3]; aspect=DataAspect(), title="Quantile transfer"),
]
for i in 1:3
    poly!(axs[i], clip(landmass, SDT.boundingbox(X[1]; padding=0.5)), color=:grey90)
end
hm = heatmap!(axs[1], predict(model, X; threshold=false), colorrange=(0, 1), colormap=Reverse(:batlowW))
heatmap!(axs[2], predict(null, M; threshold=false), colorrange=(0, 1), colormap=Reverse(:batlowW))
heatmap!(axs[3], predict(cnull, X2; threshold=false), colorrange=(0, 1), colormap=Reverse(:batlowW))
for i in 1:3
    lines!(axs[i], clip(landmass, SDT.boundingbox(X[1]; padding=0.5)), color=:black)
    hidedecorations!(axs[i])
end
Colorbar(f[2,1:3], hm, label="Prediction", tellheight=false, tellwidth=false, vertical=false)
rowsize!(f.layout, 2, Relative(0.1))
current_figure() #hide

# ## Related documentation

# ```@meta
# CollapsedDocStrings = true
# ```

# ```@docs; canonical=false
# shiftandrotate
# findrotation
# quantiletransfer
# quantiletransfer!
# ```

# ## References

# ```@bibliography
# Pages = [@__FILE__]
# Style = :authoryear
# ```