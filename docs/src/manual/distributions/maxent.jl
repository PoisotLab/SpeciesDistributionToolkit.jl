# # SDM with maximum entropy

using SpeciesDistributionToolkit
const SDT = SpeciesDistributionToolkit
using PrettyTables
using CairoMakie

# In this vignette, we will use the Maxent model [phillips2006maximum](@cite) to
# predict the distribution of a bird species. Specifically, we rely on the more
# modern maxnet version [phillips2017opening](@cite).

# ## Observations and environmental data

# We will collect observations of the Northern Cardinal (_Cardinalis
# cardinalis_) for the country of Belize. They are available on GBIF as a
# DarwinCore archive, which we can [download and use
# directly](/manual/retrieval/gbif-download/). The usual Maxent example is the
# three-toed sloth or the Eucalyptus, but some variety is good for the soul.

records = GBIF.download("10.15468/dl.y8d8yb");
bb = SDT.boundingbox(records; padding=0.5)

# We will first grab a series of polygons to define our study area.

borders = getpolygon(PolygonData(NaturalEarth, Countries))
aoi = borders["Belize"]
landmass = clip(borders, bb)

# We finally get the BioClim variables from CHELSA2, and mask them using the
# area of interest:

provider = RasterData(CHELSA2, BioClim)
L = SDMLayer{Float32}[SDMLayer(provider; bb..., layer=i) for i in 1:19]
mask!(L, aoi)

# ## Pseudo-absences

# We start by spatially thinning the observations by mapping them to the predictor layer:

presencelayer = mask(L[1], records)

# We will now define the area in which we can sample background points, by
# allowing any pixel that is at least 10km from an observation, but not more
# than 40km.

background = pseudoabsencemask(BetweenRadius, presencelayer; closer = 10.0, further = 40.0)

# We finally sample two background points for every cell with at least an
# observation:

absencelayer = backgroundpoints(background, 2sum(presencelayer))

# ::: tip Pseudo-absences
#
# There are many additional ways to define pseudo-absences, all described in
# [the relevant vignette](/manual/generation/pseudoabsences/).
# 
# :::

# At this point, we have a dataset with all the relevant information, and we are
# ready to start training the model.

# ## Training and validating the model

# Our model will use `Maxent` for the prediction, and keep the predictor data as
# they are.

m = SDM(RawData, Maxent, L, presencelayer, absencelayer)

# We can change the hyper-parameters of the model, by allowing product features:

hyperparameters!(classifier(m), :product, true);

# For cross-validation, we will rely on a series of 10 folds:

folds = kfold(m);

# Because we do not know whether all variables are relevant, we will select the
# variables using cross-validation, which will also train the model.

variables!(m, ForwardSelection, folds)

# ::: tip Variable selection
#
# There are additional ways to do variable selection, and they are described in
# the [relevant vignette](/manual/sdm/variableselection/).
#
# :::

# 


# ## Comparing to another model

# It may be a good idea to compare the model with Maxent to another model. We
# will use logistic regression, and select the variables using the same division
# of the dataset.

n = SDM(RawData, Logistic, L, presencelayer, absencelayer)
variables!(n, ForwardSelection, folds)

# In order to compare the two models, we will cross-validate them (note that we
# use a different division of the dataset here):

folds = kfold(m);
cv = crossvalidate(m, folds);
cvl = crossvalidate(n, folds);

# FInally, we can compare the performance of the two models, using a series of
# relevant measures:

ms = [mcc, ppv, npv, f1]
M = permutedims([m(c) for m in ms, c in [cv.training, cv.validation, cvl.training, cvl.validation]]);
M = hcat(["Maxent", "", "Logistic", ""], ["Train.", "Val.", "Train.", "Val."], M);

# These are the results:

pretty_table(
    M;
    alignment = [:l, :l, :c, :c, :c, :c],
    backend = :markdown,
    column_labels = [""; "Dataset"; string.(ms)],
    formatters = [fmt__printf("%5.3f", [3, 4, 5, 6])],
)

# Maxent is not as good as logistic regression for this problem. But because
# this is the Maxent vignette, we will nonetheless keep going with it, for the
# sake of illustration.

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

# ## Related documentation

# ```@meta
# CollapsedDocStrings = true
# ```

# ```@docs; canonical=false
# Maxent
# hyperparameters
# hyperparameters!
# crossvalidate
# ```

# ## References

# ```@bibliography
# Pages = [@__FILE__]
# Style = :authoryear
# ```