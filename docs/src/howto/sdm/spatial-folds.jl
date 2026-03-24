# # Spatial cross-validation

# It is possible to generate tessellations (homogenous tilings of a surface)
# from several type of objects.

# through the [tessellation functions](/howto/polygons/tessellation/)

using SpeciesDistributionToolkit
const SDT = SpeciesDistributionToolkit
using PrettyTables
using CairoMakie

# We will start by getting the different type of data that can be used to
# generate a tessellation, starting with polygons:

pol = getpolygon(PolygonData(OpenStreetMap, Places); place = "California")
bb = SDT.boundingbox(pol)

# Get an orthoprojection

proj = "+proj=ortho +lon_0=$((bb.right + bb.left)/2) +lat_0=$((bb.top + bb.bottom)/2)"

# We will also grab some occurrences:

records = Occurrences(mask(OccurrencesInterface.__demodata(), pol))

# And we will also get a layer:

L = SDMLayer{Float32}[
    SDMLayer(RasterData(CHELSA2, BioClim); bb..., layer = i) for i in [1, 12]
]
mask!(L, pol)

# ## Creating the tiles

# get tiles

T = tessellate(pol, 30.0; tile = :hexagons, pointy = true, proj = proj, densify = 5)

#figure Hexagonal tiling over the polygon
f = Figure()
ax = Axis(f[1, 1]; aspect = DataAspect())
lines!(ax, pol)
lines!(ax, T; color = :orange)
current_figure() #hide

# ## assign by latitude

n = 4
folds_colors = cgrad(Makie.wong_colors()[1:n], n; categorical = true);

# this is the code

SDT.assignfolds!(
    T;
    n = n,
    order = :horizontal, # [!code highlight]
)

#figure Tiling colored by the folds assigned horizontal
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
current_figure() #hide

# this is the code

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
current_figure() #hide

# ## Grouped and alternating splits

# By defaults splits are assigned in a way that alternates sequentially, in
# order to distribute the splits more evenly across space

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
current_figure() #hide

# ## Generating a model

L₊ = mask(L[1], records)
P₋ = pseudoabsencemask(BetweenRadius, L₊; closer = 40.0, further = 120.0)
L₋ = backgroundpoints(P₋, 2sum(L₊))

# Now we get this as a series of occurrences

O = Occurrences(L₊, L₋)

# We will only keep the part of the tiling that covers at least one point


SDT.assignfolds!(T; n = n, order = :horizontal)
S = SDT.keeprelevant(T, O)

#figure Tile filtered by occurrences
f = Figure()
ax = Axis(f[1, 1]; aspect = DataAspect())
lines!(ax, T, color=:grey70)
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
scatter!(ax, absences(O); color = :grey40, marker = :cross, markersize=8)
current_figure() #hide

# This can be assigned to folds by creating a function first

spatialfolder = SDT.spatialfold(S)

# we need a model at this point

model = SDM(RawData, NaiveBayes, L, O)

# now we can cross-validate

folds = spatialfolder(model)

# cross-validation

cv = crossvalidate(model, folds)

#

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

# ## Creating folds with balance

SDT.assignfolds!(
    S;
    n = n,
    order = :balanced, # [!code highlight]
)

# ::: info Class-balance optimisation
# 
# algo info go here, will shuffle but all folds will keep same number of tiles
#
# :::

# new folding

folds = SDT.spatialfold(model, S)
cv = crossvalidate(model, folds)

#

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

# fold for balanced

#figure Tile filtered by occurrences
f = Figure()
ax = Axis(f[1, 1]; aspect = DataAspect())
lines!(ax, T, color=:grey70)
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
scatter!(ax, absences(O); color = :grey40, marker = :cross, markersize=8)
current_figure() #hide

# ```@meta
# CollapsedDocStrings = true
# ```

# ## Related documentation
# 
# ```@docs; canonical=false
# SpeciesDistributionToolkit.assignfolds!
# SpeciesDistributionToolkit.spatialfold
# ```
