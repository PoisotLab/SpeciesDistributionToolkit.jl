function GBIF.occurrences(t::GBIFTaxon, layer::SDMLayer, query::Pair...)
    spatial_extent = SpeciesDistributionToolkit.boundingbox(layer; padding=0.0)
    query = (query..., "decimalLatitude" => (spatial_extent.bottom, spatial_extent.top))
    query = (query..., "decimalLongitude" => (spatial_extent.left, spatial_extent.right))
    query = (query..., "hasCoordinate" => true)
    return occurrences(t, query...)
end

function GBIF.occurrences(layer::SDMLayer, query::Pair...)
    spatial_extent = SpeciesDistributionToolkit.boundingbox(layer; padding=0.0)
    query = (query..., "decimalLatitude" => (spatial_extent.bottom, spatial_extent.top))
    query = (query..., "decimalLongitude" => (spatial_extent.left, spatial_extent.right))
    query = (query..., "hasCoordinate" => true)
    return occurrences(query...)
end
