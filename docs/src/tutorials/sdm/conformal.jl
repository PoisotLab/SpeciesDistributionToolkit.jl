# # Conformal prediction of species range

# This tutorial goes through some of the steps outlined in
# [poisot_conformal_2025](@citet). We will use conformal prediction to identify
# areas in space in which a SDM is uncertain about the outcome of presence and
# absence of the species.

using SpeciesDistributionToolkit
using CairoMakie

# We will work on the distribution of Sasquatch observations in Oregon.

records = OccurrencesInterface.__demodata()
landmass = getpolygon(PolygonData(OpenStreetMap, Places); place = "Oregon")
records = Occurrences(mask(records, landmass))
spatial_extent = SpeciesDistributionToolkit.boundingbox(landmass)

# We will train the model will all 19 BioClim variables from CHELSA2:

provider = RasterData(CHELSA2, BioClim)
L = SDMLayer{Float32}[
    SDMLayer(
        provider;
        layer = x,
        spatial_extent...,
    ) for x in eachindex(layers(provider))
];

mask!(L, landmass)

# We will generate pseudo-absences at random in a radius around each known
# observations. The distance between an observation and a pseudo-absence is
# between 40 and 130 km.

presencelayer = mask(first(L), records)
absencemask =
    pseudoabsencemask(BetweenRadius, presencelayer; closer = 40.0, further = 120.0)
absencelayer = backgroundpoints(absencemask, 2sum(presencelayer))

# ## Training the initial model

# The model for this tutorial is a logistic regression, with self-interactions
# between variables, but no other interactive effects:

model = SDM(RawData, Logistic, L, presencelayer, absencelayer)
hyperparameters!(classifier(model), :interactions, :self)
variables!(model, BackwardSelection)
variables!(model, ForwardSelection)

# We start by checking that this model is georeferenced. This is something we
# will rely on when putting the observations on the map near the end of the
# tutorial.

isgeoreferenced(model)

# ::: warning Model performance
# 
# Conformal prediction requires a good model - it is important to cross-validate
# the model before calibrating the conformal predictor.
# 
# :::

cv = crossvalidate(model, kfold(model))
println("""
Validation MCC: $(mcc(cv.validation)) ± $(ci(cv.validation))
Training MCC:   $(mcc(cv.training)) ± $(ci(cv.training))
""")

# With a trained model, we can make our first (spatial) prediction

Y = predict(model, L; threshold = false)

#figure regular-range
f = Figure(; size = (500, 350))
ax = Axis(f[2, 1]; aspect = DataAspect())
hm = heatmap!(ax, Y; colormap = Reverse(:navia))
lines!(ax, landmass; color = :black)
scatter!(
    ax,
    model;
    color = labels(model),
    marker = [l ? :cross : :hline for l in labels(model)],
    colormap = [:red, :orange],
)
hidedecorations!(ax)
hidespines!(ax)
Colorbar(f[1, 1], hm; label = "Model score", vertical = false)
current_figure() #hide

# ## Calibrating the conformal classifier

# train a conformal with alpha 0.05

conformal = train!(Conformal(0.05), model)

# apply conformal

present, absent, unsure, undetermined = predict(conformal, Y)

# note that if we want to get a single outcome, for example only the unsure
# predictions, we can pass it as a final argument there

unsure = predict(conformal, Y, Set([true, false]))

# We will turn this prediction into a polygon, which will help with some of the
# plotting we will do next:

uns = polygonize(unsure)

# ::: info Turning layers into polygons is long
#
# Not because this is a very hard problem -- simply that because, for now, the
# code works, and it will work faster in a future release.
#
# :::

# We can now visualize the part of the landscape where the model is confident
# about presence (dark green), where the outcome is uncertain (shaded area), and
# the areas where the model is certain about absence (light grey):

#figure conformal-range
f = Figure(; size = (500, 350))
ax = Axis(f[1, 1]; aspect = DataAspect())
heatmap!(ax, nodata(present, false); colormap = [:darkgreen])
poly!(ax, uns; color = :darkgreen, alpha = 0.2)
lines!(
    ax,
    crosshatch(uns; spacing = 0.15, angle = 45);
    color = :darkgreen,
    alpha = 0.5,
    linestyle = :dashdot,
)
lines!(ax, uns; color = :darkgreen, linewidth = 0.5)
lines!(ax, landmass; color = :black)
scatter!(
    ax,
    records;
    color = :white,
    strokecolor = :orange,
    strokewidth = 1,
    markersize = 9,
)
hidedecorations!(ax)
hidespines!(ax)
current_figure() #hide

