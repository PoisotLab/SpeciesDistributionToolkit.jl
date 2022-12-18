using Revise
using SpeciesDistributionToolkit
using Statistics
using CairoMakie

spatial_extent = (left = -24.785, right = -12.634, top = 66.878, bottom = 62.935)
dataprovider = RasterData(WorldClim2, BioClim)
l1 = SimpleSDMPredictor(dataprovider; layer = "BIO1", resolution=5.0, spatial_extent...)
l2 = SimpleSDMPredictor(dataprovider; layer = "BIO12", resolution=5.0, spatial_extent...)

# Recode for a bivariate map
rescale!(l1, (0.0, 1.0));
rescale!(l2, (0.0, 1.0));

n_stops = 4

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

p0=colorant"#f8f8f8ff"
p1=colorant"#64acbeff"
p2=colorant"#c85a5aff"
cm1 = LinRange(p0, p1, n_stops)
cm2 = LinRange(p0, p2, n_stops)
cmat = ColorBlendModes.BlendMultiply.(cm1, cm2')
cmap = vec(cmat)
heatmap(l1, colormap=cm1)
heatmap(l2; colormap = cm2)
heatmap(b; colormap = cmap, colorrange = (1, n_stops*n_stops))
heatmap(reshape(1:(n_stops*n_stops), (n_stops, n_stops)), colormap=cmap)