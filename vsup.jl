using Revise
using CairoMakie
using SpeciesDistributionToolkit
const SDT = SpeciesDistributionToolkit

pol = getpolygon(PolygonData(OpenStreetMap, Places); place="Corsica");
spatialextent = SDT.boundingbox(pol; padding = 0.1)

# some layers

provider = RasterData(CHELSA2, BioClim)
L = SDMLayer{Float16}[SDMLayer(
        provider;
        layer = i,
        spatialextent...,
    ) for i in layers(provider)]

mask!(L, pol)

# Model
model = SDM(RawData, Logistic, SDeMo.__demodata()...)
variables!(model, ForwardSelection)
predict(model, L; threshold=false) |> heatmap

ens = Bagging(model, 50)
bagfeatures!(ens)
train!(ens)

# unpack

val = predict(model, L; threshold=false)
unc = predict(ens, L; threshold=false, consensus=iqr)

# temperature layer

# fig-hm
heatmap(val; axis = (aspect = DataAspect(),))
lines!(pol; color = :black)
current_figure() #hide

# now see the seasonality layer

# fig-hm-unc
heatmap(unc; axis = (aspect = DataAspect(),))
lines!(pol; color = :black)
current_figure() #hide

# ## Value-suppressing uncertainty palette

# function for VSUP

function _vsup_grid(vbins, ubins, vpal; upal = colorant"#ffffff", s = 0.5, k = 1.0)
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

ubins = 7
vbins = 7
vbin = discretize(quantize(val, vbins), vbins)
ubin = discretize(quantize(unc, vbins), ubins)

pal = _vsup_grid(vbins, ubins, :cividis; k=1.2, s=0.5)

# fig-vsup-colorpalette
f = Figure(; size = (800, 400))
ax = Axis(f[1, 1]; aspect = DataAspect())

# TODO
# This is not working because the way to get the uncertainty rank is wrong here, high values should lead to more white, and low values to more color

heatmap!(ax, vbin + (maximum(vbin) - ubin + 1) * maximum(vbin); colormap = vcat(pal...))
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
    -π/4 .. π/4,
    0 .. 1,
    zeros(size(pal));
    color = reverse(pal),
    shading = NoShading,
)
thetalims!(ax_inset, -pi/4, pi / 4)
rlims!(ax_inset, 0.1, 1)
current_figure() #hide
