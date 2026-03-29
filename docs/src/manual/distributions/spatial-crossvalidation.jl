# # Spatial cross-validation

# The purpose of this vignette is to show how, with tiles that are generated
# through the [tessellation functions](/manual/polygons/tessellation/), we can
# split a dataset into multiple spatial groups, and use this to cross-validate
# the model.

# ::: danger Unstable part of the API
#
# The functions on this page should be considered a work in progress, and their
# behavior is likely to change in ways that will be documented here. These
# should be treated as highly experimental.
#
# :::

using SpeciesDistributionToolkit
const SDT = SpeciesDistributionToolkit
using PrettyTables
using CairoMakie

# ## Assembling a dataset

# We will work on the state of California:

pol = getpolygon(PolygonData(OpenStreetMap, Places); place = "California")
bb = SDT.boundingbox(pol)

# To ensure the correct representation of distances, we will generate an orthoprojection:

proj = "+proj=ortho +lon_0=$((bb.right + bb.left)/2) +lat_0=$((bb.top + bb.bottom)/2)"

# And we will finally get the list of Sasquatch sightings from the
# `OccurrencesInterface` package:

records = Occurrences(mask(OccurrencesInterface.__demodata(), pol))

# We will also grab some landcover variables over this area to train the model on:

L = SDMLayer{Float32}[
    SDMLayer(RasterData(EarthEnv, LandCover); bb..., layer = i) for i in 1:12
]
mask!(L, pol)

# ## Creating the tiles

# At this point, we can follow the steps from the vignette on
# [tessellation](/manual/polygons/tessellation/), and generate an hexagonal
# tiling under the projection we specified, with an equivalent radius of 30km.

T = tessellate(pol, 30.0; tile = :hexagons, pointy = true, proj = proj, densify = 5)

#figure Hexagonal tiling over the polygon
f = Figure()
ax = Axis(f[1, 1]; aspect = DataAspect())
lines!(ax, pol, color=:grey30)
lines!(ax, T; color = :teal)
hidespines!(ax)
hidedecorations!(ax)
current_figure() #hide

# We need to decide on a number of folds, _i.e._ how many splits of the data we
# want to get. We will use five here.

n = 5

# To facilitate the visualisation, we will generate a color palette:

folds_colors = cgrad(Makie.wong_colors()[1:n], n; categorical = true);

# ## Assigning the tiles to folds

# We can start by splitting the landscape in horizontal bands:

SDT.assignfolds!(
    T;
    n = n,
    order = :horizontal, # [!code highlight]
)

#figure Tiling colored by the folds assigned horizontally
f = Figure()
ax = Axis(f[1, 1]; aspect = DataAspect())
for i in 1:n
    poly!(
        ax,
        T["__fold" => i];
        alpha = 0.2,
        color = i,
        colorrange = (1, n),
        colormap = folds_colors,
    )
    lines!(
        ax,
        T["__fold" => i];
        color = i,
        colorrange = (1, n),
        colormap = folds_colors,
    )
end
hidespines!(ax)
hidedecorations!(ax)
current_figure() #hide

# Wherever possible, every split has the same number of cells, and so assuming
# that the tiling was generated using an equal-area projection, they will cover
# an equivalent surface.

# We can also split the landscape vertically:

SDT.assignfolds!(
    T;
    n = n,
    order = :vertical, # [!code highlight]
)

#figure Tiling colored by the folds assigned vertically
f = Figure()
ax = Axis(f[1, 1]; aspect = DataAspect())
for i in 1:n
    poly!(
        ax,
        T["__fold" => i];
        alpha = 0.2,
        color = i,
        colorrange = (1, n),
        colormap = folds_colors,
    )
    lines!(
        ax,
        T["__fold" => i];
        color = i,
        colorrange = (1, n),
        colormap = folds_colors,
    )
end
hidespines!(ax)
hidedecorations!(ax)
current_figure() #hide

# ## Grouped and alternating splits

# By defaults splits are contiguous in space. This behavior can be changed, by
# making them sequential (_i.e._ cycling over 1 to `n`, and then re-starting),
# in order to more evenly distribute the points in space:

SDT.assignfolds!(
    T;
    n = n,
    group = false, # [!code highlight]
    order = :horizontal,
)

#figure Tiling colored by the folds assigned vertically, alternating
f = Figure()
ax = Axis(f[1, 1]; aspect = DataAspect())
for i in 1:n
    poly!(
        ax,
        T["__fold" => i];
        alpha = 0.2,
        color = i,
        colorrange = (1, n),
        colormap = folds_colors,
    )
    lines!(
        ax,
        T["__fold" => i];
        color = i,
        colorrange = (1, n),
        colormap = folds_colors,
    )
end
hidespines!(ax)
hidedecorations!(ax)
current_figure() #hide

# ## Using spatial splits for cross-validation

# We will generate a layer of pseudo-absences, then extract the two layers as a
# series of occurrences, as per [a previous
# vignette](/manual/generation/occurrences-from-layer/).

L₊ = mask(L[1], records)
P₋ = pseudoabsencemask(BetweenRadius, L₊; closer = 50.0, further = 140.0)
L₋ = backgroundpoints(P₋, 2sum(L₊))
O = Occurrences(L₊, L₋)

# We will only keep the part of the tiling that covers at least one presence or
# absence point:

SDT.assignfolds!(T; n = n, order = :horizontal)
S = SDT.keeprelevant(T, O)

# ::: info Generation of tiles
#
# It is also possible to generate the tiles directly from the model. We are
# using the `keeprelevant` approach here in order to highlight the position of
# species data within the entire region.
#
# :::

