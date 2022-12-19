using Revise
using SpeciesDistributionToolkit
using Statistics
using CairoMakie

spatial_extent = (left = -24.785, right = -12.634, top = 66.878, bottom = 62.935)
dataprovider = RasterData(WorldClim2, BioClim)
r1 = SimpleSDMPredictor(dataprovider; layer = "BIO1", resolution=5.0, spatial_extent...)
r2 = SimpleSDMPredictor(dataprovider; layer = "BIO12", resolution=5.0, spatial_extent...)

# Recode for a bivariate map
n_stops = 3

l1 = rescale(r1, (0.0, 1.0));
l2 = rescale(r2, (0.0, 1.0));

d1 = Int64.(round.((n_stops-1) .* l1; digits=0)).+1
d2 = Int64.(round.((n_stops-1) .* l2; digits=0)).+1

heatmap(d1)

function bivariator(n1, n2)
    function bv(v1, v2)
        return n2*(v2-1) + v1
    end
    return bv
end

b = bivariator(n_stops, n_stops).(d1, d2)
sort(unique(values(b)))
heatmap(b, colormap=:Spectral, colorrange=(1, n_stops*n_stops))

p0=colorant"#e8e8e8ff"
p1=colorant"#73ae80ff"
p2=colorant"#6c83b5ff"
cm1 = LinRange(p0, p1, n_stops)
cm2 = LinRange(p0, p2, n_stops)
cmat = ColorBlendModes.BlendMultiply.(cm1, cm2')
cmap = vec(cmat)
heatmap(d1, colormap=cm1)
heatmap(d2; colormap = cm2)
heatmap(b; colormap = cmap, colorrange = (1, n_stops*n_stops))

x = LinRange(minimum(r1), maximum(r1), n_stops)
y = LinRange(minimum(r2), maximum(r2), n_stops)
heatmap(x, y, reshape(1:(n_stops*n_stops), (n_stops, n_stops)), colormap=cmap, axis=(;xlabel="Temperature", ylabel="Precipitation"))