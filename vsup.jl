using Revise
using CairoMakie
using SpeciesDistributionToolkit
const SDT = SpeciesDistributionToolkit

pol = getpolygon(PolygonData(NaturalEarth, Countries))["Belgium"];
spatialextent = SDT.boundingbox(pol; padding = 0.1)

# some layers

provider = RasterData(CHELSA2, BioClim)
layers = SDMLayer{Float16}[SDMLayer(
        provider;
        layer = i,
        spatialextent...,
    ) for i in [1, 3]]

mask!(layers, pol)

# unpack

val, unc = layers
val.x = unc.x
val.y = unc.y

# temperature layer

# fig-hm
heatmap(val; axis = (aspect = DataAspect(),))
lines!(pol; color = :black)
current_figure() #hide

# now see the seasonality layer

# fig-hm-unc
heatmap(unc; axis = (aspect = DataAspect(),))
lines!(pol.geometry; color = :black)
current_figure() #hide

# ## Value-suppressing uncertainty palette

# function for VSUP

function _vsup_grid(vbins, ubins, vpal; upal = colorant"#efefef00", s = 0.5, k = 1.0)
    pal = fill(upal, (vbins, ubins))
    for i in 1:ubins
        shrkfac = ((i - 1) / (ubins - 1))^k
        subst = 0.5 - shrkfac * s / 2
        pal[:, i] .= Makie.cgrad(vpal)[LinRange(0.5 - subst, 0.5 + subst, vbins)]
        # Apply the mix to the uncertain color
        for j in 1:vbins
            pal[j, i] = Makie.ColorSchemes.weighted_color_mean(1 - shrkfac, pal[j, i], upal)
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
vbins = 25
vbin = discretize(quantize(val, vbins), vbins)
vbin.x = val.x
vbin.y = val.y
ubin = discretize(quantize(unc, ubins), ubins)
ubin.x = unc.x
ubin.y = unc.y

pal = _vsup_grid(vbins, ubins, :managua; k=2.0)

# fig-vsup-colorpalette
f = Figure(; size = (800, 400))
ax = Axis(f[1, 1]; aspect = DataAspect())
heatmap!(ax, vbin + (ubin - 1) * maximum(vbin); colormap = vcat(pal...))
hidespines!(ax)
hidedecorations!(ax)
lines!(pol; color = :black)
current_figure() #hide

ax_inset = PolarAxis(f[1, 1];
    width = Relative(0.25),
    height = Relative(0.5),
    halign = 0.0,
    valign = 0.0,
    theta_0 = pi,
    direction = -1,
    tellheight = false,
    tellwidth = false,
    rgridvisible=false,
    thetagridvisible=false
    )

surface!(
    ax_inset,
    0 .. π / 3,
    0 .. 1,
    zeros(size(pal));
    color = reverse(pal),
    shading = NoShading,
)
thetalims!(ax_inset, 0, pi / 3)
rlims!(ax_inset, 0.1, 1)
current_figure() #hide
