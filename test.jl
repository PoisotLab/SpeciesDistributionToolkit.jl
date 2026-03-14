using Revise
using CairoMakie
using SpeciesDistributionToolkit
const SDT = SpeciesDistributionToolkit

# Get data
pol = getpolygon(PolygonData(ESRI, Places))["Place name" => "Corse"]

bb = SDT.boundingbox(pol; padding=0.0)

model = SDM(RawData, NaiveBayes, SDeMo.__demodata()...)

L = [SDMLayer(RasterData(CHELSA2, BioClim); bb..., layer=l) for l in 1:19]
mask!(L, pol)

x, y, n = variogram(L[2], 8000, 120)

scatter(x, y, color=n)
vlines!([40.])
current_figure()

function occ(sdm::AbstractSDM; name="[UNNAMED SPECIES]")
    if ~isgeoreferenced(sdm)
        return nothing
    else
        return SDT.OccurrencesInterface.Occurrences([SDT.OccurrencesInterface.Occurrence(name, labels(sdm)[i], sdm.coordinates[i], missing) for i in eachindex(labels(sdm))]...)
    end
end

h = hexagons(bb, 15.; offset=(0, 0))
mocc = occ(model; name="Sitta whiteheadi")

f = Figure()
ax = Axis(f[1,1])

for f in intersect(h, pol).features
    oi = SDT.OccurrencesInterface.Occurrences(mask(mocc, f))
    if ~isempty(oi)
        poly!(ax, f, color=length(presences(oi)) / length(oi), colorrange=(0, 1))
    end
end

f


mask(mocc, h.features[4])

f = Figure()
ax = Axis(f[1,1]; aspect=DataAspect())
poly!(ax, pol, color=:grey90)
scatter!(ax, model, color=labels(model), colormap=[:black, :orange], markersize=4)
lines!(ax, intersect(h, pol), color=:red)
lines!(ax, pol, color=:grey20)
current_figure()