# Because the risk level α is set by the user, it is a good idea to change it,
# and measure how much of the area ends up associated to different types of
# predictions:

rls = LinRange(0.01, 0.15, 15)
rangesize = zeros(Float64, 4, length(rls))
A = cellarea(Y)

# ::: tip Stability of results
# 
# When looking at the effect of a parameter, it is useful to keep the same split
# of the data when measuring the response of the model. This ensures that the
# only thing that varies is the parameter itself. It is, similarly, a good idea
# to perform several replicates. Because we do none of these things here, the
# next figure will not display a smooth tendency.
# 
# :::

# We will do a simple loop to set the risk level, re-calibrate the conformal
# classifier, and then measure the range associated to each outcome:

for (i, rl) in enumerate(rls)
    risklevel!(conformal, rl)
    train!(conformal, model)
    pr, ab, un, ud = predict(conformal, Y)
    rangesize[1, i] += sum(mask(A, nodata(pr, false)))
    rangesize[2, i] += sum(mask(A, nodata(ab, false)))
    rangesize[3, i] += sum(mask(A, nodata(un, false)))
end

# Because the surface is large, we will express the range in more reasonable units:

rangesize ./= 1e4

# And now, we can plot:

#figure risklevel-effect
f = Figure(; size = (500, 350))
ax = Axis(f[1, 1]; ylabel = "Surface (10⁴ km²)", xlabel = "Risk level α")
scatter!(
    ax,
    rls,
    rangesize[2, :];
    label = "Absence",
    color = :white,
    strokecolor = :grey20,
    strokewidth = 1,
)
scatter!(
    ax,
    rls,
    rangesize[3, :];
    label = "Unsure",
    color = :lime,
    strokecolor = :darkgreen,
    strokewidth = 1,
    marker = :diamond,
)
scatter!(
    ax,
    rls,
    rangesize[1, :];
    label = "Presence",
    color = :darkgreen,
    marker = :rect,
    markersize = 12,
)
axislegend(ax; position = :lb, nbanks = 3)
current_figure() #hide

# ## Continuous estimate of uncertainty

# In this section, we will rely on conformal prediction and boostrapping to
# provide a more quantitative estimate of outcome uncertainty.

# ::: warning This is not best practice
# 
# Nothing that follows is a published technique, or even a particularly well
# tested idea. This section is included for the purpose of (i) notetaking, as
# this may be an idea worth exploring, and (ii) illustrating how the package can
# be used to do new things relatively easily.
# 
# :::

# We start by wrapping our model into a bagged ensemble of 50 sub-models:

bagged = Bagging(model, 50)
train!(bagged)

# We will re-calibrate the conformal predictor (we previously changed it when
# estimating the range):

risklevel!(conformal, 0.05)
train!(conformal, model)

# Because the `bagged` model is an homogenous ensemble, we can write our own
# consensus function to aggregate the outcome of each of the models in the
# ensemble. What we are after is, simply put, the proportion of models that,
# when passed to the conformal predictor, return a decision of "ambiguous",
# _i.e._ they can support both the `true` and `false` outcome.

isunsure = (x) -> count(isequal(Set([true, false])), predict(conformal, x)) / length(x)

# With this function written, we can get the summary of how many models return
# the unsure decision, for each point in the layer:

B = predict(bagged, L; threshold = false, consensus = isunsure)

# And we can finally plot this model, in order to identify areas where most of
# the predictions are uncertain:

#figure conformal-bootstrap
f = Figure(; size = (500, 350))
ax = Axis(f[2, 1]; aspect = DataAspect())
hm = heatmap!(ax, B; colormap = Reverse(:lipari))
lines!(ax, landmass; color = :black)
Colorbar(f[1, 1], hm; label = "Fraction of unsure samples", vertical = false)
hidedecorations!(ax)
hidespines!(ax)
current_figure() #hide

# ## Related documentation

# ```@meta
# CollapsedDocStrings = true
# ```

# ```@docs; canonical=false
# Conformal
# risklevel
# risklevel!
# cellarea
# ```

# ## References

# ```@bibliography
# Pages = [@__FILE__]
# Style = :authoryear
# ```