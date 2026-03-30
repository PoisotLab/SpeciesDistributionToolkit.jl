# # SDM with maximum entropy

using SpeciesDistributionToolkit
const SDT = SpeciesDistributionToolkit
using PrettyTables
using CairoMakie

# In this vignette, we will use the Maxent model [phillips2006maximum](@cite).
# Specifically, we rely on the maxnet version from
# [phillips2017opening](@citet).

# ## Observations and environmental data

# We will collect observations of the Northern Cardinal (_Cardinalis
# cardinalis_) for the country of Belize. They are available on GBIF as a
# DarwinCore archive, which we can [download and use
# directly](/manual/retrieval/gbif-download/). The usual Maxent example is the
# three-toed sloth or the Eucalyptus, but some variety is good for the soul.

records = GBIF.download("10.15468/dl.y8d8yb");

# We will first grab a series of polygons to highlight our study area.

borders = getpolygon(PolygonData(NaturalEarth, Countries))
aoi = borders["Belize"]
bb = SDT.boundingbox(records; padding=0.5)
landmass = clip(borders, bb)

# We finally get the BioClim variables from CHELSA2, and mask them using the
# area of interest:

provider = RasterData(CHELSA2, BioClim)
L = SDMLayer{Float32}[SDMLayer(provider; bb..., layer=i) for i in 1:19]
mask!(L, aoi)

# ## Pseudo-absences

presencelayer = mask(L[1], records)
background = pseudoabsencemask(BetweenRadius, presencelayer; closer = 10.0, further = 40.0)
absencelayer = backgroundpoints(background, 2sum(presencelayer))

# ## Training and validating the model

m = SDM(RawData, Maxent, L, presencelayer, absencelayer)

# add a type of feature

hyperparameters!(classifier(m), :product, true);

# standard folds
folds = kfold(m);

# variables

variables!(m, ForwardSelection, folds)

# 

cv = crossvalidate(m, folds);

# is it good?

mcc(cv.validation)

#-

mcc(cv.training)

# ## Logistic as a benchmark

n = SDM(RawData, Logistic, L, presencelayer, absencelayer)
variables!(n, ForwardSelection)

# logicstic cv

cvl = crossvalidate(n, folds);

# comparison of the two models

ms = [mcc, ppv, npv, f1]
M = permutedims([m(c) for m in ms, c in [cv.training, cv.validation, cvl.training, cvl.validation]]);
M = hcat(["Maxent", "", "Logistic", ""], ["Train.", "Val.", "Train.", "Val."], M);

# Show the table

pretty_table(
    M;
    alignment = [:l, :l, :c, :c, :c, :c],
    backend = :markdown,
    column_labels = [""; "Dataset"; string.(ms)],
    formatters = [fmt__printf("%5.3f", [3, 4, 5, 6])],
)

# Maxent is not as good as logistic regression for this model, but we will keep
# going with it regardless for the sale of illustration.

# ## Maxent results

#figure Maxent map
f = Figure()
ax = Axis(f[1,1]; aspect=DataAspect(), title="Maxent")
ax2 = Axis(f[1,2]; aspect=DataAspect(), title="Logistic")
for a in [ax, ax2]
    poly!(a, landmass, color=:grey95)
end
hm = heatmap!(ax, predict(m, L; threshold=false), colormap=Reverse(:navia), colorrange=(0, 1))
heatmap!(ax2, predict(n, L; threshold=false), colormap=Reverse(:navia), colorrange=(0, 1))
for a in [ax, ax2]
    lines!(a, landmass, color=:black)
    scatter!(a, records, color=:orange, markersize=2)
    tightlimits!(a)
    hidedecorations!(a)
end
Colorbar(f[1,3], hm)
current_figure() #hide

# We can look at the partial response to the variable that was included first in
# the model:

#figure first var
f = Figure()
ax = Axis(f[1,1]; aspect=DataAspect())
poly!(ax, landmass, color=:grey95)
hm = heatmap!(
    ax,
    partialresponse(m, L, first(variables(m)); threshold=false);
    colormap = Reverse(:batlowW),
    colorrange = (0, 1)
)
lines!(ax, landmass, color=:black)
tightlimits!(ax)
hidedecorations!(ax)
Colorbar(f[1,2], hm, label=layers(provider)[first(variables(m))])
current_figure() #hide

# We can also look at the effect of this variable's value on the average model
# prediction:

#figure Scatter plot SHAP
f = Figure()
ax = Axis(f[1,1], xlabel=layers(provider)[first(variables(m))], ylabel="Effect on average prediction")
scatter!(
    ax,
    features(m, first(variables(m))),
    explain(m, first(variables(m)); threshold=false),
    color = (:black, 0.5)
)
current_figure() #hide
