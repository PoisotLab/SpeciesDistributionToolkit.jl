# # Value-suppressing and bivariate maps

using SpeciesDistributionToolkit
using CairoMakie
using Statistics
CairoMakie.activate!(; type = "png", px_per_unit = 2) #hide

# get some data

POL = SpeciesDistributionToolkit.gadm("IDN");
spatialextent = SpeciesDistributionToolkit.boundingbox(POL; padding=1.0)

# some layers

provider = RasterData(CHELSA2, BioClim)
val = SDMLayer(
        provider;
        layer = 1,
        spatialextent...
    )
val = trim(mask!(val, POL))

# fake uncertainty with randomness

unc = (val - rand(values(val))).^2.0

# function for VSUP

function _vsup_grid(vbins, ubins, vpal, upal=colorant"#e3e3e3", shrinkage=0.5, exponent=1.0)
    pal = fill(upal, (vbins, ubins))
    for i in 1:ubins
        shrkfac = ((i - 1) / (ubins - 1))^exponent
        subst = 0.5 - shrkfac * shrinkage / 2
        pal[:, i] .= ColorSchemes.cgrad(vpal)[LinRange(0.5 - subst, 0.5 + subst, vbins)]
        # Apply the mix to the uncertain color
        for j in 1:vbins
            pal[j, i] = weighted_color_mean(1 - shrkfac, pal[j, i], upal)
        end
    end
end

# VSUP test - what are the parameters

ubins = 50
vbins = 50
vbin = discretize(val, vbins)
ubin = quantize(unc, ubins) * ubins

pal = _vsup_grid(ubins, vbins, :isoluminant_cgo_70_c39_n256)

# fig-vsup-colorpalette
f = Figure(; size=(800,400))
ax = Axis(f[1, 1]; aspect = DataAspect())
heatmap!(ax, vbin + (ubin - 1) * maximum(vbin); colormap = vcat(pal...))
lines!(ax, POL, color=:black)
hidespines!(ax)
hidedecorations!(ax)
current_figure() #hide

p = PolarAxis(
    f[1, 2];
    theta_0 = -pi / 2.5,
    direction = -1,
    tellheight = false,
    tellwidth = false,
)
surface!(
    p,
    0 .. π/5,
    0 .. 1,
    zeros(size(pal));
    color = reverse(pal),
    shading = NoShading,
)
thetalims!(p, 0, pi/5)
colsize!(f.layout, 1, Relative(0.7))
current_figure()

# Bivariate palette test
