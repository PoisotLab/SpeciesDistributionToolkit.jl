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
L = SDMLayer{Float16}[
    SDMLayer(
        provider;
        layer = i,
        spatialextent...,
    ) for i in layers(provider)
]

mask!(L, pol)

# Model
base_model = SDM(RawData, Logistic, SDeMo.__demodata()...)
variables!(base_model, ForwardSelection)
model = Bagging(base_model, 10)
bagfeatures!(model)
train!(model)

# Get the prediction and uncertainty
val = predict(model, L; threshold = false)
unc = predict(model, L; threshold = false, consensus = iqr)

# ## Bivariate

bivariate(val, unc; axis=(aspect=DataAspect(),))

# change number of bins

bivariate(val, unc; xbins = 25, ybins = 25, axis=(aspect=DataAspect(),))

# 

bivariate(val, unc; StevensRedBlue()..., axis=(aspect=DataAspect(),))

#

bivariate(val, unc; StevensYellowPurple()..., axis=(aspect=DataAspect(),))

#

bivariate(val, unc; StevensBluePurple()..., axis=(aspect=DataAspect(),))

#

bivariate(val, unc; StevensBlueGreen()..., axis=(aspect=DataAspect(),))

#

bivariate(val, unc; ArcMapOrangeBlue()..., axis=(aspect=DataAspect(),))

# ## VSUP

vsup(val, unc)

# this needs to be ported

function angular_ticks(layer, direction, span, n)
    ticks = collect(range(direction-span/2, direction+span/2, n))
    labels = collect(range(extrema(layer)..., n))
    return (ticks, string.(labels))
end

ticks, m, M = Makie.PlotUtils.optimize_ticks(
            extrema(val)...;
            k_min = 5,
            k_ideal = 5,
            k_max = 5,
        )

direction, angle = π/2, -π
rticks = (ticks .- m) ./ (M - m)
base = direction - angle/2
tticks = base .+ rticks .* angle
kwargs = (bins = 3, colormap = [:teal, :orange], color = colorant"#d0d0d0")

# full example with legend

f = Figure(; size=(400, 600))
ax = Axis(f[1, 1]; aspect = DataAspect())

le = PolarAxis(f[1, 1];
    width = Relative(0.65),
    height = Relative(0.23),
    halign = 0.0,
    valign = 1.0,
    thetaticks = (tticks, string.(round.(ticks; digits=2))))

vsup!(ax, val, unc; kwargs...)
lines!(ax, pol, color=:black)
vsuplegend!(le, val, unc; kwargs..., direction = direction, span = angle)
autolimits!(le)
tightlimits!(le)
hidespines!(ax)
hidedecorations!(ax)
scatter!(le, rescale(val, direction-angle/2, direction+angle/2), rescale(unc, 3, 0), color=:black, markersize=1, alpha=0.5)
current_figure()