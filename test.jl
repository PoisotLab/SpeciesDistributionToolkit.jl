using Revise
using SpeciesDistributionToolkit
using GeoJSON
using GeoInterface
using PolygonOps
using CairoMakie
using Downloads

countries = "https://raw.githubusercontent.com/datasets/geo-countries/master/data/countries.geojson"
out = Downloads.download(countries, tempname())
countries = GeoJSON.read(out)

idx = findfirst(isequal("ESP"), countries.ISO_A3)
poly = countries.geometry[idx]
GeoInterface.coordinates(poly)[23]

lon = extrema(first.(GeoInterface.coordinates(poly)[1][1]))
lat = extrema(last.(GeoInterface.coordinates(poly)[1][1]))

bbox = (; left = lon[1], right = lon[2], bottom = lat[1], top = lat[2])
provider = RasterData(CHELSA1, BioClim)
layer = SDMLayer(provider; layer = 1, bbox...)

# Clip
prj = SimpleSDMLayers.Proj.Transformation(
    "+proj=longlat +datum=WGS84 +no_defs",
    layer.crs;
    always_xy = true,
)

E, N = eastings(layer), northings(layer)

Threads.@threads for i in axes(layer, 2)
    for j in axes(layer, 1)
        if iszero(inpolygon(prj(E[i], N[j]), GeoInterface.coordinates(poly)[1][1]))
            layer.indices[j, i] = false
        end
    end
end

heatmap(layer; colormap = :navia, axis = (; aspect=DataAspect()))