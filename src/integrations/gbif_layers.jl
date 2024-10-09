function _bbox_from_layer(layer::SDMLayer)
    EL = eastings(layer)
    NL = northings(layer)
    prj = SimpleSDMLayers.Proj.Transformation(
        layer.crs,
        "+proj=longlat +datum=WGS84 +no_defs";
        always_xy = true,
    )

    b1 = [prj(EL[1], n) for n in NL]
    b2 = [prj(EL[end], n) for n in NL]
    b3 = [prj(e, NL[1]) for e in EL]
    b4 = [prj(e, NL[end]) for e in EL]
    bands = vcat(b1, b2, b3, b4)

    nx = extrema(first.(bands))
    ny = extrema(last.(bands))
    return (; left = nx[1], right = nx[2], bottom = ny[1], top = ny[2])
end

function GBIF.occurrences(t::GBIFTaxon, layer::SDMLayer, query::Pair...)
    spatial_extent = SpeciesDistributionToolkit._bbox_from_layer(layer)
    query = (query..., "decimalLatitude" => (spatial_extent.bottom, spatial_extent.top))
    query = (query..., "decimalLongitude" => (spatial_extent.left, spatial_extent.right))
    query = (query..., "hasCoordinate" => true)
    return occurrences(t, query...)
end

function GBIF.occurrences(layer::SDMLayer, query::Pair...)
    spatial_extent = SpeciesDistributionToolkit._bbox_from_layer(layer)
    query = (query..., "decimalLatitude" => (spatial_extent.bottom, spatial_extent.top))
    query = (query..., "decimalLongitude" => (spatial_extent.left, spatial_extent.right))
    query = (query..., "hasCoordinate" => true)
    return occurrences(query...)
end
