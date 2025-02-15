using Revise
using BenchmarkTools

using SpeciesDistributionToolkit

spatial_extent = (left = 8.412, bottom = 41.325, right = 9.662, top = 43.060)
species = taxon("Sitta whiteheadi"; strict = false)
query = [
    "occurrenceStatus" => "PRESENT",
    "hasCoordinate" => true,
    "decimalLatitude" => (spatial_extent.bottom, spatial_extent.top),
    "decimalLongitude" => (spatial_extent.left, spatial_extent.right),
    "limit" => 300,
]
presences = occurrences(species, query...)
for i in 1:3
    occurrences!(presences)
end

dataprovider = RasterData(CHELSA1, BioClim)
temperature = 0.1SDMLayer(dataprovider; layer = "BIO1", spatial_extent...)

presencelayer = mask(temperature, presences)

@benchmark pseudoabsencemask(DistanceToEvent, presencelayer)
background = pseudoabsencemask(DistanceToEvent, presencelayer)

function _distances_on_layer(presences::SDMLayer{Bool}, f::Function)
    SpeciesDistributionToolkit._layer_works_for_pseudoabsence(presences)
    presence_only = nodata(presences, false)
    background = zeros(presences, Float64)

    prj = SimpleSDMLayers.Proj.Transformation(
        origin.crs,
        "+proj=longlat +datum=WGS84 +no_defs";
        always_xy = true,
    )

    d = SpeciesDistributionToolkit.Fauxcurrences._distancefunction

    E, N = eastings(presences), northings(presences)

    points = [prj(E[i.I[2]], N[i.I[1]]) for i in keys(presence_only)]

    for k in keys(background)
        pk = prj(E[k.I[2]], N[k.I[1]])
        background[k] = f([d(pk, ko) for ko in points])
    end

    return background
end

function fastdistance(origin, f, s)

    destination = SDMLayer(zeros(eltype(origin), s...), BitArray(ones(s...)), origin.x, origin.y, origin.crs)

    prj = SimpleSDMLayers.Proj.Transformation(
            origin.crs,
            "+proj=longlat +datum=WGS84 +no_defs";
            always_xy = true,
        )

    E, N = eastings(origin), northings(origin)
    pres = keys(nodata(origin, false))
    points = [prj(E[i.I[2]], N[i.I[1]]) for i in pres]
    for p in points
        destination[p...] = true
    end

    newbg = _distances_on_layer(destination, f)
    return mask(SimpleSDMLayers.interpolate!(convert(SDMLayer{eltype(newbg)}, copy(origin)), newbg), origin)
end

bgsample = fastdistance(presencelayer, minimum, (200, 200))
background

@benchmark fastdistance(presencelayer, minimum, (100, 100))

extrema(bgsample - background)
extrema(bgsample)
extrema(background)