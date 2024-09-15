using Revise
using SpeciesDistributionToolkit
using GeoJSON
using GeoInterface
using PolygonOps
using CairoMakie
using Downloads

jsonfile = "http://polygons.openstreetmap.fr/get_geojson.py?id=8114679"
out = Downloads.download(jsonfile, tempname())
polygon = GeoJSON.read(out)

poly = polygon[1][1]

lon = extrema(first.(poly))
lat = extrema(last.(poly))

bbox = (; left = lon[1], right = lon[2], bottom = lat[1], top = lat[2])
provider = RasterData(EarthEnv, LandCover)
layer = SDMLayer(provider; layer = "Cultivated and Managed Vegetation", bbox...)

# Clip
prj = SimpleSDMLayers.Proj.Transformation(
    "+proj=longlat +datum=WGS84 +no_defs",
    layer.crs;
    always_xy = true,
)

E, N = eastings(layer), northings(layer)

Threads.@threads for i in axes(layer, 2)
    for j in axes(layer, 1)
        if iszero(inpolygon(prj(E[i], N[j]), poly))
            layer.indices[j, i] = false
        end
    end
end

heatmap(layer; colormap = :navia, axis = (; aspect=DataAspect()))