#figure Tile filtered by occurrences
f = Figure()
ax = Axis(f[1, 1]; aspect = DataAspect())
lines!(ax, T; color = :grey70)
for i in 1:n
    poly!(
        ax,
        S["__fold" => i];
        alpha = 0.2,
        color = i,
        colorrange = (1, n),
        colormap = folds_colors,
    )
    lines!(
        ax,
        S["__fold" => i];
        color = i,
        colorrange = (1, n),
        colormap = folds_colors,
    )
end
scatter!(ax, presences(O); color = :black)
scatter!(ax, absences(O); color = :grey40, marker = :cross, markersize = 8)
hidedecorations!(ax)
hidespines!(ax)
current_figure() #hide

# Before moving on, we will assemble the actual model we will use here:

model = SDM(RawData, NaiveBayes, L, O)

# We generate

folds = spatialfold(model, S); 

# ::: tip Spatial fold function
#
# The `spatialfold` function can also be called with a single argument (a
# `FeatureCollection` of tiles), in which case it will return a closure that can
# be called directly on a model like any other function to generate dataset
# splits.
#
# :::

# Because the `spatialfold` function returns a correct division of samples
# between training and validation, we can use it as the second argument to
# `crossvalidate`:

cv = crossvalidate(model, folds)

# ::: info Cross-validation
#
# There is an entire vignette on
# [cross-validation](/manual/sdm/crossvalidation/), which covers the important
# ways to interact with the cross-validation outputs, as well as non-spatial
# methods to split data.
#
# :::

measures = [mcc, SDeMo.specificity, SDeMo.sensitivity, balancedaccuracy]
cvresult = [measure(set) for measure in measures, set in cv]
nullresult = [measure(null(model)) for measure in measures, null in [coinflip, noskill]]
pretty_table(
    hcat(string.(measures), hcat(cvresult, nullresult));
    alignment = [:l, :c, :c, :c, :c],
    backend = :markdown,
    column_labels = ["Measure", "Validation", "Training", "Coin-flip", "No-skill"],
    formatters = [fmt__printf("%5.3f", [2, 3, 4, 5])],
)

# This is not a very good model. There are a few reasons for this. First, we
# have not done any variable selection. Second, the splits are likely to have
# very different class balance, which can bias the model performance.

pr_by_fold = [sum(uniqueproperties(S["__fold" => i])["__presences"]) for i in 1:n]
ab_by_fold = [sum(uniqueproperties(S["__fold" => i])["__absences"]) for i in 1:n]
extrema(pr_by_fold ./ (pr_by_fold .+ ab_by_fold))

# The splits we have used cover a large range of balances, which means that the
# model will be both trained and evaluated on very different balances when
# compared to the actual dataset.


# ## Creating folds with balance

# We can instead assign the observations to spatially stratified folds that are
# optimized to have the same (approx.) class balance as the entire dataset.

SDT.assignfolds!(
    S;
    n = n,
    order = :horizontal, # [!code highlight]
    balanced = true, # [!code highlight]
)

# The class balancing approach works by starting from an initial position (here,
# horizontally stratified bands), and then switching tiles between folds until
# the distance between the balance of each fold and the balance of the dataset
# is minimized. Internally this is done using a greedy but fast algorithm.

# ::: warning The spatial structure is lost
#
# The currently implemented version of the class balance algorithm will not
# attempt to maintain the spatial structure of the blocks, nor will it ensure
# that the folds end up with similar numbers of instances. The number of tiles
# that constitutes each fold will be maintained.
#
# :::

# After performing the optimisation of splits for class balance, we obtained a
# new division of the landscape:

#figure Tiles filtered by occurrences
f = Figure()
ax = Axis(f[1, 1]; aspect = DataAspect())
lines!(ax, T; color = :grey70)
for i in 1:n
    poly!(
        ax,
        S["__fold" => i];
        alpha = 0.2,
        color = i,
        colorrange = (1, n),
        colormap = folds_colors,
    )
    lines!(
        ax,
        S["__fold" => i];
        color = i,
        colorrange = (1, n),
        colormap = folds_colors,
    )
end
scatter!(ax, presences(O); color = :black)
scatter!(ax, absences(O); color = :grey40, marker = :cross, markersize = 8)
hidedecorations!(ax)
hidespines!(ax)
current_figure() #hide

# Based on this new split, we can select the variables:

folds = SDT.spatialfold(model, S)
variables!(model, ForwardSelection, folds)
layers(RasterData(EarthEnv, LandCover))[variables(model)]

# As before, this model can be cross-validated:

cv = crossvalidate(model, folds);

# We can measure the expected performance:

measures = [mcc, SDeMo.specificity, SDeMo.sensitivity, balancedaccuracy]
cvresult = [measure(set) for measure in measures, set in cv]
nullresult = [measure(null(model)) for measure in measures, null in [coinflip, noskill]]
pretty_table(
    hcat(string.(measures), hcat(cvresult, nullresult));
    alignment = [:l, :c, :c, :c, :c],
    backend = :markdown,
    column_labels = ["Measure", "Validation", "Training", "Coin-flip", "No-skill"],
    formatters = [fmt__printf("%5.3f", [2, 3, 4, 5])],
)

# ```@meta
# CollapsedDocStrings = true
# ```

# ## Related documentation
# 
# ```@docs; canonical=false
# SpeciesDistributionToolkit.assignfolds!
# SpeciesDistributionToolkit.spatialfold
# ```
