# # Conformal prediction of species range

# TODO

using SpeciesDistributionToolkit
using CairoMakie
CairoMakie.activate!(; type = "png", px_per_unit = 3) #hide
import Random #hide
Random.seed!(123451234123121); #hide

# todo

records = OccurrencesInterface.__demodata()
landmass = getpolygon(PolygonData(OpenStreetMap, Places); place = "Oregon")
records = Occurrences(mask(records, landmass))
spatial_extent = SpeciesDistributionToolkit.boundingbox(landmass)

# todo

provider = RasterData(CHELSA2, BioClim)
L = SDMLayer{Float32}[
    SDMLayer(
        provider;
        layer = x,
        spatial_extent...,
    ) for x in eachindex(layers(provider))
];

# todo

mask!(L, landmass)

# todo

presencelayer = mask(first(L), records)
absencemask =
    pseudoabsencemask(BetweenRadius, presencelayer; closer = 40.0, further = 120.0)
absencelayer = backgroundpoints(absencemask, 4sum(presencelayer))

# model

model = SDM(PCATransform, Logistic, L, presencelayer, absencelayer)
variables!(model, ForwardSelection)

# georef?

isgeoreferenced(model)

# train

train!(model)

# ::: warning Model performance
# 
# todo
# 
# :::

# make model prediction

Y = predict(model, L; threshold = false)

# train a conformal with alpha 0.05

conformal = train!(Conformal(0.05), model)

# apply conformal

present, absent, unsure, undetermined = predict(conformal, Y)

# these can then be mapped

# fig-conformal-range
f = Figure(; size = (500, 350))
ax = Axis(f[1, 1]; aspect = DataAspect())
heatmap!(ax, nodata(present, false); colormap = [:darkgreen])
heatmap!(ax, nodata(unsure, false); colormap = [:grey80])
scatter!(ax, records; color = :black, markersize = 12)
lines!(ax, landmass; color = :black)
hidedecorations!(ax)
hidespines!(ax)
current_figure() #hide

# and we can see what the risk level does to the estimation of range size

A = cellarea(Y)

# loop

rls = LinRange(0.01, 0.15, 15)
rangesize = zeros(Float64, 4, length(rls))

# loop

for (i, rl) in enumerate(rls)
    risklevel!(conformal, rl)
    train!(conformal, model)
    pr, ab, un, ud = predict(conformal, Y)
    rangesize[1, i] += sum(mask(A, nodata(pr, false)))
    rangesize[2, i] += sum(mask(A, nodata(ab, false)))
    rangesize[3, i] += sum(mask(A, nodata(un, false)))
    rangesize[4, i] += sum(mask(A, nodata(ud, false)))
end

# now we turn this into a more reasonable scale

rangesize ./= 1e4

# and we plot

# fig-risklevel-effect
f = Figure(; size = (500, 350))
ax = Axis(f[1, 1]; ylabel = "Surface (10⁴ km²)", xlabel = "Risk level α")
scatter!(ax, rls, rangesize[1, :]; label = "Presence")
scatter!(ax, rls, rangesize[2, :]; label = "Absence")
scatter!(ax, rls, rangesize[3, :]; label = "Unsure")
axislegend(ax; position = :lb, nbanks = 3)
current_figure() #hide

# also can be bootstrapped

bagged = Bagging(model, 50)

train!(bagged)

# retrain

risklevel!(conformal, 0.05)
train!(conformal, model)

# custom func

isunsure = (x) -> count(isequal(Set([true, false])), predict(conformal, x))/length(x)

# bootstrapped conformal

B = predict(bagged, L; threshold = false, consensus = isunsure)

# now we plot

# fig-conformal-bootstrap
f = Figure(; size = (500, 350))
ax = Axis(f[2, 1]; aspect = DataAspect())
hm = heatmap!(ax, B; colormap = Reverse(:lipari))
lines!(ax, landmass; color = :black)
Colorbar(f[1, 1], hm; label = "Fraction of unsure samples", vertical = false)
hidedecorations!(ax)
hidespines!(ax)
current_figure() #hide
