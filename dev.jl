using Revise
using SpeciesDistributionToolkit
using Statistics
using CairoMakie
using Colors
using ColorBlendModes
using TernaryDiagrams

spatial_extent = (left = -5.77, right = 20.10, top = 49.90, bottom = 41.54)
dataprovider = RasterData(WorldClim2, BioClim)
r1 = SimpleSDMPredictor(dataprovider; layer = "BIO1", resolution = 5.0, spatial_extent...)
r2 = SimpleSDMPredictor(dataprovider; layer = "BIO12", resolution = 5.0, spatial_extent...)
r3 =
    1.0SimpleSDMPredictor(
        RasterData(WorldClim2, Elevation);
        resolution = 5.0,
        spatial_extent...,
    )

# Recode for a bivariate map
n_stops = 4

rscl = 0.0:0.001:1.0
#rscl = (0., 1.)

l1 = rescale(r1, rscl);
l2 = rescale(r2, rscl);
l3 = rescale(r3, rscl);

d1 = Int64.(round.((n_stops - 1) .* l1; digits = 0)) .+ 1
d2 = Int64.(round.((n_stops - 1) .* l2; digits = 0)) .+ 1
d3 = Int64.(round.((n_stops - 1) .* l3; digits = 0)) .+ 1

heatmap(d3)

function bivariator(n1, n2)
    function bv(v1, v2)
        return n2 * (v2 - 1) + v1
    end
    return bv
end

b = bivariator(n_stops, n_stops).(d1, d2)
sort(unique(values(b)))
heatmap(b; colormap = :Spectral, colorrange = (1, n_stops * n_stops))

p0 = colorant"#e8e8e8ff"
p1 = colorant"#5ac8c8ff"
p2 = colorant"#be64acff"
cm1 = LinRange(p0, p1, n_stops)
cm2 = LinRange(p0, p2, n_stops)
cmat = ColorBlendModes.BlendMultiply.(cm1, cm2')
cmap = vec(cmat)

f = Figure(; resolution = (900, 400))

m_biv = Axis(f[1, 1]; aspect = DataAspect())
heatmap!(m_biv, b; colormap = cmap, colorrange = (1, n_stops * n_stops))

m_v2 = Axis(f[2, 1]; aspect = DataAspect())
heatmap!(m_v2, d2; colormap = cm2, colorrange = (1, n_stops))

m_v1 = Axis(f[1, 2]; aspect = DataAspect())
heatmap!(m_v1, d1; colormap = cm1, colorrange = (1, n_stops))

m_leg = Axis(f[2, 2]; aspect = 1, xlabel = "Temperature", ylabel = "Precipitation")
x = LinRange(minimum(r1), maximum(r1), n_stops)
y = LinRange(minimum(r2), maximum(r2), n_stops)
heatmap!(m_leg, x, y, reshape(1:(n_stops * n_stops), (n_stops, n_stops)); colormap = cmap)

current_figure()

# Trivariate plot
void = colorant"#ffffff00"
trip = fill(void, size(l1))
for i in CartesianIndices(trip)
    if !isnothing(l1[i])
        r = l1[i]
        g = l2[i]
        b = l3[i]
        if false
            S = r + g + b
            if S > zero(typeof(S))
                r = r / S
                g = g / S
                b = b / S
            end
        end
        trip[i] = RGBA(r, g, b, 1.0)
    end
end

f = Figure(; resolution = (900, 500))
ax1 = Axis(f[1, 1]; aspect = DataAspect())
heatmap!(ax1, r1; colormap = [:black, :red])
ax2 = Axis(f[2, 1]; aspect = DataAspect())
heatmap!(ax2, r2; colormap = [:black, :green])
ax3 = Axis(f[3, 1]; aspect = DataAspect())
heatmap!(ax3, r3; colormap = [:black, :blue])
axn = Axis(f[1, 2:3]; aspect = DataAspect())
heatmap!(axn, permutedims(trip))


ax = Axis(f[2:3, 3]; aspect=1);

S = values(l1 + l2 + l3)
ord = sortperm(S)

col = RGBA.(values(l1), values(l2), values(l3))

ternaryaxis!(ax; labelx = "Temp", labely = "Prec.", labelz = "Elev.", label_fontsize=0);
ws = rand(10)
ternaryscatter!(
    ax,
    (values(l1)./S)[ord],
    (values(l2)./S)[ord],
    (values(l3)./S)[ord];
    color = col[ord],
    marker = :circle,
    markersize = 1
)

xlims!(ax, -0.2, 1.2)
ylims!(ax, -0.2, 1.2)
hidedecorations!(ax)

current_figure()
