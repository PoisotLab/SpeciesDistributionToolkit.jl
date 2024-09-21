using Revise
using CairoMakie
using SpeciesDistributionToolkit

# Layers for test
spatial_extent = (; left = -4.87, right=9.63, bottom=41.31, top=51.14)
temp_prov = RasterData(WorldClim2, BioClim)
elev_prov = RasterData(WorldClim2, Elevation)
temperature = SDMLayer(temp_prov; layer="BIO1", resolution=2.5, spatial_extent...)
elevation = 1.0SDMLayer(elev_prov; resolution=2.5, spatial_extent...)

# Rescale
function binner(layer, n)
    categories = rescale(layer, 0., 1.)
    n = n - 2
    map!(x -> round(x * (n + 1); digits = 0) / (n + 1), categories.grid, categories.grid)
    return categories
end

# Test
ubins = 4
vbins = 2^(ubins-1)
vbin = quantize(temperature, vbins)*vbins
ubin = quantize(elevation, ubins)*ubins


vpal = [colorant"#d53e4f", colorant"#f46d43", colorant"#fdae61", colorant"#ffffbf", colorant"#e6f598", colorant"#abdda4", colorant"#66c2a5", colorant"#3288bd"]
upal = colorant"#efefef"

pal = fill(upal, (vbins, ubins))
pal[:,1] .= vpal

for i in 2:ubins
    gap = 2^(i-1)
    vpal2 = [LinRange(pal[j,1], pal[j+(gap-1),1], 3)[2] for j in 1:gap:vbins]
    @info ubins - i + 1
    vupal2 = [LinRange(v, upal, ubins)[i] for v in vpal2]
    @info i, length(vupal2)
    @info length(repeat(vupal2, inner=2^(i-1)))
    pal[:,i] .= repeat(vupal2, inner=2^(i-1))
end

pal

vcat(pal...)

f = Figure()
ax = Axis(f[1,1]; aspect=DataAspect())
heatmap!(ax, vbin + (ubin - 1)*maximum(vbin), colormap=vcat(pal...))

p = PolarAxis(f[1,2]; theta_0=-pi/6, direction=-1, tellheight=false, tellwidth=false)
surface!(p, 0..π/3, 0..10, zeros(size(pal)), color=reverse(pal), shading=NoShading)
thetalims!(p, 0, pi/3)
current_figure()
