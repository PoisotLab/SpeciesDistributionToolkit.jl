# # Bivariate and value-suppressing maps

# The package has functions to deal with bivariate maps, as well as
# value-suppressing uncertainty palettes.

using Revise
using SpeciesDistributionToolkit
const SDT = SpeciesDistributionToolkit
using CairoMakie
CairoMakie.activate!(; type = "png", px_per_unit = 2) #hide

# ## Getting data

pol = getpolygon(PolygonData(OpenStreetMap, Places); place = "Corsica");
spatialextent = SDT.boundingbox(pol; padding = 0.1)

# some layers

provider = RasterData(CHELSA2, BioClim)
L = SDMLayer{Float32}[
    SDMLayer(
        provider;
        layer = i,
        spatialextent...,
    ) for i in layers(provider)
]

mask!(L, pol)


# ## Bivariate

bivariate(L[1], L[12]; axis = (aspect = DataAspect(),))

# change number of bins

bivariate(L[1], L[12]; xbins = 25, ybins = 25, axis = (aspect = DataAspect(),))

# 

bivariate(L[1], L[12]; StevensRedBlue()..., axis = (aspect = DataAspect(),))

#

bivariate(L[1], L[12]; StevensYellowPurple()..., axis = (aspect = DataAspect(),))

#

bivariate(L[1], L[12]; StevensBluePurple()..., axis = (aspect = DataAspect(),))

#

bivariate(L[1], L[12]; StevensBlueGreen()..., axis = (aspect = DataAspect(),))

#

bivariate(L[1], L[12]; ArcMapOrangeBlue()..., axis = (aspect = DataAspect(),))

# Model
base_model = SDM(PCATransform, Logistic, SDeMo.__demodata()...)
variables!(base_model, BackwardSelection)
variables!(base_model, ForwardSelection)

# Bootstrapped model
model = Bagging(base_model, 20)
train!(model)

# Get the prediction and uncertainty
val = predict(base_model, L; threshold = false)
unc = predict(model, L; threshold = false, consensus = iqr)

# ## VSUP

vsup(val, unc)

# this needs to be ported

function maketicks(layer, n, r, R)
    ticks, m, M = Makie.PlotUtils.optimize_ticks(
        extrema(layer)...;
        k_min = n - 2,
        k_ideal = n,
        k_max = n + 2,
    )
    rticks = (ticks .- m) ./ (M - m)
    tticks = rticks .* (R - r) .+ r
    return (tticks, string.(round.(ticks; digits = 2)))
end

direction, angle = π / 2, -π

kwargs = (bins = 3, colormap = [:mediumseagreen, :darkorange2], color = colorant"#f0f0f0")

# full example with legend

f = Figure(; size = (400, 600))
ax = Axis(f[1, 1]; aspect = DataAspect())

le = PolarAxis(f[1, 1];
    width = Relative(0.69),
    height = Relative(0.23),
    halign = 0.0,
    valign = 1.0,
    thetaticks = maketicks(val, 4, direction-angle/2, direction+angle/2),
    rticks = maketicks(unc, 2, direction-angle/2, direction+angle/2),
    rticklabelrotation=pi/2
)

vsup!(ax, val, unc; kwargs...)
lines!(ax, pol; color = :black)
vsuplegend!(le, val, unc; kwargs..., direction = direction, span = angle)
autolimits!(le)
tightlimits!(le)
hidespines!(ax)
hidedecorations!(ax)
scatter!(
    le,
    rescale(val, direction - angle / 2, direction + angle / 2),
    rescale(unc, 3, 0);
    color = :grey20,
    markersize = 1,
    alpha = 0.5,
)
current_figure()