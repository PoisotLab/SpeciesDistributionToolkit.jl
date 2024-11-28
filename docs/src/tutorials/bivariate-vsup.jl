# # Value-suppressing and bivariate maps

using SpeciesDistributionToolkit
using CairoMakie
using ColorSchemes
using Statistics
CairoMakie.activate!(; type = "png", px_per_unit = 2) #hide

# get some data

POL = SpeciesDistributionToolkit.gadm("BEL");
spatialextent = SpeciesDistributionToolkit.boundingbox(POL; padding = 0.1)

# some layers

provider = RasterData(CHELSA2, BioClim)
layers = [mask!(SDMLayer(
        provider;
        layer = i,
        spatialextent...,
    ), POL) for i in [1, 3]]

layers = [convert(SDMLayer{Float16}, l) for l in layers]

# unpack

val, unc = layers

# temperature layer

# fig-hm
heatmap(val; axis = (aspect = DataAspect(),))
lines!(POL[1].geometry; color = :black)
current_figure() #hide

# now see the seasonality layer

# fig-hm-unc
heatmap(unc; axis = (aspect = DataAspect(),))
lines!(POL[1].geometry; color = :black)
current_figure() #hide

# ## Value-suppressing uncertainty palette

# function for VSUP

function _vsup_grid(
    vbins,
    ubins,
    vpal;
    upal = colorant"#efefef55",
    s = 0.5,
    k = 1.0,
)
    pal = fill(upal, (vbins, ubins))
    for i in 1:ubins
        shrkfac = ((i - 1) / (ubins - 1))^k
        subst = 0.5 - shrkfac * s / 2
        pal[:, i] .= CairoMakie.cgrad(vpal)[LinRange(0.5 - subst, 0.5 + subst, vbins)]
        # Apply the mix to the uncertain color
        for j in 1:vbins
            pal[j, i] = ColorSchemes.weighted_color_mean(1 - shrkfac, pal[j, i], upal)
        end
    end
    return pal
end

# make discrete values

function discretize(layer, n::Integer)
    categories = rescale(layer, 0.0, 1.0)
    n = n - 2
    map!(x -> round(x * (n + 1); digits = 0) / (n + 1), categories.grid, categories.grid)
    return n * categories
end

# VSUP test - what are the parameters

ubins = 11
vbins = 11
vbin = discretize(quantize(val, vbins), vbins)
ubin = discretize(quantize(unc, ubins), ubins)

pal = _vsup_grid(vbins, ubins, :twelvebitrainbow)

# fig-vsup-colorpalette
f = Figure(; size = (800, 400))
ax = Axis(f[1, 1]; aspect = DataAspect())
heatmap!(ax, vbin + (ubin - 1) * maximum(vbin); colormap = vcat(pal...))
hidespines!(ax)
hidedecorations!(ax)
lines!(POL[1].geometry; color = :black)
current_figure() #hide

# fig-vsup-legend
p = PolarAxis(
    f[1, 2];
    theta_0 = -pi / 2.5,
    direction = -1,
    tellheight = false,
    tellwidth = false,
)
surface!(
    p,
    0 .. π / 5,
    0 .. 1,
    zeros(size(pal));
    color = reverse(pal),
    shading = NoShading,
)
thetalims!(p, 0, pi / 5)
colsize!(f.layout, 1, Relative(0.7))
current_figure() #hide

# ## Bivariate palette
